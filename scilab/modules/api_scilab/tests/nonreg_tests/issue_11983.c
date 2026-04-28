#include "Scierror.h"
#include "localization.h"
#include "api_scilab.h"

int sci_issue_11983(char *fname, void* pvApiCtx)
{
	char *newgen = NULL;
	int *_piAddress;
	int iRet = 0;
	SciErr sciErr;

	CheckRhs(1,1);
	CheckLhs(0,1);

	sciErr = getVarAddressFromPosition(pvApiCtx, 1, &_piAddress);
	if(sciErr.iErr)
	{
		printError(&sciErr, 0);
		return 0;
	}
	iRet = getAllocatedSingleString(pvApiCtx, _piAddress, &newgen);
	if (iRet)
	{
		return 0;
	}

	LhsVar(1) = 1;

	return 0;
}
