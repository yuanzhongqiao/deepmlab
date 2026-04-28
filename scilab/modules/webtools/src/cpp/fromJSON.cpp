/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#include <iostream>
#include "json.hxx"
#include "fromJSON.hxx"

template<typename T>
static void rowToColMajor(T* in, T* out, int iSize, std::vector<int>& vDims)
{
    size_t i2Dsize = vDims[0] * vDims[1];
    for(size_t i = 0; i < (iSize / i2Dsize); i++)
    {
        for(size_t j = 0; j < i2Dsize; j++)
        {
            std::swap(out[j], in[(j / vDims[0]) + (j % vDims[0]) * vDims[1]]);
        }
        out += i2Dsize;
        in  += i2Dsize;
    }
}

static inline void arrayToMatrix(StepAny* current, int iStart = 0)
{
    // ending an ND array, create the types::Arrayof<>
    auto vDims = current->dims_array;
    switch(vDims.size())
    {
        case 0: vDims.push_back(1);
        case 1: vDims.push_back(1); break;
        default: std::reverse(vDims.begin(), vDims.end());
    }

    std::swap(vDims[0], vDims[1]);
    switch(current->type)
    {
        case ScilabType::ScilabDouble:
        {
            types::Double* pOut = new types::Double(vDims.size(), vDims.data());
            auto& data = static_cast<Step<double>*>(current)->array;
            if(pOut->isScalar() && std::isfinite(data[iStart]) == false && current->isArray == false)
            {
                // [1, null, ""a string""...
                // the null have been converted into a nan,
                // change it to [] before happend it the the list
                pOut->killMe();
                pOut = types::Double::Empty();
            }
            else
            {
                rowToColMajor(data.data() + iStart, pOut->get(), pOut->getSize(), vDims);
            }

            current->container = pOut;
        }
        break;
        case ScilabType::ScilabString:
        {
            types::String* pOut = new types::String(vDims.size(), vDims.data());
            current->container = pOut;
            auto& data = static_cast<Step<wchar_t*>*>(current)->array;
            rowToColMajor(data.data() + iStart, pOut->get(), pOut->getSize(), vDims);
        }
        break;
        case ScilabType::ScilabBool:
        {
            types::Bool* pOut = new types::Bool(vDims.size(), vDims.data());
            current->container = pOut;
            auto& data = static_cast<Step<int>*>(current)->array;
            rowToColMajor(data.data() + iStart, pOut->get(), pOut->getSize(), vDims);
        }
        break;
        case ScilabType::ScilabStruct:
        {
            types::Struct* pOut = new types::Struct(vDims.size(), vDims.data(), false);
            current->container = pOut;
            auto& data = static_cast<Step<types::SingleStruct*>*>(current)->array;
            rowToColMajor(data.data() + iStart, pOut->get(), pOut->getSize(), vDims);
        }
        break;
        default: break;
    }
}

bool sax_json_scilab::insertInParent(StepAny* current)
{
    m_steps.pop();
    StepAny* parent = m_steps.top();
    bool ret = true;
    if(parent->type == ScilabType::ScilabStruct)
    {
        // insert current in field: { "f": [1,2,3]...  or { "f": { "foo": 42 }...
        auto s = static_cast<Step<types::SingleStruct*>*>(parent);
        s->array[s->flat_size - 1]->set(parent->field, current->container);
    }
    else if(parent->type == ScilabType::ScilabList)
    {
        // insert current as List element: [1, "e", [1, 2, 3]...  or [1, "e", { "foo": 42 }...
        parent->container->getAs<types::List>()->append(current->container);
    }
    else
    {
        // Unmanaged case, may never happen
        m_error = "Cannot insert a JSON element in something else than a Scilab struct or list.";
        ret = false;
    }

    delete current;
    return ret;
}

