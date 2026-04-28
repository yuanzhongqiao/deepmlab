/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#include "json.hxx"
#include "toJSON.hxx"
#include "UTF8.hxx"
#include "struct.hxx"
#include "double.hxx"
#include "string.hxx"
#include "bool.hxx"
#include "int.hxx"

template<typename W>
static inline bool internalToJSON(types::InternalType* pIT, W& json);
static std::string error = "";

template<typename T, typename W>
static bool jsonSetValue(T& val, W& json, bool isBool)
{
    return json.Int64(val);
}

template<typename W>
static bool jsonSetValue(int& val, W& json, bool isBool)
{
    if(isBool)
    {
        return json.Bool(val ? true : false);
    }

    return json.Int64(val);
}

template<typename W>
static bool jsonSetValue(wchar_t* val, W& json, bool isBool)
{
    return json.String(scilab::UTF8::toUTF8(val).c_str());
}

template<typename W>
static bool jsonSetValue(double& val, W& json, bool isBool)
{
    double dd;
    if(std::modf(val, &dd) == 0.0 && int64_t(dd) == dd)
    {
        // serialize integer value
        return json.Int64(int64_t(val));
    }

    // serialize floating point value
    return json.Double(val);
}

template<typename W>
static bool jsonSetValue(types::SingleStruct* val, W& json, bool isBool)
{
    return internalToJSON(val, json);
}

template<typename T,typename W>
static inline bool colToRowMajor(T* pIn, std::vector<size_t>& vDims, bool isBool, W& json)
{
    json.StartArray();
    for(size_t r = 0; r < vDims[1]; r++)
    {
        json.StartArray();
        for(size_t c = 0; c < vDims[0]; c++)
        {
            size_t idx = c * vDims[1] + r;
            if(jsonSetValue(pIn[idx], json, isBool) == false)
            {
                return false;
            }
        }
        json.EndArray();
    }
    json.EndArray();
    return true;
}

template<typename T, typename W>
static bool ndArray(T* pIn, std::vector<size_t>& vDims, size_t iDim, bool isBool, W& json)
{
    if(iDim > 2)
    {
        json.StartArray();
        iDim--;
        for(size_t i = 0; i < vDims[iDim-1]; i++)
        {
            if(ndArray(pIn, vDims, iDim, isBool, json) == false)
            {
                return false;
            }
        }
        json.EndArray();
        return true;
    }

    // write 2D array
    bool bOk = colToRowMajor(*pIn, vDims, isBool, json);
    size_t i2Dsize = vDims[0] * vDims[1];
    *pIn += i2Dsize;
    return bOk;
}

template<typename T, typename W>
static inline bool scilabArrayOfToJSON(T* pData, size_t iSize, std::vector<size_t>& vDims, bool isBool, W& json)
{
    if(iSize == 1)
    {
        // scalar
        return jsonSetValue(pData[0], json, isBool);
    }

    if(vDims.size() == 2 && vDims[1] == 1)
    {
        // row vector
        json.StartArray();
        for(size_t c = 0; c < iSize; c++)
        {
            if(jsonSetValue(pData[c], json, isBool) == false)
            {
                return false;
            }
        }
        json.EndArray();
        return true;
    }

    if(vDims.size() == 2)
    {
        return colToRowMajor(pData, vDims, isBool, json);
    }

    return ndArray(&pData, vDims, vDims.size(), isBool, json);
}

template<typename T, typename W>
static bool matrixToJson(types::InternalType* pIT, W& json, bool isBool = false)
{
    T* pData = pIT->getAs<T>();
    if(pData->getSize() == 0)
    {
        if(pIT->isStruct())
        {
            // {}
            json.StartObject();
            json.EndObject();
            return true;
        }

        // []
        json.StartArray();
        json.EndArray();
        return true;
    }

    int iDims = pData->getDims();
    int* piDims = pData->getDimsArray();
    std::vector<size_t> vDims(piDims, piDims + iDims);

    // switch row/col size because json format is row major
    std::swap(vDims[0], vDims[1]);

    int iSize = pData->getSize();
    return scilabArrayOfToJSON(pData->get(), (size_t)iSize, vDims, isBool, json);
}

