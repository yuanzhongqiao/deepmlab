/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#ifndef __FROMJSON_HXX__
#define __FROMJSON_HXX__

#include <stack>

#include "UTF8.hxx"
#include "struct.hxx"
#include "double.hxx"
#include "string.hxx"
#include "bool.hxx"

#include "rapidjson/reader.h"
#include "rapidjson/error/en.h"
using namespace rapidjson;

using ScilabType = types::InternalType::ScilabType;

extern "C"
{
#include "api_scilab.h"
#include "dynlib_webtools.h"
}

class StepAny {
public:
    StepAny(): type(ScilabType::ScilabNull), container(nullptr), isArray(true), hasField(false),
        flat_size(0), dim(0), dims_size({0}), dims_array({0}), field(L"") {}

    StepAny(ScilabType t, types::InternalType* pIT, int i, int d, std::vector<int> ds, std::vector<int> da, std::wstring f):
        type(t), container(pIT), isArray(true), hasField(false), flat_size(i), dim(d), dims_size(ds), dims_array(da), field(f) {}

    StepAny(ScilabType t): type(t), container(nullptr), isArray(true), hasField(false),
        flat_size(0), dim(0), dims_size({0}), dims_array({0}), field(L"") {}

    StepAny(types::InternalType* pIT, bool idx = 0): container(pIT), isArray(true), hasField(false),
        flat_size(idx), dim(0), dims_size({0}), dims_array({0}), field(L"")
    {
        type = pIT->getType();
    }

    virtual ~StepAny()
    {
        if(container)
        {
            container->killMe();
        }
    }

    ScilabType type;
    types::InternalType* container;
    bool isArray;
    bool hasField;
    int flat_size;
    int dim;
    std::vector<int> dims_size;
    std::vector<int> dims_array;
    std::wstring field;
};

template <typename T>
class Step: public StepAny {
public:
    Step(StepAny* s): StepAny(s->type, s->container, s->flat_size, s->dim, s->dims_size, s->dims_array, s->field), array({}) {}
    Step(ScilabType t): StepAny(t), array({}) {}
    std::vector<T> array;
    ~Step() {}
};

template <>
class Step<wchar_t*>: public StepAny {
public:
    Step(StepAny* s): StepAny(s->type, s->container, s->flat_size, s->dim, s->dims_size, s->dims_array, s->field), array({}) {}
    Step(ScilabType t): StepAny(t), array({}) {}
    std::vector<wchar_t*> array;
    ~Step()
    {
        for(auto elem : array)
        {
            if(elem)
            {
                FREE(elem);
            }
        }
    }
};

template <>
class Step<types::SingleStruct*>: public StepAny {
public:
    Step(StepAny* s): StepAny(s->type, s->container, s->flat_size, s->dim, s->dims_size, s->dims_array, s->field), array({}) {}
    Step(ScilabType t): StepAny(t), array({}) {}
    std::vector<types::SingleStruct*> array;
    ~Step()
    {
        for(auto elem : array)
        {
            if(elem)
            {
                elem->DecreaseRef();
                elem->killMe();
            }
        }
    }
};

class sax_json_scilab
{
private:
    std::string m_error;
    std::stack<StepAny*> m_steps;

    bool insertInParent(StepAny* current);
    int convertToList(StepAny* current, int iChangeType);