int sax_json_scilab::convertToList(StepAny* current, int iChangeType)
{
    auto& dims_array = current->dims_array;
    auto& dims_size = current->dims_size;
    int iPos = 0;

    // compute the full ND array size
    current->dim += iChangeType;
    int d = current->dim;
    for(int i = 0; i < d; i++)
    {
        if(iPos >= current->flat_size)
        {
            break;
        }

        int n = current->dims_size[0];
        dims_size.erase(dims_size.begin());
        dims_array.erase(dims_array.begin());
        current->dim--;

        int elem_size = 1;
        for(auto d : dims_array)
        {
            elem_size *= d ? d : 1;
        }

        // convert data to types::Double and append them to a types::List
        types::List* pList = new types::List();
        for(int i = 0; i < n; i++)
        {
            // fill current.container
            arrayToMatrix(current, iPos);
            iPos += elem_size;
            pList->append(current->container);
        }
        m_steps.push(new StepAny(pList));
    }

    return iPos;
}

bool sax_json_scilab::null()
{
    // return []
    if(m_steps.empty())
    {
        StepAny* s = new StepAny(types::Double::Empty());
        m_steps.push(s);
        return true;
    }

    StepAny* current = m_steps.top();
    if(current->type == ScilabType::ScilabDouble || current->type == ScilabType::ScilabNull)
    {
        // [1, null, ...
        // [null, ...
        return setValue<double, types::Double>(std::numeric_limits<double>::quiet_NaN(), ScilabType::ScilabDouble);
    }

    if(current->type == ScilabType::ScilabStruct)
    {
        // { "field": null...
        Step<types::SingleStruct*>* s = static_cast<Step<types::SingleStruct*>*>(current);
        s->array[s->flat_size - 1]->set(current->field, types::Double::Empty());
        return true;
    }

    if(current->type == ScilabType::ScilabList)
    {
        // [1, "a", null...
        current->container->getAs<types::List>()->append(types::Double::Empty());
        return true;
    }

    // convert the current step to a list and append []
    // ["a", null...
    return setValue<double, types::Double>(0, ScilabType::ScilabNull);
}

bool sax_json_scilab::start_array()
{
    // root: [... ||
    // new array element of a struct field: { "f": [...
    // new array element of a List: [1, "e", [...
    if(m_steps.empty() || m_steps.top()->hasField || m_steps.top()->type == ScilabType::ScilabList)
    {
        m_steps.push(new StepAny());
        return true;
    }

    // new dimension of an existing array: [[...
    StepAny* current = m_steps.top();
    current->dim++;
    if(current->type == ScilabType::ScilabNull)
    {
        current->dims_array.push_back(0);
        current->dims_size.push_back(0);
    }
    else
    {
        current->dims_size[current->dim] = 0;
    }

    return true;
}

bool sax_json_scilab::end_array()
{
    StepAny* current = m_steps.top();
    if(current->type == ScilabType::ScilabNull)
    {
        if(current->dim > 0)
        {
            // [[]... : create a list that start with an empty matrix
            m_steps.pop();
            delete current;
            m_steps.push(new StepAny(new types::List()));
            m_steps.push(new StepAny(types::Double::Empty()));
            current = m_steps.top();
        }
        else
        {
            // ending an empty array: []
            current->container = types::Double::Empty();
        }
    }
    else if(current->type != ScilabType::ScilabList)
    {
        // ending an array: [[[]...
        int current_dim_size = current->dims_size[current->dim];
        if(current->dims_array[current->dim])
        {
            // check size consistency
            if(current->dims_array[current->dim] != current_dim_size)
            {
                // size differ -> convert to list
                m_steps.pop();
                int pos = convertToList(current, 0);
                if(pos == current->flat_size)
                {
                    current->container = types::Double::Empty();
                }
                else
                {
                    current->dims_array[current->dim] = current_dim_size;
                    arrayToMatrix(current, pos);
                }
                
                m_steps.top()->container->getAs<types::List>()->append(current->container);
                delete current;
                return true;
            }
        }
        else
        { 
            // first array end for this dimention, 
            // set size to be able to check size consistency later.
            current->dims_array[current->dim] = current_dim_size;
        }

        // all dimensions are not yet ended: [[[]]...
        // decrease the current dim and increase counter of parent dimension
        if(current->dim)
        {
            current->dim--;
            current->dims_size[current->dim]++;
            return true;
        }

        // ending the top level array: [[[]]]
        // fill current.container with the InternalType*
        arrayToMatrix(current);
    }

    // manage child element insertion in parent
    if(m_steps.size() > 1)
    {
        return insertInParent(current);
    }

    return true;
}

