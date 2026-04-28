/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#ifndef __TOJSON_HXX__
#define __TOJSON_HXX__

#include "internal.hxx"
#include "rapidjson/prettywriter.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"
extern "C"
{
#include "api_scilab.h"
#include "dynlib_webtools.h"
}

using ScilabType = types::InternalType::ScilabType;

using namespace rapidjson;
#ifdef _MSC_VER
#define RAPIDJSON_MASTER
#endif

#ifdef RAPIDJSON_MASTER
using jsonPrettyWriter = PrettyWriter<StringBuffer, UTF8<>, UTF8<>, CrtAllocator, kWriteNanAndInfNullFlag>;
using jsonNaNInfPrettyWriter = PrettyWriter<StringBuffer, UTF8<>, UTF8<>, CrtAllocator, kWriteNanAndInfFlag>;
using jsonWriter = Writer<StringBuffer, UTF8<>, UTF8<>, CrtAllocator, kWriteNanAndInfNullFlag>;
#endif

using jsonNanInfWriter = Writer<StringBuffer, UTF8<>, UTF8<>, CrtAllocator, kWriteNanAndInfFlag>;

#ifdef RAPIDJSON_MASTER
bool scilabToJSON(types::InternalType* pIT, jsonPrettyWriter& json);
bool scilabToJSON(types::InternalType* pIT, jsonNaNInfPrettyWriter& json);
bool scilabToJSON(types::InternalType* pIT, jsonWriter& json);
#endif

bool scilabToJSON(types::InternalType* pIT, jsonNanInfWriter& json);

#endif /* !__TOJSON_HXX__ */
