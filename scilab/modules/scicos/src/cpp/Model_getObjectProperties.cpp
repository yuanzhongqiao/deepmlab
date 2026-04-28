/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2014-2016 - Scilab Enterprises - Clement DAVID
 * Copyright (C) 2017 - ESI Group - Clement DAVID
 * Copyright (C) 2023-2024 - Dassault Systèmes S.E. - Clément DAVID
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

#include <string>
#include <vector>

#include "Model.hxx"
#include "utilities.hxx"

#include "model/Annotation.hxx"
#include "model/BaseObject.hxx"
#include "model/Block.hxx"
#include "model/Diagram.hxx"
#include "model/Link.hxx"
#include "model/Port.hxx"

extern "C"
{
#include "sci_types.h"
}

namespace org_scilab_modules_scicos
{

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, double& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case FIRING:
                o->getFiring(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, int& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case SIM_FUNCTION_API:
                o->getSimFunctionApi(v);
                return true;
            case DEBUG_LEVEL:
                o->getDebugLevel(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case DEBUG_LEVEL:
                o->getDebugLevel(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case COLOR:
                o->getColor(v);
                return true;
            case KIND:
                o->getKind(v);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case PORT_KIND:
                o->getKind(v);
                return true;
            case DATATYPE_TYPE:
                o->getDataTypeType(v);
                return true;
            case DATATYPE_ROWS:
                o->getDataTypeRows(v);
                return true;
            case DATATYPE_COLS:
                o->getDataTypeCols(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, bool& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case IMPLICIT:
                o->getImplicit(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::string& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        model::Annotation* o = static_cast<model::Annotation*>(baseObject);
        switch (p)
        {
            case DESCRIPTION:
                o->getDescription(v);
                return true;
            case FONT:
                o->getFont(v);
                return true;
            case FONT_SIZE:
                o->getFontSize(v);
                return true;
            case STYLE:
                o->getStyle(v);
                return true;
            case UID:
                o->getUID(v);
                return true;
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case INTERFACE_FUNCTION:
                o->getInterfaceFunction(v);
                return true;
            case SIM_FUNCTION_NAME:
                o->getSimFunctionName(v);
                return true;
            case SIM_BLOCKTYPE:
                o->getSimBlocktype(v);
                return true;
            case EXPRS:
            {
                std::vector<double> exprs;
                o->getExprs(exprs);

                //  [0] type
                //  [1] number of dims
                //  [2] scalar 1x1
                //  [3] scalar 1x1
                //  [4] string length
                //  [5] utf8 content \0 terminated
                if (exprs.size() < 6)
                    return false;
                if (exprs[0] != sci_strings)
                    return false;
                if (exprs[1] != 2)
                    return false;
                if (exprs[2] != 1)
                    return false;
                if (exprs[3] != 1)
                    return false;
                size_t len = (size_t)exprs[4] * sizeof(double) / sizeof(char);

                const char* first = (const char*)&(exprs[5]);
                const char* last = std::char_traits<char>::find(first, len, '\0');
                if (last == nullptr || first[len -1] != '\0')
                    // there is no \0 ending the string, ignore
                    return false;
                // this is a \0 terminated string, assign
                v.assign(first, (size_t)(last - first + 1));
                return true;
            }
            case STYLE:
                o->getStyle(v);
                return true;
            case NAME:
                o->getName(v);
                return true;
            case DESCRIPTION:
                o->getDescription(v);
                return true;
            case UID:
                o->getUID(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case NAME:
                o->getName(v);
                return true;
            case DESCRIPTION:
                o->getDescription(v);
                return true;
            case PATH:
                o->getPath(v);
                return true;
            case AUTHOR:
                o->getAuthor(v);
                return true;
            case FILE_VERSION:
                o->getFileVersion(v);
                return true;
            case COPYRIGHT:
                o->getCopyright(v);
                return true;
            case LICENSE:
                o->getLicense(v);
                return true;
            case GENERATION_TOOL:
                o->getGenerationTool(v);
                return true;
            case GENERATION_DATE:
                o->getGenerationDate(v);
                return true;
            case VERSION_NUMBER:
                o->getVersionNumber(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case NAME:
                o->getName(v);
                return true;
            case DESCRIPTION:
                o->getDescription(v);
                return true;
            case STYLE:
                o->getStyle(v);
                return true;
            case UID:
                o->getUID(v);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case STYLE:
                o->getStyle(v);
                return true;
            case NAME:
                o->getName(v);
                return true;
            case DESCRIPTION:
                o->getDescription(v);
                return true;
            case UID:
                o->getUID(v);
                return true;
            case PARAMETER_UNIT:
                o->getUnit(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, ScicosID& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        model::Annotation* o = static_cast<model::Annotation*>(baseObject);
        switch (p)
        {
            case PARENT_DIAGRAM:
                o->getParentDiagram(v);
                return true;
            case PARENT_BLOCK:
                o->getParentBlock(v);
                return true;
            case RELATED_TO:
                v = o->getRelatedTo();
                return true;
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case PARENT_DIAGRAM:
                o->getParentDiagram(v);
                return true;
            case PARENT_BLOCK:
                o->getParentBlock(v);
                return true;
            case LABEL:
                o->getLabel(v);
                return true;
            case PORT_REFERENCE:
                o->getPortReference(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case PARENT_DIAGRAM:
                o->getParentDiagram(v);
                return true;
            case PARENT_BLOCK:
                o->getParentBlock(v);
                return true;
            case LABEL:
                o->getLabel(v);
                return true;
            case SOURCE_PORT:
                o->getSourcePort(v);
                return true;
            case DESTINATION_PORT:
                o->getDestinationPort(v);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case SOURCE_BLOCK:
                o->getSourceBlock(v);
                return true;
            case CONNECTED_SIGNALS:
                v = o->getConnectedSignals().front();
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, model::BaseObject*& v) const
{
    v = {};
    ScicosID id;
    if (getObjectProperty(object, p, id))
    {
        v = getObject(id);
        return v != nullptr;
    }
    else
    {
        v = nullptr;
        return false;
    }
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<double>& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        model::Annotation* o = static_cast<model::Annotation*>(baseObject);
        switch (p)
        {
            case GEOMETRY:
                o->getGeometry(v);
                return true;
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case GEOMETRY:
                o->getGeometry(v);
                return true;
            case EXPRS:
                o->getExprs(v);
                return true;
            case STATE:
                o->getState(v);
                return true;
            case DSTATE:
                o->getDState(v);
                return true;
            case ODSTATE:
                o->getODState(v);
                return true;
            case RPAR:
                o->getRpar(v);
                return true;
            case OPAR:
                o->getOpar(v);
                return true;
            case PROPERTIES:
                o->getProperties(v);
                return true;
            case EQUATIONS:
                o->getEquations(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case PROPERTIES:
                o->getProperties(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case CONTROL_POINTS:
                o->getControlPoints(v);
                return true;
            case THICK:
                o->getThick(v);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<int>& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case SIM_DEP_UT:
                o->getSimDepUT(v);
                return true;
            case NZCROSS:
                o->getNZcross(v);
                return true;
            case NMODE:
                o->getNMode(v);
                return true;
            case IPAR:
                o->getIpar(v);
                return true;
            case COLOR:
                o->getChildrenColor(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case COLOR:
                o->getColor(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case COLOR:
                v.resize(1);
                o->getColor(v[0]);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case DATATYPE:
                o->getDataType(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<bool>& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<std::string>& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        model::Annotation* o = static_cast<model::Annotation*>(baseObject);
        switch (p)
        {
            case SSP_ANNOTATION:
                o->getSSPAnnotation(v);
                return true;
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case DIAGRAM_CONTEXT:
                o->getContext(v);
                return true;
            case EXPRS:
            {
                v.clear();

                std::vector<double> exprs;
                o->getExprs(exprs);

                // empty matrix encoded by var2vec()
                if (exprs == std::vector<double>({1, 2, 0, 0, 0}))
                {
                    return true;
                }

                //  * type
                //  * number of dims
                //  * scalar 1x1
                //  * strings offset in double
                //  * utf8 content \0 terminated
                if (exprs.size() < 6)
                    return false;
                if (exprs[0] != sci_strings)
                    return false;
                if (exprs[1] < 2)
                    return false;
                if (exprs[2] < 1)
                    return false;
                if (exprs[3] < 1)
                    return false;

                size_t N = (size_t)(exprs[2] * exprs[3]);
                v.resize(N);
                size_t len = (size_t)exprs[4] * sizeof(double) / sizeof(char);
                char* data = (char*)&(exprs[4 + N]);
                v[0].reserve(len);
                v[0].assign(data);
                for (size_t i = 1; i < N; ++i)
                {
                    size_t offset = (size_t)exprs[4 + i - 1];
                    len = ((size_t)exprs[4 + i] - (size_t)exprs[4 + i - 1]) * sizeof(double) / sizeof(char);
                    data = (char*)&(exprs[4 + N + offset]);
                    v[i].reserve(len);
                    v[i].assign(data);
                }
                return true;
            }
            case PARAMETER_NAME:
                o->getNamedParameters(v);
                return true;
            case PARAMETER_DESCRIPTION:
                o->getNamedParametersDescription(v);
                return true;
            case PARAMETER_UNIT:
                o->getNamedParametersUnit(v);
                return true;
            case PARAMETER_TYPE:
                o->getNamedParametersTypes(v);
                return true;
            case PARAMETER_ENCODING:
                o->getNamedParametersEncodings(v);
                return true;
            case PARAMETER_VALUE:
                o->getNamedParametersValues(v);
                return true;
            case SSP_ANNOTATION:
                o->getSSPAnnotation(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case DIAGRAM_CONTEXT:
                o->getContext(v);
                return true;
            case PARAMETER_NAME:
                o->getNamedParameters(v);
                return true;
            case PARAMETER_DESCRIPTION:
                o->getNamedParametersDescription(v);
                return true;
            case PARAMETER_UNIT:
                o->getNamedParametersUnit(v);
                return true;
            case PARAMETER_TYPE:
                o->getNamedParametersTypes(v);
                return true;
            case PARAMETER_ENCODING:
                o->getNamedParametersEncodings(v);
                return true;
            case PARAMETER_VALUE:
                o->getNamedParametersValues(v);
                return true;
            case SSP_ANNOTATION:
                o->getSSPAnnotation(v);
                return true;
            case GLOBAL_XMLNS:
                o->getGlobalXMLNS(v);
                return true;
            case GLOBAL_SSP_ANNOTATION:
                o->getGlobalSSPAnnotation(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        model::Link* o = static_cast<model::Link*>(baseObject);
        switch (p)
        {
            case SSP_ANNOTATION:
                o->getSSPAnnotation(v);
                return true;
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case SSP_ANNOTATION:
                o->getSSPAnnotation(v);
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<ScicosID>& v) const
{
    v = {};
    model::BaseObject* baseObject = object;
    if (baseObject == nullptr)
    {
        return false;
    }
    kind_t k = object->kind();

    if (k == ANNOTATION)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == BLOCK)
    {
        model::Block* o = static_cast<model::Block*>(baseObject);
        switch (p)
        {
            case INPUTS:
                o->getIn(v);
                return true;
            case OUTPUTS:
                o->getOut(v);
                return true;
            case EVENT_INPUTS:
                o->getEin(v);
                return true;
            case EVENT_OUTPUTS:
                o->getEout(v);
                return true;
            case CHILDREN:
                o->getChildren(v);
                return true;
            default:
                break;
        }
    }
    else if (k == DIAGRAM)
    {
        model::Diagram* o = static_cast<model::Diagram*>(baseObject);
        switch (p)
        {
            case CHILDREN:
                o->getChildren(v);
                return true;
            default:
                break;
        }
    }
    else if (k == LINK)
    {
        switch (p)
        {
            default:
                break;
        }
    }
    else if (k == PORT)
    {
        model::Port* o = static_cast<model::Port*>(baseObject);
        switch (p)
        {
            case CONNECTED_SIGNALS:
                v = o->getConnectedSignals();
                return true;
            default:
                break;
        }
    }
    return false;
}

bool Model::getObjectProperty(model::BaseObject* object, object_properties_t p, std::vector<model::BaseObject*>& v) const
{
    v = {};
    std::vector<ScicosID> ids;
    if (!getObjectProperty(object, p, ids))
    {
        return false;
    }

    v.insert(v.begin(), ids.size(), nullptr);
    for (size_t i = 0; i < ids.size(); i++)
    {
        v[i] = getObject(ids[i]);
    }
    return true;
}

} /* namespace org_scilab_modules_scicos */