template<typename W>
static inline bool internalToJSON(types::InternalType* pIT, W& json)
{
    switch(pIT->getType())
    {
        case ScilabType::ScilabNull:
        case ScilabType::ScilabVoid:
        {
            json.Null();
            return true;
        }
        /* Generic Types */
        case ScilabType::ScilabBool:    return matrixToJson<types::Bool>(pIT, json, true);
        case ScilabType::ScilabInt8:    return matrixToJson<types::Int<char>>(pIT, json);
        case ScilabType::ScilabUInt8:   return matrixToJson<types::Int<unsigned char>>(pIT, json);
        case ScilabType::ScilabInt16:   return matrixToJson<types::Int<short>>(pIT, json);
        case ScilabType::ScilabUInt16:  return matrixToJson<types::Int<unsigned short>>(pIT, json);
        case ScilabType::ScilabInt32:   return matrixToJson<types::Int<int>>(pIT, json);
        case ScilabType::ScilabUInt32:  return matrixToJson<types::Int<unsigned int>>(pIT, json);
        case ScilabType::ScilabInt64:   return matrixToJson<types::Int<long long>>(pIT, json);
        case ScilabType::ScilabUInt64:  return matrixToJson<types::Int<unsigned long long>>(pIT, json);
        // case ScilabType::ScilabFloat:   return matrixToJson<types::Float>(pIT, json);
        case ScilabType::ScilabDouble:  return matrixToJson<types::Double>(pIT, json);
        case ScilabType::ScilabString:  return matrixToJson<types::String>(pIT, json);
        case ScilabType::ScilabStruct:  return matrixToJson<types::Struct>(pIT, json);
        /* Implicit List */
        // ScilabImplicitList,
        /* Container */
        case ScilabType::ScilabList:
        {
            types::List* pList = pIT->getAs<types::List>();
            json.StartArray();
            for(int i = 0; i < pList->getSize(); i++)
            {
                if(internalToJSON(pList->get(i), json) == false)
                {
                    return false;
                }
            }
            json.EndArray();
            return true;
        }
        // case ScilabType::ScilabTList,
        // case ScilabType::ScilabMList,
        case ScilabType::ScilabSingleStruct:
        {
            types::SingleStruct* pSStruct = pIT->getAs<types::SingleStruct>();
            std::vector<types::InternalType *> vData = pSStruct->getData();
            json.StartObject();
            auto& f = pSStruct->getFields();
            std::vector<std::pair<std::wstring, int>> vFields(f.begin(), f.end());
            std::sort(vFields.begin(), vFields.end(), [](const auto& a, const auto& b) { return a.second < b.second; });
            for(const auto& elem : vFields)
            {
                std::string fieldname = scilab::UTF8::toUTF8(elem.first);
                json.Key(fieldname.c_str());
                if(internalToJSON(vData[elem.second], json) == false)
                {
                    return false;
                }
            }
            json.EndObject();
            return true;
        }
        // ScilabCell,
        // ScilabSparse,
        // ScilabSparseBool,
        // ScilabHandle,
        default:
        {
            error = "Cannot convert data of type " + scilab::UTF8::toUTF8(pIT->getTypeStr());
            return false;
        }
    }
}
#ifdef RAPIDJSON_MASTER
bool scilabToJSON(types::InternalType* pIT, jsonPrettyWriter& json)
{
    return internalToJSON(pIT, json);
}

bool scilabToJSON(types::InternalType* pIT, jsonNaNInfPrettyWriter& json)
{
    return internalToJSON(pIT, json);
}

bool scilabToJSON(types::InternalType* pIT, jsonWriter& json)
{
    return internalToJSON(pIT, json);
}
#endif
bool scilabToJSON(types::InternalType* pIT, jsonNanInfWriter& json)
{
    return internalToJSON(pIT, json);
}

std::string toJSON(types::InternalType* it, std::string& err, int indent, bool allowNanAndInf)
{
    std::string out = "";
    StringBuffer json_str;
    bool bOk = false;
#ifdef RAPIDJSON_MASTER
    if(indent > 0)
    {
        if(allowNanAndInf)
        {
            jsonNaNInfPrettyWriter json(json_str);
            json.SetIndent(' ', indent);
            bOk = scilabToJSON(it, json) && json.IsComplete();
        }
        else
        {
            jsonPrettyWriter json(json_str);
            json.SetIndent(' ', indent);
            bOk = scilabToJSON(it, json) && json.IsComplete();
        }
    }
    else
    {
        if(allowNanAndInf)
        {
            jsonNanInfWriter json(json_str);
            bOk = scilabToJSON(it, json) && json.IsComplete();
        }
        else
        {
            jsonWriter json(json_str);
            bOk = scilabToJSON(it, json) && json.IsComplete();
        }
    }
#else
    jsonNanInfWriter json(json_str);
    bOk = scilabToJSON(it, json) && json.IsComplete();
#endif

    if(bOk)
    {
        out = json_str.GetString();
    }
    else
    {
        err = error;
    }

    return out;
}
