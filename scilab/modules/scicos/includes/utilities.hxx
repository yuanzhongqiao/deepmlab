/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2014-2016 - Scilab Enterprises - Clement DAVID
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

#ifndef UTILITIES_HXX_
#define UTILITIES_HXX_

/**
 * A unique ID is used to represent a reference to any object in the model.
 *
 * The 'ScicosID()' zero initialization value is used indicate that BaseObject is not handled by the controller.
 */
typedef long long ScicosID;

/**
 * Return status of get and set
 */
enum update_status_t
{
    SUCCESS,    //!< Property updated with new values
    NO_CHANGES, //!< Property unchanged
    FAIL        //!< Update failed
};

/**
 * Kind of model object.
 *
 * All model::BaseObject sub-classes should be listed there. This enum is used to emulate RTTI per Model object.
 */
enum kind_t
{
    BLOCK,      //!< model::Block object
    DIAGRAM,    //!< model::Diagram object
    LINK,       //!< model::Link object
    ANNOTATION, //!< model::Annotation object
    PORT        //!< model::Port object
};

/**
 * Set / Get identifier
 *
 * For each fields of any model::BaseObject, a corresponding identifier exists and is used on the Controller to store and view-dispatch any modification. This field value will be then used by each view to filter out / in important event per-view.
 */
enum object_properties_t
{
    AUTHOR,                //!< model::Diagram::author value
    CHILDREN,              //!< model::Block::children for superblocks or model::Diagram::children value
    COLOR,                 //!< model::Link & Block & Diagram::color value
    CONNECTED_SIGNALS,     //!< model::Port::connectedSignals value
    CONTROL_POINTS,        //!< model::Link::controlPoints value
    COPYRIGHT,             //!< model::Diagram::copyright value
    DATATYPE_COLS,         //!< model::Port::dataType adapter helper
    DATATYPE_ROWS,         //!< model::Port::dataType adapter helper
    DATATYPE_TYPE,         //!< model::Port::dataType adapter helper
    DATATYPE,              //!< model::Port::dataType value
    DEBUG_LEVEL,           //!< model::Diagram::debug_level value
    DESCRIPTION,           //!< model::Annotation::description, model::Diagram::description text
    DESTINATION_PORT,      //!< model::Link::destinationPort value
    DIAGRAM_CONTEXT,       //!< model::Diagram::context value
    DSTATE,                //!< model::Block::dstate value
    EQUATIONS,             //!< model::Block::equations value
    EVENT_INPUTS,          //!< model::Block::ein value
    EVENT_OUTPUTS,         //!< model::Block::eout value
    EXPRS,                 //!< model::Block::exprs value
    FILE_VERSION,          //!< model::Diagram::file_version value
    FIRING,                //!< model::Port::firing value
    FONT_SIZE,             //!< model::Annotation::description font size
    FONT,                  //!< model::Annotation::description font
    GENERATION_DATE,       //!< model::Diagram::generation_date value
    GENERATION_TOOL,       //!< model::Diagram::generation_tool value
    GEOMETRY,              //!< model::Annotation::geometry or model::Block::geometry value
    GLOBAL_SSP_ANNOTATION, //!< Global SSP annotation coming from other tools for the main SystemStructureDescription
    GLOBAL_XMLNS,          //!< Global XML namespaces coming from other tools for the main SystemStructureDescription
    IMPLICIT,              //!< model::Port::implicit value
    INPUTS,                //!< model::Block::in value
    INTERFACE_FUNCTION,    //!< model::Block::interfaceFunction value
    IPAR,                  //!< model::Block::ipar value
    KIND,                  //!< model::Link::kind value
    LABEL,                 //!< model::Block & Port & Link::label or id value
    LICENSE,               //!< model::Diagram::license value
    NAME,                  //!< model::Diagram::name, model::Block::name, model::Port::name
    NMODE,                 //!< model::Block::nmode value
    NZCROSS,               //!< model::Block::nzcross value
    ODSTATE,               //!< model::Block::odstate value
    OPAR,                  //!< model::Block::opar value
    OUTPUTS,               //!< model::Block::out value
    PARAMETER_DESCRIPTION, //!< model::Block::m_parameters generic parameter description
    PARAMETER_ENCODING,    //!< model::Block::m_parameters generic parameter encoding
    PARAMETER_NAME,        //!< model::Block::m_parameters generic parameter name
    PARAMETER_TYPE,        //!< model::Block::m_parameters generic parameter type
    PARAMETER_UNIT,        //!< model::Block::m_parameters generic parameter unit
    PARAMETER_VALUE,       //!< model::Block::m_parameters generic parameter value
    PARENT_BLOCK,          //!< model::*::parentBlock value (used to locate the upper layer in case of SuperBlocks hierarchy)
    PARENT_DIAGRAM,        //!< model::*::parentDiagram value (used to locate the diagram layer)
    PATH,                  //!< model::Diagram::title file path value
    PORT_KIND,             //!< model::Port::kind value
    PORT_NUMBER,           //!< model::Port::portNumber value
    PORT_REFERENCE,        //!< model::Block::portReference value
    PROPERTIES,            //!< model::Diagram::tol & tf values
    RELATED_TO,            //!< model::Annotation::relatedTo
    RPAR,                  //!< model::Block::rpar value
    SIM_BLOCKTYPE,         //!< model::Descriptor::blocktype value (stored into model::Block::sim)
    SIM_DEP_UT,            //!< model::Descriptor::dep_ut value (stored into model::Block::sim)
    SIM_FUNCTION_API,      //!< model::Descriptor::functionApi value (stored into model::Block::sim)
    SIM_FUNCTION_NAME,     //!< model::Descriptor::functionName value (stored into model::Block::sim)
    SIM_SCHEDULE,          //!< model::Descriptor::schedulingProperties value (stored into model::Block::sim)
    SOURCE_BLOCK,          //!< model::Port::sourceBlock value
    SOURCE_PORT,           //!< model::Link::sourcePort value
    SSP_ANNOTATION,        //!< SSP annotation coming from other tools
    STATE,                 //!< model::Block::state value
    STYLE,                 //!< model::Block & Port::style value
    THICK,                 //!< model::Link::thick value
    UID,                   //!< model::Block::uid value
    VERSION_NUMBER,        //!< model::Diagram::version value
    MAX_OBJECT_PROPERTIES  //!< last valid value of the object_properties_t enum
};

