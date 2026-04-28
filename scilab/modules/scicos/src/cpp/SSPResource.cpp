/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Clément DAVID
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include <fstream>
#include <iostream>

#include "SSPResource.hxx"

extern "C"
{
#include <libxml/xmlreader.h>
#include <libxml/xmlversion.h>
}

namespace org_scilab_modules_scicos
{

SSPResource::SSPResource(ScicosID id) : controller(), root(id), rawKnownStr(), readerConstInterned(), xmlnsSSC(), xmlnsSSB(), xmlnsSSD(), xmlnsSSV(), xmlnsSSM(), annotated(false), processed(), unit(), temporaryComponentName(), references(), _strShared(), _vecDblShared(), _vecIntShared(), _vecStrShared(), _vecIDShared()
{
    LIBXML_TEST_VERSION;

    // initialize the rawKnownStr array
    // TODO might be better with a constexpr trie or dawg
    rawKnownStr[e_A] = BAD_CAST("A");
    rawKnownStr[e_Annotation] = BAD_CAST("Annotation");
    rawKnownStr[e_Annotations] = BAD_CAST("Annotations");
    rawKnownStr[e_BaseUnit] = BAD_CAST("BaseUnit");
    rawKnownStr[e_Binary] = BAD_CAST("Binary");
    rawKnownStr[e_Boolean] = BAD_CAST("Boolean");
    rawKnownStr[e_BooleanMappingTransformation] = BAD_CAST("BooleanMappingTransformation");
    rawKnownStr[e_Clock] = BAD_CAST("Clock");
    rawKnownStr[e_CoSimulation] = BAD_CAST("CoSimulation");
    rawKnownStr[e_Complex] = BAD_CAST("Complex");
    rawKnownStr[e_Component] = BAD_CAST("Component");
    rawKnownStr[e_Connection] = BAD_CAST("Connection");
    rawKnownStr[e_ConnectionGeometry] = BAD_CAST("ConnectionGeometry");
    rawKnownStr[e_Connections] = BAD_CAST("Connections");
    rawKnownStr[e_Connector] = BAD_CAST("Connector");
    rawKnownStr[e_ConnectorGeometry] = BAD_CAST("ConnectorGeometry");
    rawKnownStr[e_Connectors] = BAD_CAST("Connectors");
    rawKnownStr[e_DefaultExperiment] = BAD_CAST("DefaultExperiment");
    rawKnownStr[e_DictionaryEntry] = BAD_CAST("DictionaryEntry");
    rawKnownStr[e_Dimension] = BAD_CAST("Dimension");
    rawKnownStr[e_ElementGeometry] = BAD_CAST("ElementGeometry");
    rawKnownStr[e_Elements] = BAD_CAST("Elements");
    rawKnownStr[e_Enumeration] = BAD_CAST("Enumeration");
    rawKnownStr[e_EnumerationMappingTransformation] = BAD_CAST("EnumerationMappingTransformation");
    rawKnownStr[e_Enumerations] = BAD_CAST("Enumerations");
    rawKnownStr[e_Float32] = BAD_CAST("Float32");
    rawKnownStr[e_Float64] = BAD_CAST("Float64");
    rawKnownStr[e_GraphicalElements] = BAD_CAST("GraphicalElements");
    rawKnownStr[e_Int16] = BAD_CAST("Int16");
    rawKnownStr[e_Int32] = BAD_CAST("Int32");
    rawKnownStr[e_Int64] = BAD_CAST("Int64");
    rawKnownStr[e_Int8] = BAD_CAST("Int8");
    rawKnownStr[e_Integer] = BAD_CAST("Integer");
    rawKnownStr[e_IntegerMappingTransformation] = BAD_CAST("IntegerMappingTransformation");
    rawKnownStr[e_Item] = BAD_CAST("Item");
    rawKnownStr[e_K] = BAD_CAST("K");
    rawKnownStr[e_LinearTransformation] = BAD_CAST("LinearTransformation");
    rawKnownStr[e_MapEntry] = BAD_CAST("MapEntry");
    rawKnownStr[e_MappingEntry] = BAD_CAST("MappingEntry");
    rawKnownStr[e_ModelExchange] = BAD_CAST("ModelExchange");
    rawKnownStr[e_Note] = BAD_CAST("Note");
    rawKnownStr[e_Parameter] = BAD_CAST("Parameter");
    rawKnownStr[e_ParameterBinding] = BAD_CAST("ParameterBinding");
    rawKnownStr[e_ParameterBindings] = BAD_CAST("ParameterBindings");
    rawKnownStr[e_ParameterMapping] = BAD_CAST("ParameterMapping");
    rawKnownStr[e_ParameterSet] = BAD_CAST("ParameterSet");
    rawKnownStr[e_ParameterValues] = BAD_CAST("ParameterValues");
    rawKnownStr[e_Parameters] = BAD_CAST("Parameters");
    rawKnownStr[e_Real] = BAD_CAST("Real");
    rawKnownStr[e_SSD] = BAD_CAST("SSD");
    rawKnownStr[e_ScheduledExecution] = BAD_CAST("ScheduledExecution");
    rawKnownStr[e_SignalDictionaries] = BAD_CAST("SignalDictionaries");
    rawKnownStr[e_SignalDictionary] = BAD_CAST("SignalDictionary");
    rawKnownStr[e_SignalDictionaryReference] = BAD_CAST("SignalDictionaryReference");
    rawKnownStr[e_String] = BAD_CAST("String");
    rawKnownStr[e_System] = BAD_CAST("System");
    rawKnownStr[e_SystemGeometry] = BAD_CAST("SystemGeometry");
    rawKnownStr[e_SystemStructureDescription] = BAD_CAST("SystemStructureDescription");
    rawKnownStr[e_UInt16] = BAD_CAST("UInt16");
    rawKnownStr[e_UInt32] = BAD_CAST("UInt32");
    rawKnownStr[e_UInt64] = BAD_CAST("UInt64");
    rawKnownStr[e_UInt8] = BAD_CAST("UInt8");
    rawKnownStr[e_Unit] = BAD_CAST("Unit");
    rawKnownStr[e_Units] = BAD_CAST("Units");
    rawKnownStr[e_acausal] = BAD_CAST("acausal");
    rawKnownStr[e_any] = BAD_CAST("any");
    rawKnownStr[e_application_x_fmu_sharedlibrary] = BAD_CAST("application/x-fmu-sharedlibrary");
    rawKnownStr[e_application_x_scilab_xcos] = BAD_CAST("application/x-scilab-xcos");
    rawKnownStr[e_application_x_ssp_definition] = BAD_CAST("application/x-ssp-definition");
    rawKnownStr[e_application_x_ssp_package] = BAD_CAST("application/x-ssp-package");
    rawKnownStr[e_author] = BAD_CAST("author");
    rawKnownStr[e_base64] = BAD_CAST("base64");
    rawKnownStr[e_calculatedParameter] = BAD_CAST("calculatedParameter");
    rawKnownStr[e_cd] = BAD_CAST("cd");
    rawKnownStr[e_color] = BAD_CAST("color");
    rawKnownStr[e_context] = BAD_CAST("context");
    rawKnownStr[e_control_points] = BAD_CAST("control_points");
    rawKnownStr[e_copyright] = BAD_CAST("copyright");
    rawKnownStr[e_datatype] = BAD_CAST("datatype");
    rawKnownStr[e_debug_level] = BAD_CAST("debug_level");
    rawKnownStr[e_description] = BAD_CAST("description");
    rawKnownStr[e_dictionary] = BAD_CAST("dictionary");
    rawKnownStr[e_dstate] = BAD_CAST("dstate");
    rawKnownStr[e_endConnector] = BAD_CAST("endConnector");
    rawKnownStr[e_endElement] = BAD_CAST("endElement");
    rawKnownStr[e_equations] = BAD_CAST("equations");
    rawKnownStr[e_exprs] = BAD_CAST("exprs");
    rawKnownStr[e_factor] = BAD_CAST("factor");
    rawKnownStr[e_fileversion] = BAD_CAST("fileversion");
    rawKnownStr[e_firing] = BAD_CAST("firing");
    rawKnownStr[e_font] = BAD_CAST("font");
    rawKnownStr[e_font_size] = BAD_CAST("font_size");
    rawKnownStr[e_generationDateAndTime] = BAD_CAST("generationDateAndTime");
    rawKnownStr[e_generationTool] = BAD_CAST("generationTool");
    rawKnownStr[e_geometry] = BAD_CAST("geometry");
    rawKnownStr[e_height] = BAD_CAST("height");
    rawKnownStr[e_iconFixedAspectRatio] = BAD_CAST("iconFixedAspectRatio");
    rawKnownStr[e_iconFlip] = BAD_CAST("iconFlip");
    rawKnownStr[e_iconRotation] = BAD_CAST("iconRotation");
    rawKnownStr[e_iconSource] = BAD_CAST("iconSource");
    rawKnownStr[e_id] = BAD_CAST("id");
    rawKnownStr[e_implementation] = BAD_CAST("implementation");
    rawKnownStr[e_implicit] = BAD_CAST("implicit");
    rawKnownStr[e_inout] = BAD_CAST("inout");
    rawKnownStr[e_input] = BAD_CAST("input");
    rawKnownStr[e_interface_function] = BAD_CAST("interface_function");
    rawKnownStr[e_ipar] = BAD_CAST("ipar");
    rawKnownStr[e_kg] = BAD_CAST("kg");
    rawKnownStr[e_kind] = BAD_CAST("kind");
    rawKnownStr[e_label] = BAD_CAST("label");
    rawKnownStr[e_license] = BAD_CAST("license");
    rawKnownStr[e_m] = BAD_CAST("m");
    rawKnownStr[e_mime_type] = BAD_CAST("mime_type");
    rawKnownStr[e_mol] = BAD_CAST("mol");
    rawKnownStr[e_name] = BAD_CAST("name");
    rawKnownStr[e_nmode] = BAD_CAST("nmode");
    rawKnownStr[e_nzcross] = BAD_CAST("nzcross");
    rawKnownStr[e_odstate] = BAD_CAST("odstate");
    rawKnownStr[e_offset] = BAD_CAST("offset");
    rawKnownStr[e_opar] = BAD_CAST("opar");
    rawKnownStr[e_org_scilab_xcos_ssp] = BAD_CAST("org.scilab.xcos.ssp");
    rawKnownStr[e_output] = BAD_CAST("output");
    rawKnownStr[e_parameter] = BAD_CAST("parameter");
    rawKnownStr[e_path] = BAD_CAST("path");
    rawKnownStr[e_pointsX] = BAD_CAST("pointsX");
    rawKnownStr[e_pointsY] = BAD_CAST("pointsY");
    rawKnownStr[e_prefix] = BAD_CAST("prefix");
    rawKnownStr[e_properties] = BAD_CAST("properties");
    rawKnownStr[e_rad] = BAD_CAST("rad");
    rawKnownStr[e_rotation] = BAD_CAST("rotation");
    rawKnownStr[e_rpar] = BAD_CAST("rpar");
    rawKnownStr[e_s] = BAD_CAST("s");
    rawKnownStr[e_sim_blocktype] = BAD_CAST("sim_blocktype");
    rawKnownStr[e_sim_dep_ut] = BAD_CAST("sim_dep_ut");
    rawKnownStr[e_sim_function_api] = BAD_CAST("sim_function_api");
    rawKnownStr[e_sim_function_name] = BAD_CAST("sim_function_name");
    rawKnownStr[e_size] = BAD_CAST("size");
    rawKnownStr[e_source] = BAD_CAST("source");
    rawKnownStr[e_sourceBase] = BAD_CAST("sourceBase");
    rawKnownStr[e_ssb] = BAD_CAST("ssb");
    rawKnownStr[e_ssc] = BAD_CAST("ssc");
    rawKnownStr[e_ssd] = BAD_CAST("ssd");
    rawKnownStr[e_ssm] = BAD_CAST("ssm");
    rawKnownStr[e_ssv] = BAD_CAST("ssv");
    rawKnownStr[e_startConnector] = BAD_CAST("startConnector");
    rawKnownStr[e_startElement] = BAD_CAST("startElement");
    rawKnownStr[e_startTime] = BAD_CAST("startTime");
    rawKnownStr[e_state] = BAD_CAST("state");
    rawKnownStr[e_stopTime] = BAD_CAST("stopTime");
    rawKnownStr[e_style] = BAD_CAST("style");
    rawKnownStr[e_suppressUnitConversion] = BAD_CAST("suppressUnitConversion");
    rawKnownStr[e_systemInnerX] = BAD_CAST("systemInnerX");
    rawKnownStr[e_systemInnerY] = BAD_CAST("systemInnerY");
    rawKnownStr[e_target] = BAD_CAST("target");
    rawKnownStr[e_text] = BAD_CAST("text");
    rawKnownStr[e_text_x_modelica] = BAD_CAST("text_x_modelica");
    rawKnownStr[e_thick] = BAD_CAST("thick");
    rawKnownStr[e_type] = BAD_CAST("type");
    rawKnownStr[e_uid] = BAD_CAST("uid");
    rawKnownStr[e_unit] = BAD_CAST("unit");
    rawKnownStr[e_value] = BAD_CAST("value");
    rawKnownStr[e_version] = BAD_CAST("version");
    rawKnownStr[e_width] = BAD_CAST("width");
    rawKnownStr[e_x] = BAD_CAST("x");
    rawKnownStr[e_x1] = BAD_CAST("x1");
    rawKnownStr[e_x2] = BAD_CAST("x2");
    rawKnownStr[e_xcos] = BAD_CAST("xcos");
    rawKnownStr[e_xmlns] = BAD_CAST("xmlns");
    rawKnownStr[e_y] = BAD_CAST("y");
    rawKnownStr[e_y1] = BAD_CAST("y1");
    rawKnownStr[e_y2] = BAD_CAST("y2");
}

SSPResource::~SSPResource()
{
}

/*
 * Intern strings to speedup comparaison
 */
void SSPResource::internPredefinedStrings(xmlTextReaderPtr reader)
{
    // intern the raw strings
    for (int i = 0; i < NB_XCOS_NAMES - 1; ++i)
    {
        readerConstInterned[i] = xmlTextReaderConstString(reader, BAD_CAST(rawKnownStr[i]));
    }

    xmlnsXCOS = xmlTextReaderConstString(reader, BAD_CAST("http://scilab.org/software/xcos/SystemStructurePackage"));
    xmlnsSSC = xmlTextReaderConstString(reader, BAD_CAST("http://ssp-standard.org/SSP1/SystemStructureCommon"));
    xmlnsSSB = xmlTextReaderConstString(reader, BAD_CAST("http://ssp-standard.org/SSP1/SystemStructureSignalDictionary"));
    xmlnsSSD = xmlTextReaderConstString(reader, BAD_CAST("http://ssp-standard.org/SSP1/SystemStructureDescription"));
    xmlnsSSV = xmlTextReaderConstString(reader, BAD_CAST("http://ssp-standard.org/SSP1/SystemStructureParameterValues"));
    xmlnsSSM = xmlTextReaderConstString(reader, BAD_CAST("http://ssp-standard.org/SSP1/SystemStructureParameterMapping"));
};

SSPResource::Result SSPResource::SystemCanvas::grow_by_xcos_ccordinates(Controller& controller, model::BaseObject* o, std::vector<double>& _vecDblShared)
{
    switch (o->kind())
    {
        case ANNOTATION: // fallthrough
        case BLOCK:
        {
            if (!controller.getObjectProperty(o, GEOMETRY, _vecDblShared))
            {
                return SSPResource::Result::Error(o, GEOMETRY);
            }
            if (_vecDblShared.size() != 4)
            {
                return SSPResource::Result::Error(o, GEOMETRY);
            }
            auto [x, y, w, h] = *(double (*)[4])_vecDblShared.data();

            // grow the canvas by the geometry of the object
            double x_bottom = x;
            double y_bottom = y - h;
            double x_top = x + w;
            double y_top = y;

            if (x_bottom < x1)
                x1 = x_bottom;
            if (y_bottom < y1)
                y1 = y_bottom;
            if (x_top > x2)
                x2 = x_top;
            if (y_top > y2)
                y2 = y_top;
            break;
        }
        case LINK:
        {
            if (!controller.getObjectProperty(o, CONTROL_POINTS, _vecDblShared))
            {
                return SSPResource::Result::Error(o, CONTROL_POINTS);
            }

            // do not store sourcePoint nor targetPoint in the SSP
            if (_vecDblShared.size() < 4)
            {
                return SSPResource::Result::Ok();
            }

            // control points are stored in the vector as (x1,y1),(x2,y2),(x3,y3),..
            for (size_t i = 2; i < _vecDblShared.size() - 2; i += 2)
            {
                double x = _vecDblShared[i];
                double y = _vecDblShared[i + 1];

                if (x < x1)
                    x1 = x;
                if (y < y1)
                    y1 = y;
                if (x > x2)
                    x2 = x;
                if (y > y2)
                    y2 = y;
            }
            break;
        }
        case DIAGRAM:
        {
            // do not grow the viewport
            break;
        }
        case PORT:
        {
            // do not grow the viewport
            break;
        }
    }

    // Grow by the attached label
    if (o->kind() == BLOCK || o->kind() == LINK)
    {
        ScicosID label;
        if (!controller.getObjectProperty(o, LABEL, label))
        {
            return SSPResource::Result::Error(o, LABEL);
        }
        if (label != ScicosID())
        {
            model::BaseObject* labelObj = controller.getBaseObject(label);
            if (labelObj == nullptr)
            {
                return SSPResource::Result::Error(o, LABEL);
            }
            return grow_by_xcos_ccordinates(controller, labelObj, _vecDblShared);
        }
    }

    return SSPResource::Result::Ok();
}

namespace
{

SSPResource::Result export_block_to_dot(Controller& controller, std::ostream& ostrm, model::BaseObject* link);
SSPResource::Result export_link_to_dot(Controller& controller, std::ostream& ostrm, model::BaseObject* link);
SSPResource::Result export_outter_to_inner(Controller& controller, std::ostream& ostrm, model::BaseObject* block, enum object_properties_t io, bool port_to_block);

template<enum object_properties_t prop>
SSPResource::Result export_ports_to_dot(Controller& controller, std::ostream& ostrm, model::BaseObject* block, std::string prefix, std::string shape, std::string rank)
{
    std::string name;
    std::vector<ScicosID> ports;

    if (!controller.getObjectProperty(block, prop, ports))
    {
        return SSPResource::Result::Error(block, prop);
    }
    if (ports.empty())
    {
        return SSPResource::Result::Ok();
    }

    ostrm << "{\n";
    ostrm << "  rank=\"" << rank << "\";\n";
    ostrm << "  node [shape=" << shape << "];\n";
    for (size_t i = 0; i < ports.size(); i++)
    {
        model::BaseObject* o = controller.getBaseObject(ports[i]);
        if (o == nullptr)
        {
            return SSPResource::Result::Error(block, prop);
        }

        if (!controller.getObjectProperty(o, NAME, name))
        {
            return SSPResource::Result::Error(o, NAME);
        }
        ostrm << "  port" << o->id() << " " << "[label=\"" << o->id() << " " << prefix << i + 1 << " " << name << "\"];\n";
    }
    ostrm << "}\n";

    return SSPResource::Result::Ok();
}

SSPResource::Result export_outter_to_inner(Controller& controller, std::ostream& ostrm, model::BaseObject* block, enum object_properties_t io, bool port_to_block)
{
    std::vector<ScicosID> innerPorts;
    if (!controller.getObjectProperty(block, opposite_property(io), innerPorts))
    {
        return SSPResource::Result::Error(block, opposite_property(io));
    }
    if (innerPorts.empty())
    {
        return SSPResource::Result::Error(block, opposite_property(io));
    }
    ScicosID innerPort = innerPorts[0];

    std::vector<int> index;
    if (!controller.getObjectProperty(block, IPAR, index))
    {
        return SSPResource::Result::Error(block, IPAR);
    }
    if (index.empty())
    {
        return SSPResource::Result::Error(block, IPAR);
    }

    ScicosID layer;
    if (!controller.getObjectProperty(block, PARENT_BLOCK, layer))
    {
        return SSPResource::Result::Error(block, PARENT_BLOCK);
    }
    if (layer == ScicosID())
    {
        return SSPResource::Result::Error(block, PARENT_BLOCK);
    }
    model::BaseObject* layerObj = controller.getBaseObject(layer);

    std::vector<ScicosID> ports;
    if (!controller.getObjectProperty(layerObj, io, ports))
    {
        return SSPResource::Result::Error(layerObj, io);
    }
    if ((int)ports.size() < index[0])
    {
        return SSPResource::Result::Error(layerObj, io);
    }

    if (port_to_block)
    {
        ostrm << "  port" << ports[index[0] - 1] << " -> port" << innerPort << " [style=dotted,dir=none];\n";
    }
    else
    {
        ostrm << "  port" << innerPort << " -> port" << ports[index[0] - 1] << " [style=dotted,dir=none];\n";
    }

    return SSPResource::Result::Ok();
}

SSPResource::Result export_block_to_dot(Controller& controller, std::ostream& ostrm, model::BaseObject* block)
{
    std::string name;
    std::string interfaceFunction;
    SSPResource::Result status = SSPResource::Result::Ok();

    ostrm << "subgraph cluster_" << block->id() << " {\n";

    if (!controller.getObjectProperty(block, NAME, name))
    {
        return SSPResource::Result::Error(block, NAME);
    }
    if (!controller.getObjectProperty(block, INTERFACE_FUNCTION, interfaceFunction))
    {
        return SSPResource::Result::Error(block, INTERFACE_FUNCTION);
    }
    ostrm << "  label=\"" << block->id() << " " << name << " " << interfaceFunction << "\";\n";

    status = export_ports_to_dot<INPUTS>(controller, ostrm, block, "in", "rarrow", "source");
    if (status.error())
    {
        return status;
    }
    status = export_ports_to_dot<OUTPUTS>(controller, ostrm, block, "out", "rarrow", "sink");
    if (status.error())
    {
        return status;
    }
    status = export_ports_to_dot<EVENT_INPUTS>(controller, ostrm, block, "ein", "house,orientation=180", "source");
    if (status.error())
    {
        return status;
    }
    status = export_ports_to_dot<EVENT_OUTPUTS>(controller, ostrm, block, "eout", "house,orientation=180", "sink");
    if (status.error())
    {
        return status;
    }

    std::vector<ScicosID> children;
    if (!controller.getObjectProperty(block, CHILDREN, children))
    {
        return SSPResource::Result::Error(block, CHILDREN);
    }
    for (const auto& id : children)
    {
        model::BaseObject* o = controller.getBaseObject(id);
        if (o == nullptr)
        {
            return SSPResource::Result::Error(o, CHILDREN);
        }

        switch (o->kind())
        {
            case BLOCK:
            {
                status = export_block_to_dot(controller, ostrm, o);
                if (status.error())
                {
                    return status;
                }
                break;
            }
            case LINK:
                status = export_link_to_dot(controller, ostrm, o);
                if (status.error())
                {
                    return status;
                }
                break;

            case ANNOTATION:
                break;
            default:
                return SSPResource::Result::Error(block, CHILDREN);
        }
    }

    for (const auto& id : children)
    {
        model::BaseObject* o = controller.getBaseObject(id);
        if (o == nullptr)
        {
            return SSPResource::Result::Error(o, CHILDREN);
        }

        // draw a link between I/O blocks and their corresponding outter port
        if (o->kind() == BLOCK)
        {
            if (!controller.getObjectProperty(o, INTERFACE_FUNCTION, interfaceFunction))
            {
                return SSPResource::Result::Error(o, INTERFACE_FUNCTION);
            }

            if (interfaceFunction == "IN_f" || interfaceFunction == "INIMPL_f")
            {
                status = export_outter_to_inner(controller, ostrm, o, INPUTS, true);
                if (status.error())
                {
                    return status;
                }
            }
            else if (interfaceFunction == "OUT_f" || interfaceFunction == "OUTIMPL_f")
            {
                status = export_outter_to_inner(controller, ostrm, o, OUTPUTS, false);
                if (status.error())
                {
                    return status;
                }
            }
            else if (interfaceFunction == "CLKIN_f" || interfaceFunction == "CLKINV_f")
            {
                status = export_outter_to_inner(controller, ostrm, o, EVENT_INPUTS, true);
                if (status.error())
                {
                    return status;
                }
            }
            else if (interfaceFunction == "CLKOUT_f" || interfaceFunction == "CLKOUTV_f")
            {
                status = export_outter_to_inner(controller, ostrm, o, EVENT_OUTPUTS, false);
                if (status.error())
                {
                    return status;
                }
            }
        }
    }

    ostrm << "}\n";

    return SSPResource::Result::Ok();
}

SSPResource::Result export_link_to_dot(Controller& controller, std::ostream& ostrm, model::BaseObject* link)
{
    ScicosID src;
    if (!controller.getObjectProperty(link, SOURCE_PORT, src))
    {
        return SSPResource::Result::Error(link, SOURCE_PORT);
    }
    ScicosID dest;
    if (!controller.getObjectProperty(link, DESTINATION_PORT, dest))
    {
        return SSPResource::Result::Error(link, DESTINATION_PORT);
    }
    ostrm << "  " << "port" << src << " -> " << "port" << dest << ";\n";

    return SSPResource::Result::Ok();
}

} /* anonymous namespace */

SSPResource::Result SSPResource::export_to_dot(const char* uri)
{
    SSPResource::Result status = Result::Ok();
    std::ofstream ostrm(uri, std::ios::out | std::ios::trunc);

    ostrm << "digraph G {\n";
    ostrm << "rankdir=\"LR\";\n";

    model::BaseObject* diagram = controller.getBaseObject(root);
    if (diagram == nullptr)
    {
        return Result::Error();
    }
    if (diagram->kind() != DIAGRAM)
    {
        return Result::Error();
    }

    std::vector<ScicosID> children;
    if (!controller.getObjectProperty(diagram, CHILDREN, children))
    {
        return Result::Error(diagram, CHILDREN);
    }

    for (const auto& id : children)
    {
        model::BaseObject* o = controller.getBaseObject(id);
        if (o == nullptr)
        {
            return Result::Error(diagram, CHILDREN);
        }

        switch (o->kind())
        {
            case BLOCK:
                status = export_block_to_dot(controller, ostrm, o);
                if (status.error())
                {
                    return status;
                }
                break;
            case LINK:
                status = export_link_to_dot(controller, ostrm, o);
                if (status.error())
                {
                    return status;
                }
                break;
            default:
                return Result::Error(diagram, CHILDREN);
        }
    }

    ostrm << "}\n";
    return Result::Ok();
}

} /* namespace org_scilab_modules_scicos */