bool sax_json_scilab::start_object()
{
    // root struct: { ...
    // non array struct: "field": { ...
    // struct as list element: [1, {...
    if(m_steps.empty() || m_steps.top()->hasField || m_steps.top()->type == ScilabType::ScilabList)
    {
        m_steps.push(new Step<types::SingleStruct*>(ScilabType::ScilabStruct));
        m_steps.top()->isArray = false;
    }

    // struct array: [{ }, {...
    types::SingleStruct* pSingle = new types::SingleStruct();
    pSingle->IncreaseRef();
    return setValue<types::SingleStruct*, types::Struct>(pSingle, types::InternalType::ScilabStruct);
}

bool sax_json_scilab::end_object()
{
    StepAny* current = m_steps.top();
    if(current->type != ScilabType::ScilabStruct)
    {
        // must never happen !
        m_error = "Ending something else than a JSON object";
        return false;
    }

    // struct array
    if(current->isArray)
    {
        auto step = static_cast<Step<types::SingleStruct*>*>(current);
        // check SingleStructs field names
        if(step->array.size() > 1)
        {
            auto fields = step->array[0]->getFields();
            auto currentFields = step->array[step->flat_size - 1]->getFields();
            bool convert = fields.size() != currentFields.size();
            if(convert == false)
            {
                for(const auto& f : currentFields)
                {
                    if(fields.find(f.first) == fields.end())
                    {
                        convert = true;
                        break;
                    }
                }
            }

            if(convert)
            {
                // number of fields or field names differ between SingleStructs
                // convert the ND Struct to a List of scalar Structs
                m_steps.pop();
                convertToList(step, 1);
                delete step;
                return true;
            }
        }

        // go to next struct
        current->field = L"";
        current->hasField = false;
        return true;
    }

    Step<types::SingleStruct*>* pSingleStruct = static_cast<Step<types::SingleStruct*>*>(current);
    types::Struct* pStruct = nullptr;
    if(pSingleStruct->array[0]->getFields().empty())
    {
        // empty struct
        pStruct = new types::Struct();
    }
    else
    {
        // scalar struct
        pStruct = new types::Struct(1, 1, false);
        std::swap(pSingleStruct->array[0], pStruct->get()[0]);
    }

    current->container = pStruct;

    // root struct
    if(m_steps.size() == 1)
    {
        return true;
    }

    // insert current scalar struct in parent
    return insertInParent(current);
}

bool sax_json_scilab::key(std::string& val)
{
    if(m_steps.top()->type != ScilabType::ScilabStruct)
    {
        // must never happen !
        m_error = "Key found in a non Struct element.";
        return false;
    }

    std::wstring wField = scilab::UTF8::toWide(val);
    auto current = static_cast<Step<types::SingleStruct*>*>(m_steps.top());
    current->array[current->flat_size - 1]->addField(wField);
    current->field = wField;
    current->hasField = true;

    return true;
}

types::InternalType* fromJSON(const std::string& s, std::string& err)
{
    ScilabHandler handler;
    Reader reader;
    StringStream ss(s.data());
    bool bOK = reader.Parse<kParseNanAndInfFlag|kParseFullPrecisionFlag>(ss, handler);
    if(bOK == false)
    {
        ParseErrorCode e = reader.GetParseErrorCode();
        size_t o = reader.GetErrorOffset();
        std::ostringstream os;
        const char* err_msg = GetParseError_En(e);
        size_t err_len = strlen(err_msg);
        // err_len-1: remove the dot at the end of the string returned by GetParseError_En(e).
        os << std::string(err_msg, err_len-1) << " at offset " << o;
        if(s.substr(o, 10) != "")
        {
            os << " near `" << s.substr(o, 10) << "`";
        }
        err = os.str();
        return nullptr;
    }

    return handler.sax.getResult();
}