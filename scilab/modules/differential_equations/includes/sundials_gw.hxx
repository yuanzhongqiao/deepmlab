/*
*  Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
*  Copyright (C) 2022 - ESI - Antoine ELIAS
*
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
*
*/

#ifndef __SUNDIALS_GW_HXX__
#define __SUNDIALS_GW_HXX__

#include "cpp_gateway_prototype.hxx"

#include "dynlib_sundials_gw.h"

CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_cvode, SUNDIALS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_ida, SUNDIALS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_arkode, SUNDIALS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_kinsol, SUNDIALS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_percent_odeSolution_clear, SUNDIALS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_percent_odeSolution_e, SUNDIALS_GW_IMPEXP);

#endif /* __SUNDIALS_GW_HXX__ */

