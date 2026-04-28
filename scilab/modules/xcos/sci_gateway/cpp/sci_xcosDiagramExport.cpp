/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 * 
 */

/*--------------------------------------------------------------------------*/
#include <algorithm>
#include "Xcos.hxx"
#include "GiwsException.hxx"
#include "loadStatus.hxx"
#include "Controller.hxx"
#include "view_scilab/Adapters.hxx"

#include "types.hxx"
#include "function.hxx"
#include "string.hxx"
#include "user.hxx"
#include "int.hxx"

#include "gw_xcos.hxx"

extern "C"
{
#include "sci_malloc.h"
#include "localization.h"
#include "Scierror.h"
#include "getScilabJavaVM.h"
#include "getFullFilename.h"
}
/*--------------------------------------------------------------------------*/
using namespace org_scilab_modules_xcos;
using namespace org_scilab_modules_scicos;
/*--------------------------------------------------------------------------*/
static char funname[] = "xcosDiagramExport";
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_xcosDiagramExport(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    _iRetCount = (std::max)(1, _iRetCount);

    if (in.size() != 2)
    {
        Scierror(77, _("%s: Wrong number of input arguments: %d expected.\n"), funname, 2);
        return types::Function::Error;
    }

    // check that the passed argument is a diagram
    const model::BaseObject* o = view_scilab::Adapters::instance().descriptor(in[0]);
    if (o == nullptr)
    {
        Scierror(77, _("%s: Wrong type for input argument #%d: ""%s"" expected.\n"), funname, 1, "diagram");
        return types::Function::Error;
    }
    if( !(o->kind() == DIAGRAM || o->kind() == BLOCK) )
    {
        // BLOCK is also valid as it has CHILDREN
        Scierror(77, _("%s: Wrong type for input argument #%d: ""%s"" expected.\n"), funname, 1, "diagram");
        return types::Function::Error;
    }
    
    if (!in[1]->isString())
    {
        Scierror(77, _("%s: Wrong type for input argument #%d: string expected.\n"), funname, 2);
        return types::Function::Error;
    }
    types::String* files = in[1]->getAs<types::String>();
    if (files->getSize() != 1)
    {
        Scierror(77, _("%s: Wrong type for input argument #%d: string expected.\n"), funname, 2);
        return types::Function::Error;
    }
    
    // export it
    wchar_t* fullFilename = getFullFilenameW(files->get(0));
    char* exportedFile = wide_string_to_UTF8(fullFilename);
    FREE(fullFilename);
    set_loaded_status(XCOS_CALLED);
    try
    {
        Xcos::xcosDiagramExport(getScilabJavaVM(), o->id(), exportedFile);
    }
    catch (const GiwsException::JniCallMethodException& exception)
    {
        Scierror(999, "%s: %s\n%s\n", funname, exception.getJavaDescription().c_str(), exception.getJavaStackTrace().c_str());
        FREE(exportedFile);
        return types::Function::Error;
    }
    catch (const GiwsException::JniException& exception)
    {
        Scierror(999, "%s: %s\n", funname, exception.whatStr().c_str());
        FREE(exportedFile);
        return types::Function::Error;
    }
    FREE(exportedFile);
    return types::Function::OK;
}
/*--------------------------------------------------------------------------*/