    template<typename T, typename U>
    bool setValue(T val, ScilabType type)
    {
        if (m_steps.empty())
        {
            U* pIT = new U(1, 1);
            std::swap(val, pIT->get()[0]);
            m_steps.push(new StepAny(pIT, 1));
            return true;
        }

        StepAny* current = m_steps.top();
        if (current->type == ScilabType::ScilabNull)
        {
            // change from an StepAny to a specialized Step
            Step<T>* s = new Step<T>(current);
            s->type = type;
            m_steps.pop();
            delete current;
            m_steps.push(s);
            current = s;
        }

        // fill array of same type and at the last dimension
        if (current->type == type && (size_t)current->dim == current->dims_size.size() - 1)
        {
            Step<T>* s = static_cast<Step<T>*>(current);
            s->array.push_back(val);
            s->dims_size.back()++;
            s->flat_size++;
            return true;
        }

        // insert element in another type
        if (current->type == ScilabType::ScilabStruct)
        {
            U* pIT = new U(1, 1);
            std::swap(val, pIT->get()[0]);
            Step<types::SingleStruct*>* s = static_cast<Step<types::SingleStruct*>*>(current);
            s->array[s->flat_size - 1]->set(current->field, pIT);
            return true;
        }

        if (current->type == ScilabType::ScilabList)
        {
            U* pIT = new U(1, 1);
            std::swap(val, pIT->get()[0]);
            current->container->getAs<types::List>()->append(pIT);
            return true;
        }

        m_steps.pop();
        // will be converted to a List, no more considere it as an array
        // used to convert already stored scalar NaN as []. [1, null, true] => list(1, [], %t)
        current->isArray = false;
        convertToList(current, 1);
        if (current->dim)
        {
            // type change for another array type: [[1,2,3], ["a"...
            Step<T>* s = new Step<T>(type);
            s->dims_array = std::vector<int>(current->dim, 0);
            s->dims_size = std::vector<int>(current->dim, 0);
            s->dim = current->dim - 1;
            s->array.push_back(val);
            s->dims_size[s->dim]++;
            s->flat_size++;
            m_steps.push(s);
        }
        else if (type == ScilabType::ScilabStruct)
        {
            // type change for non struct array: [[[...]], {...
            Step<T>* s = new Step<T>(ScilabType::ScilabStruct);
            s->isArray = false;
            s->array.push_back(val);
            s->flat_size++;
            m_steps.push(s);
        }
        else
        {
            if(type == ScilabType::ScilabNull)
            {
                // ["a", null...
                m_steps.top()->container->getAs<types::List>()->append(types::Double::Empty());
            }
            else
            {
                // type change for a non array value: [[1,2,3], "a"...
                U* pIT = new U(1, 1);
                std::swap(val, pIT->get()[0]);
                m_steps.top()->container->getAs<types::List>()->append(pIT);
            }
        }

        delete current;
        return true;
    }

public:
    ~sax_json_scilab()
    {
        while(m_steps.empty() == false)
        {
            delete m_steps.top();
            m_steps.pop();
        }
    }

    std::string getError()
    {
        return m_error;
    }

    types::InternalType* getResult()
    {
        types::InternalType* pIT = m_steps.top()->container;
        pIT->IncreaseRef();
        delete m_steps.top();
        m_steps.pop();
        pIT->DecreaseRef();
        return pIT;
    }

    bool null();
    bool boolean(bool val)
    {
        return setValue<int, types::Bool>(val ? 1 : 0, ScilabType::ScilabBool);
    }

    bool number_integer(int val)
    {
        return setValue<double, types::Double>((double)val, ScilabType::ScilabDouble);
    }

    bool number_unsigned(unsigned val)
    {
        return setValue<double, types::Double>((double)val, ScilabType::ScilabDouble);
    }

    bool number_float(double val, const std::string& s)
    {
        return setValue<double, types::Double>(val, ScilabType::ScilabDouble);
    }

    bool string(std::string& val)
    {
        wchar_t* wstr = to_wide_string(val.c_str());
        return setValue<wchar_t*, types::String>(wstr, ScilabType::ScilabString);
    }

    bool start_array();
    bool end_array();
    bool start_object();
    bool end_object();
    bool key(std::string& val);
};

struct ScilabHandler : public BaseReaderHandler<UTF8<>, ScilabHandler>
{
    sax_json_scilab sax;
    bool Null() { return sax.null(); }
    bool Bool(bool b) { return sax.boolean(b); }
    bool Int(int i) { return sax.number_integer(i); }
    bool Uint(unsigned u) { return sax.number_unsigned(u); }
    bool Int64(int64_t i) { return sax.number_integer(i); }
    bool Uint64(uint64_t u) { return sax.number_unsigned(u); }
    bool Double(double d) { return sax.number_float(d, ""); }
    bool RawNumber(const char* str, SizeType length, bool copy)
    {
        return sax.number_float(std::stod(str), str);
    }
    bool String(const char* str, SizeType length, bool copy)
    {
        std::string val(str);
        return sax.string(val);
    }
    bool StartObject() { return sax.start_object(); }
    bool Key(const char* str, SizeType length, bool copy)
    {
        std::string val(str);
        return sax.key(val);
    }
    bool EndObject(SizeType memberCount) { return sax.end_object(); }
    bool StartArray() { return sax.start_array(); }
    bool EndArray(SizeType elementCount) { return sax.end_array(); }
};

#endif /* !__FROMJSON_HXX__ */