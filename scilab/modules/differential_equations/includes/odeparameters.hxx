//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _ODEPARAMETERS_HXX_
#define  _ODEPARAMETERS_HXX_

enum type_check
{
    CHECK_NONE,
    CHECK_SIZE,
    CHECK_MIN,
    CHECK_MAX,
    CHECK_BOTH,
    CHECK_VALUES
};

void getBooleanInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                      bool * _pbValue, bool _bDefaultValue);

void getStringInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel, std::wstring & stValue,
                std::wstring stDefaultValue, std::vector<std::wstring> checkValues);
 
void getDoubleInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                double * _pdblValue, double _dblDefaultValue, std::vector<double> checkValues);

void getDoubleVectorInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                std::vector<double> &dblValues, std::vector<double> defaultValues, std::vector<double> checkValues, int iSize);

void getIntInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                int * _piValue, int _iDefaultValue, std::vector<int> checkValues);


void getIntVectorInPlist(const char * _pstCaller, types::optional_list &opt, const wchar_t * _pwstLabel,
                std::vector<int> &intValues, std::vector<int>  defaultValues, std::vector<int> checkValues, std::vector<int> iSize);
#endif