/**
 * PORT_KIND valid values
 */
enum portKind
{
    PORT_UNDEF,
    PORT_IN,
    PORT_OUT,
    PORT_EIN,
    PORT_EOUT
};

/**
 * Helper to convert a Property to a Port kind.
 */
constexpr int port_from_property(object_properties_t p)
{
    switch (p)
    {
        case INPUTS:
            return PORT_IN;
        case OUTPUTS:
            return PORT_OUT;
        case EVENT_INPUTS:
            return PORT_EIN;
        case EVENT_OUTPUTS:
            return PORT_EOUT;
        default:
            return PORT_UNDEF;
    }
}

/**
 * Helper to convert a Port kind to a Property.
 */
constexpr object_properties_t property_from_port(enum portKind p)
{
    switch (p)
    {
        case PORT_IN:
            return INPUTS;
        case PORT_OUT:
            return OUTPUTS;
        case PORT_EIN:
            return EVENT_INPUTS;
        case PORT_EOUT:
            return EVENT_OUTPUTS;
        default:
            return MAX_OBJECT_PROPERTIES;
    }
}

/**
 * Helper to switch from outputs ports to input ports and vice-versa.
 */
constexpr object_properties_t opposite_property(object_properties_t prop)
{
    switch (prop)
    {
        case INPUTS:
            return OUTPUTS;
        case OUTPUTS:
            return INPUTS;
        case EVENT_INPUTS:
            return EVENT_OUTPUTS;
        case EVENT_OUTPUTS:
            return EVENT_INPUTS;
        default:
            return MAX_OBJECT_PROPERTIES;
    }
}

/**
 * Helper to switch from outputs ports to input ports and vice-versa.
 */
constexpr enum portKind opposite_port(enum portKind p)
{
    switch (p)
    {
        case PORT_IN:
            return PORT_OUT;
        case PORT_OUT:
            return PORT_IN;
        case PORT_EIN:
            return PORT_EOUT;
        case PORT_EOUT:
            return PORT_EIN;
        default:
            return PORT_UNDEF;
    }
}

#endif /* UTILITIES_HXX_ */
