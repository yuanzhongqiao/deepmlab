// operations.cpp : Defines the exported functions for the DLL application.
//

#include "operations.hxx"
#include "types_addition.hxx"
#include "types_subtraction.hxx"
#include "types_opposite.hxx"
#include "types_multiplication.hxx"
#include "types_dotmultiplication.hxx"
#include "types_dotdivide.hxx"
#include "types_and.hxx"
#include "types_or.hxx"
#include "types_comparison_eq.hxx"
#include "types_comparison_ne.hxx"
#include "localization.hxx"

void initOperationArray()
{
    fillAddFunction();
    fillOppositeFunction();
    fillSubtractFunction();
    fillIntMulFunction();
    fillDotMulFunction();
    fillDotDivFunction();
    fillAndFunction();
    fillOrFunction();
    fillComparisonEqualFunction();
    fillComparisonNoEqualFunction();
}

std::wstring checkSameSize(types::GenericType* pGT1, types::GenericType* pGT2, std::wstring op)
{
    int iDims1 = pGT1->getDims();
    int iDims2 = pGT2->getDims();
    if (iDims1 != iDims2)
    {
        return errorSameSize(pGT1, pGT2, op);
    }

    int* piDims1 = pGT1->getDimsArray();
    int* piDims2 = pGT2->getDimsArray();

    for (int i = 0; i < iDims1; i++)
    {
        if (piDims1[i] != piDims2[i])
        {
            return errorSameSize(pGT1, pGT2, op);
        }
    }

    return L"";
}

std::wstring errorSameSize(types::GenericType* pGT1, types::GenericType* pGT2, std::wstring op)
{
    wchar_t pMsg[bsiz];
    os_swprintf(pMsg, bsiz, _W("Operator %ls: Wrong dimensions for operation [%ls] %ls [%ls], same dimensions expected.\n").c_str(), op.c_str(), pGT1->DimToString().c_str(), op.c_str(), pGT2->DimToString().c_str());
    return pMsg;
}

std::wstring errorMultiplySize(types::GenericType* pGT1, types::GenericType* pGT2)
{
    wchar_t pMsg[bsiz];
    os_swprintf(pMsg, bsiz, _W("Operator %ls: Wrong dimensions for operation [%ls] %ls [%ls].\n").c_str(), L"*", pGT1->DimToString().c_str(), L"*", pGT2->DimToString().c_str());
    return pMsg;
}