/*
* -----------------------------------------------------------------
* Allan CORNET - 2009
* For details, see sundials/shared/LICENSE.
* -----------------------------------------------------------------
*/

#include "sundials/sundials_extension.h"
#include "../src/idas/idas_impl.h" /* to access ida_kk */

BOOL bsundialsExtended = FALSE;

BOOL is_sundials_with_extension(void)
{
    return bsundialsExtended;
}

BOOL set_sundials_with_extension(BOOL _mode)
{
    bsundialsExtended = _mode;
    return bsundialsExtended;
}

int IDAResetCurrentBDFMethodOrder(void *ida_mem)
{
  IDAMem IDA_mem;

  if (ida_mem==NULL) {
    return(IDA_MEM_NULL);
  }

  IDA_mem = (IDAMem) ida_mem;

  IDA_mem->ida_kk = 1;

  return(IDA_SUCCESS);
}

sunrealtype FLOOR(sunrealtype x)
{
#if defined(SUNDIALS_USE_GENERIC_MATH)
    return(floor((double) x));
#elif defined(SUNDIALS_DOUBLE_PRECISION)
    return(floor(x));
#elif defined(SUNDIALS_SINGLE_PRECISION)
    return(floor(x));
#elif defined(SUNDIALS_EXTENDED_PRECISION)
    return(floor(x));
#endif
}
