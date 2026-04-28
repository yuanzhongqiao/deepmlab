/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2014-2016 - Scilab Enterprises - Clement DAVID
 * Copyright (C) 2017-2018 - ESI Group - Clement DAVID
 * Copyright (C) 2022-2023 - Dassault Systèmes S.E. - Clément DAVID
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

#include <algorithm>
#include <iterator>
#include <string>
#include <vector>

#include "double.hxx"
#include "internal.hxx"
#include "list.hxx"
#include "types.hxx"
#include "user.hxx"

#include "Controller.hxx"
#include "LinkAdapter.hxx"
#include "adapters_utilities.hxx"
#include "controller_helpers.hxx"
#include "model/Block.hxx"
#include "model/Link.hxx"
#include "model/Port.hxx"
#include "utilities.hxx"

extern "C" {
#include "charEncoding.h"
#include "localization.h"
#include "sci_malloc.h"
}

namespace org_scilab_modules_scicos
{
namespace view_scilab
{
namespace
{

const std::string split("split");
const std::string lsplit("lsplit");
const std::string limpsplit("limpsplit");

// shared information for relinking across adapters hierarchy
partials_links_t partial_links;

struct xx
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        std::vector<double> controlPoints;
        controller.getObjectProperty(adaptee, CONTROL_POINTS, controlPoints);

        double* data;
        int size = (int)controlPoints.size() / 2;
        types::Double* o = new types::Double(size, 1, &data);

        for (int i = 0; i < size; ++i)
        {
            data[i] = controlPoints[2 * i];
        }
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s: Real matrix object.\n"), "xx");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();

        std::vector<double> controlPoints;
        controller.getObjectProperty(adaptee, CONTROL_POINTS, controlPoints);

        int newXSize = current->getSize();
        int oldXSize = static_cast<int>(controlPoints.size() / 2);
        std::vector<double> newControlPoints(controlPoints);

        if (newXSize == oldXSize)
        {
            for (int i = 0; i < newXSize; ++i)
            {
                newControlPoints[2 * i] = current->getReal()[i];
            }
        }
        else
        {
            newControlPoints.resize(2 * current->getSize(), 0);

            for (int i = 0; i < newXSize; ++i)
            {
                newControlPoints[2 * i] = current->getReal()[i];
            }
        }

        controller.setObjectProperty(adaptee, CONTROL_POINTS, newControlPoints);
        return true;
    }
};

struct yy
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        std::vector<double> controlPoints;
        controller.getObjectProperty(adaptee, CONTROL_POINTS, controlPoints);

        double* data;
        int size = (int)controlPoints.size() / 2;
        types::Double* o = new types::Double(size, 1, &data);

        for (int i = 0; i < size; ++i)
        {
            data[i] = controlPoints[2 * i + 1];
        }
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s: Real matrix object.\n"), "yy");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();

        std::vector<double> controlPoints;
        controller.getObjectProperty(adaptee, CONTROL_POINTS, controlPoints);

        int newYSize = current->getSize();
        int oldYSize = static_cast<int>(controlPoints.size() / 2);
        std::vector<double> newControlPoints(controlPoints);

        if (newYSize == oldYSize)
        {
            for (int i = 0; i < newYSize; ++i)
            {
                newControlPoints[2 * i + 1] = current->getReal()[i];
            }
        }
        else
        {
            newControlPoints.resize(2 * current->getSize());

            for (int i = 0; i < newYSize; ++i)
            {
                newControlPoints[2 * i + 1] = current->getReal()[i];
            }
        }

        controller.setObjectProperty(adaptee, CONTROL_POINTS, newControlPoints);
        return true;
    }
};

struct id
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        std::string id;
        controller.getObjectProperty(adaptee, NAME, id);

        types::String* o = new types::String(id.data());
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabString)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s: String matrix expected.\n"), "id");
            return false;
        }

        types::String* current = v->getAs<types::String>();
        if (current->getSize() != 1)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s: %d-by-%d expected.\n"), "id", 1, 1);
            return false;
        }

        model::Link* adaptee = adaptor.getAdaptee();

        char* c_str = wide_string_to_UTF8(current->get(0));
        std::string description(c_str);
        FREE(c_str);

        controller.setObjectProperty(adaptee, NAME, description);
        return true;
    }
};

struct thick
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        std::vector<double> thick;
        controller.getObjectProperty(adaptee, THICK, thick);

        double* data;
        types::Double* o = new types::Double(1, 2, &data);

        data[0] = thick[0];
        data[1] = thick[1];
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s: Real matrix expected.\n"), "thick");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        if (current->getSize() != 2)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s: %d-by-%d expected.\n"), "thick", 2, 1);
            return false;
        }

        std::vector<double> thick(2);
        thick[0] = current->get(0);
        thick[1] = current->get(1);

        controller.setObjectProperty(adaptee, THICK, thick);
        return true;
    }
};

struct ct
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        int color;
        int kind;
        controller.getObjectProperty(adaptee, COLOR, color);
        controller.getObjectProperty(adaptee, KIND, kind);

        double* data;
        types::Double* o = new types::Double(1, 2, &data);

        data[0] = color;
        data[1] = kind;
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Link* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        if (current->getSize() != 2)
        {
            return false;
        }
        if (floor(current->get(0)) != current->get(0) || floor(current->get(1)) != current->get(1))
        {
            return false;
        }

        int color = static_cast<int>(current->get(0));
        int kind = static_cast<int>(current->get(1));

        controller.setObjectProperty(adaptee, COLOR, color);
        controller.setObjectProperty(adaptee, KIND, kind);
        return true;
    }
};

static link_t getLinkEnd(model::Link* adaptee, const Controller& controller,
                         const object_properties_t end)
{
    link_t ret{0, 0, Start};
    if (end == DESTINATION_PORT)
    {
        ret.kind = End;
    }

    std::string linkUID;
    controller.getObjectProperty(adaptee, UID, linkUID);

    // Looking for the block number among the block IDs
    ScicosID parent = ScicosID();
    kind_t parentKind = BLOCK;
    controller.getObjectProperty(adaptee, PARENT_BLOCK, parent);
    std::vector<ScicosID> children;
    // Added to a superblock
    if (parent == ScicosID())
    {
        // Added to a diagram
        controller.getObjectProperty(adaptee, PARENT_DIAGRAM, parent);
        parentKind = DIAGRAM;
    }
    if (parent == ScicosID())
    {
        return ret;
    }
    controller.getObjectProperty(parent, parentKind, CHILDREN, children);
    
    // resolve the connection
    ScicosID endID = ScicosID();
    controller.getObjectProperty(adaptee, end, endID);
    if (endID == ScicosID())
    {
        //DEBUG std::cerr << "Wrong field value for Link #" << index <<  " - \"" << linkUID << "\" : undefined port.\n";
        return ret;
    }

    ScicosID sourceBlock = ScicosID();
    controller.getObjectProperty(endID, PORT, SOURCE_BLOCK, sourceBlock);
    if (sourceBlock == ScicosID())
    {
        //DEBUG std::cerr << "Wrong field value for Link #" << index <<  " - \"" << linkUID << "\" : undefined matched Block.\n";
        return ret;
    }
    model::Block* sourceBlockObject = controller.getBaseObject<model::Block>(sourceBlock);
    std::string blockUID;
    controller.getObjectProperty(sourceBlock, BLOCK, UID, blockUID);

    // check that link and block share the same layer
    {
        ScicosID sourceParent = ScicosID();
        kind_t sourceParentKind = BLOCK;
        controller.getObjectProperty(sourceBlock, BLOCK, PARENT_BLOCK, sourceParent);
        // Added to a superblock
        if (sourceParent == ScicosID())
        {
            // Added to a diagram
            controller.getObjectProperty(sourceBlock, BLOCK, PARENT_DIAGRAM, sourceParent);
            sourceParentKind = DIAGRAM;
        }
        if (sourceParent != ScicosID() && sourceParent != parent)
        {
            // the layers does not match, we should not create anything else but rather alert the user.
            std::vector<ScicosID> sourceChildren;
            controller.getObjectProperty(sourceParent, sourceParentKind, CHILDREN, sourceChildren);
            
            //DEBUG std::cerr << "Wrong field value for Link #" << index << " - \"" << linkUID << "\" : does not match Block #" << indexOf(sourceBlock, sourceChildren)+1 << " - \"" << blockUID << "\" defined ports.\n";
            return ret;
        }
    }

    ret.block = indexOf(sourceBlock, children) + 1;
    if (ret.block == 0)
    {
        //DEBUG std::cerr << "Wrong field value for Link #" << index << " - \"" << linkUID << "\" : unable to match Block \"" << blockUID << "\" index.\n";
    }

    // To find the port index from its 'endID' ID, search through all the
    // block's ports lists
    std::vector<ScicosID> sourceBlockPorts;
    int portIndex;
    object_properties_t port;
    for (object_properties_t p : { INPUTS, OUTPUTS, EVENT_INPUTS, EVENT_OUTPUTS })
    {
        controller.getObjectProperty(sourceBlockObject, p, sourceBlockPorts);
        portIndex = indexOf(endID, sourceBlockPorts) + 1;
        port = p;
        if (portIndex > 0)
            break;
    }
    ret.port = portIndex;
    
    // this is unlikely to be simpified
    if (port == INPUTS && end == SOURCE_PORT)
        ret.kind = End;
    else if (port == INPUTS && end == DESTINATION_PORT)
        ret.kind = End;
    else if (port == EVENT_INPUTS && end == SOURCE_PORT)
        ret.kind = End;
    else if (port == EVENT_INPUTS && end == DESTINATION_PORT)
        ret.kind = End;
    else if (port == OUTPUTS && end == SOURCE_PORT)
        ret.kind = Start;
    else if (port == OUTPUTS && end == DESTINATION_PORT)
        ret.kind = Start;
    else if (port == EVENT_OUTPUTS && end == SOURCE_PORT)
        ret.kind = Start;
    else if (port == EVENT_OUTPUTS && end == DESTINATION_PORT)
        ret.kind = Start;
    
    // Default case, the property was initialized at [].
    return ret;
}

void setLinkEnd(model::Link* linkObject, Controller& controller, const object_properties_t end, const link_t& v, const std::vector<ScicosID>& children)
{
    ScicosID srcPort = ScicosID();
    controller.getObjectProperty(linkObject, SOURCE_PORT, srcPort);
    ScicosID destPort = ScicosID();
    controller.getObjectProperty(linkObject, DESTINATION_PORT, destPort);
    ScicosID concernedPort;

    if (v.kind != Start && v.kind != End)
    {
        return;
    }
    // kind == 0: trying to set the start of the link (output port)
    // kind == 1: trying to set the end of the link (input port)
    if (end == DESTINATION_PORT)
    {
        concernedPort = destPort;
    }
    else
    {
        concernedPort = srcPort;
    }

    if (v.block == 0 || v.port == 0)
    {
        // We want to set an empty link
        if (concernedPort == ScicosID())
        {
            // In this case, the link was already empty, do a dummy call to display the console status.
            controller.setObjectProperty(linkObject, end, concernedPort);
        }
        else
        {
            // Untie the old link on the concerned end and set its port as unconnected
            controller.setObjectProperty(concernedPort, PORT, CONNECTED_SIGNALS, ScicosID());
            controller.setObjectProperty(linkObject, end, ScicosID());
        }
        return;
    }

    if (v.block < 0 || v.block > static_cast<int>(children.size()))
    {
        return; // Trying to link to a non-existing block
    }
    ScicosID blkID = children[v.block - 1];
    if (blkID == ScicosID())
    {
        // Deleted Block
        return;
    }

    // Check that the ID designates a BLOCK (and not an ANNOTATION)
    model::Block* blkObject = controller.getBaseObject<model::Block>(blkID);
    if (blkObject->kind() != BLOCK)
    {
        return;
    }

    int linkType = 0;
    controller.getObjectProperty(linkObject, KIND, linkType);
    
    // map the ports-containers depending on the link kind 
    object_properties_t oppositePorts[] = {MAX_OBJECT_PROPERTIES, MAX_OBJECT_PROPERTIES};
    switch (linkType)
    {
        case model::activation:
            oppositePorts[Start] = EVENT_OUTPUTS;
            oppositePorts[End] = EVENT_INPUTS;
            break;
        case model::regular:
            oppositePorts[Start] = OUTPUTS;
            oppositePorts[End] = INPUTS;
            break;
        case model::implicit:
            oppositePorts[Start] = OUTPUTS;
            oppositePorts[End] = INPUTS;
            break;
    }

    std::vector<ScicosID> sourceBlockPorts;
    controller.getObjectProperty(blkObject, oppositePorts[v.kind], sourceBlockPorts);

    if (v.port < 1 || (int) sourceBlockPorts.size() < v.port)
    {
        // the interface does not match, we should not create anything else but rather alert the user that he is not matching the block interface.
        int index = indexOf(linkObject->id(), children) + 1;
        std::string linkUID;
        controller.getObjectProperty(linkObject, UID, linkUID);
        std::string blockUID;
        controller.getObjectProperty(blkObject, UID, blockUID);
        get_or_allocate_logger()->log(LOG_WARNING, _("Wrong field value for Link #%d - \"%s\" : does not match Block #%d - \"%s\" defined ports.\n"), index, linkUID.c_str(), v.block, blockUID.c_str());
        return;
    }
    size_t portIndex = v.port - 1;

    // Connect the new one
    concernedPort = sourceBlockPorts[portIndex];
    model::Port* concernedPortObject = controller.getBaseObject<model::Port>(concernedPort);

    ScicosID oldLink = ScicosID();
    controller.getObjectProperty(concernedPortObject, CONNECTED_SIGNALS, oldLink);
    if (oldLink != ScicosID() && oldLink != linkObject->id())
    {
        // Disconnect the old link if it was indeed connected to the concerned port
        ScicosID oldPort = ScicosID();
        controller.getObjectProperty(oldLink, LINK, end, oldPort);
        if (concernedPort == oldPort)
        {
            controller.setObjectProperty(oldLink, LINK, end, ScicosID());
        }
    }

    // Connect the new source and destination ports together
    controller.setObjectProperty(concernedPortObject, CONNECTED_SIGNALS, linkObject->id());
    controller.setObjectProperty(linkObject, end, concernedPort);
}

// Check if the Link is valid
bool is_valid(types::Double* o)
{
    if (o->getSize() == 0)
    {
        return true;
    }

    if (o->getSize() == 2 || o->getSize() == 3)
    {
        if (floor(o->get(0)) != o->get(0) || floor(o->get(1)) != o->get(1))
        {
            return false; // Block and Port numbers must be integer values
        }

        // Block number can be positive (regular indexing) or negative for fictiuous blocks on scicos_flat.sci 
        if (o->get(1) < 0)
        {
            return false; // Port number must be positive
        }

        if (o->getSize() == 3)
        {
            if (floor(o->get(2)) != o->get(2))
            {
                return false; // Kind must be an integer value
            }
            if (o->get(2) < 0)
            {
                return false; // Kind must be positive
            }
        }

        return true;
    }

    return false;
}

struct from
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        link_t from_content;
        auto it = partial_links.find(adaptor.getAdaptee()->id());
        if (it == partial_links.end())
        {
            //DEBUG std::cerr << "from " << adaptor.getAdaptee()->id() << " getLinkEnd\n";

            // if not found use the connected value
            from_content = getLinkEnd(adaptor.getAdaptee(), controller, SOURCE_PORT);
            
            ScicosID p = ScicosID();
            ScicosID b = ScicosID();
            controller.getObjectProperty(adaptor.getAdaptee(), SOURCE_PORT, p);
            controller.getObjectProperty(p, PORT, SOURCE_BLOCK, b);    
        }
        else
        {
            //DEBUG std::cerr << "from " << adaptor.getAdaptee()->id() << " partials\n";

            // if found, use the partial value
            from_content = it->second.from;
        }

        double* data;
        types::Double* o = new types::Double(1, 3, &data);

        data[0] = from_content.block;
        data[1] = from_content.port;
        data[2] = from_content.kind;
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabDouble)
        {
            return false;
        }

        types::Double* current = v->getAs<types::Double>();

        if (!is_valid(current))
        {
            return false;
        }

        link_t from_content{0, 0, Start};
        //double (*c)[3]= (double(*)[3]) current->get();
        if (current->getSize() >= 2)
        {
            from_content.block = static_cast<int>(current->get(0));
            from_content.port = static_cast<int>(current->get(1));
            // By default, 'kind' designates an output (set to 0)

            if (current->getSize() == 3)
            {
                from_content.kind = (current->get(2) == 0.) ? Start : End;
            }
        }

        // store the new data on the adapter, the linking will be performed later on the diagram update
        auto it = partial_links.find(adaptor.getAdaptee()->id());
        if (it == partial_links.end())
        {
            partial_link_t l;
            l.from = from_content;
            l.to = getLinkEnd(adaptor.getAdaptee(), controller, DESTINATION_PORT);

            //DEBUG std::cerr << "store " << adaptor.getAdaptee()->id() << " partials to " << to_string(l) << "\n";
            
            partial_links.insert({adaptor.getAdaptee()->id(), l});
        }
        else
        {
            // warning if there is an invalid from/to connection
            int linkKind;
            controller.getObjectProperty(adaptor.getAdaptee(), KIND, linkKind);
            if (it->second.from.block == from_content.block &&
                it->second.from.port == from_content.port && 
                it->second.from.kind != from_content.kind && 
                linkKind != model::implicit)
            {
                std::vector<ScicosID> children;
                ScicosID parent;
                controller.getObjectProperty(adaptor.getAdaptee(), PARENT_BLOCK, parent);
                if (parent == ScicosID())
                {
                    controller.getObjectProperty(adaptor.getAdaptee(), PARENT_DIAGRAM, parent);
                    controller.getObjectProperty(parent, DIAGRAM, CHILDREN, children);
                }
                else
                {
                    controller.getObjectProperty(parent, BLOCK, CHILDREN, children);
                }
                int index = indexOf(adaptor.getAdaptee()->id(), children) + 1;
                if (index > 0)
                {
                    get_or_allocate_logger()->log(LOG_WARNING, _("Wrong field value for Link #%d: \"from(3)\" changed its kind from %d to %d.\n"), index, it->second.from.kind, from_content.kind);
                }
            }
            it->second.from = from_content;
        }
        return true;
    }
};

struct to
{

    static types::InternalType* get(const LinkAdapter& adaptor, const Controller& controller)
    {
        link_t to_content;
        auto it = partial_links.find(adaptor.getAdaptee()->id());

        if (it == partial_links.end())
        {
            //DEBUG std::cerr << "to " << adaptor.getAdaptee()->id() << " getLinkEnd\n";
            // if not found use the connected value
            to_content = getLinkEnd(adaptor.getAdaptee(), controller, DESTINATION_PORT);
            
            ScicosID p = ScicosID();
            ScicosID b = ScicosID();
            controller.getObjectProperty(adaptor.getAdaptee(), DESTINATION_PORT, p);
            controller.getObjectProperty(p, PORT, SOURCE_BLOCK, b);
        }
        else
        {
            //DEBUG std::cerr << "to " << adaptor.getAdaptee()->id() << " partials\n";
            // if found, use the partial value
            to_content = it->second.to;
        }

        double* data;
        types::Double* o = new types::Double(1, 3, &data);

        data[0] = to_content.block;
        data[1] = to_content.port;
        data[2] = to_content.kind;
        return o;
    }

    static bool set(LinkAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabDouble)
        {
            return false;
        }

        types::Double* current = v->getAs<types::Double>();

        if (current->getSize() != 0 && current->getSize() != 2 && current->getSize() != 3)
        {
            return false;
        }

        if (!is_valid(current))
        {
            return false;
        }

        link_t to_content{0, 0, End};
        //double (*c)[3]= (double(*)[3]) current->get();
        if (current->getSize() >= 2)
        {
            to_content.block = static_cast<int>(current->get(0));
            to_content.port = static_cast<int>(current->get(1));
            // By default, 'kind' designates an input (set to 1)

            if (current->getSize() == 3)
            {
                to_content.kind = (current->get(2) == 0.) ? Start : End;
            }
        }

        // store the new data on the adapter, the linking will be performed later on the diagram update
        auto it = partial_links.find(adaptor.getAdaptee()->id());
        if (it == partial_links.end())
        {
            partial_link_t l;
            l.from = getLinkEnd(adaptor.getAdaptee(), controller, SOURCE_PORT);
            l.to = to_content;
            //DEBUG std::cerr << "store " << adaptor.getAdaptee()->id() << " partials from " << to_string(l) << "\n";
            partial_links.insert({adaptor.getAdaptee()->id(), l});
        }
        else
        {
            // warning if there is an invalid from/to connection
            int linkKind;
            controller.getObjectProperty(adaptor.getAdaptee(), KIND, linkKind);
            if (it->second.to.block == to_content.block &&
                it->second.to.port == to_content.port && 
                it->second.to.kind != to_content.kind && 
                linkKind != model::implicit)
            {
                std::vector<ScicosID> children;
                ScicosID parent;
                controller.getObjectProperty(adaptor.getAdaptee(), PARENT_BLOCK, parent);
                if (parent == ScicosID())
                {
                    controller.getObjectProperty(adaptor.getAdaptee(), PARENT_DIAGRAM, parent);
                    controller.getObjectProperty(parent, DIAGRAM, CHILDREN, children);
                }
                else
                {
                    controller.getObjectProperty(parent, BLOCK, CHILDREN, children);
                }
                int index = indexOf(adaptor.getAdaptee()->id(), children) + 1;
                if (index > 0)
                {
                    get_or_allocate_logger()->log(LOG_WARNING, _("Wrong field value for Link #%d: \"to(3)\" changed its kind from %d to %d.\n"), index, it->second.to.kind, to_content.kind);
                }
            }
            it->second.to = to_content;
        }
        return true;
    }
};

} /* namespace */

#ifndef _MSC_VER
template<>
#endif
property<LinkAdapter>::props_t property<LinkAdapter>::fields = property<LinkAdapter>::props_t();

LinkAdapter::LinkAdapter(const Controller& c, org_scilab_modules_scicos::model::Link* adaptee) : BaseAdapter<LinkAdapter, org_scilab_modules_scicos::model::Link>(c, adaptee)
{
    if (property<LinkAdapter>::properties_have_not_been_set())
    {
        property<LinkAdapter>::reserve_properties(7);
        property<LinkAdapter>::add_property(L"xx", &xx::get, &xx::set);
        property<LinkAdapter>::add_property(L"yy", &yy::get, &yy::set);
        property<LinkAdapter>::add_property(L"id", &id::get, &id::set);
        property<LinkAdapter>::add_property(L"thick", &thick::get, &thick::set);
        property<LinkAdapter>::add_property(L"ct", &ct::get, &ct::set);
        property<LinkAdapter>::add_property(L"from", &from::get, &from::set);
        property<LinkAdapter>::add_property(L"to", &to::get, &to::set);
        property<LinkAdapter>::shrink_to_fit();
    }
}

LinkAdapter::LinkAdapter(const LinkAdapter& adapter) : BaseAdapter<LinkAdapter, org_scilab_modules_scicos::model::Link>(adapter)
{
}

LinkAdapter::~LinkAdapter()
{
}

std::wstring LinkAdapter::getTypeStr() const
{
    return getSharedTypeStr();
}
std::wstring LinkAdapter::getShortTypeStr() const
{
    return getSharedTypeStr();
}

// used to debug a link connection, will be compiled out
static inline void displayConnection(Controller& controller, model::Link* adaptee)
{
    if (adaptee == nullptr || (adaptee->id() != 147 && adaptee->id() != 80))
        return;

    std::vector<ScicosID> path;
    path.push_back(ScicosID());
    ScicosID last = path.back();
    controller.getObjectProperty(adaptee, PARENT_BLOCK, path.back());
    while (path.back() != ScicosID())
    {
        last = path.back();
        path.push_back(ScicosID());
        controller.getObjectProperty(last, BLOCK, PARENT_BLOCK, path.back());
    }
    path.pop_back();

    ScicosID diagram = ScicosID();
    controller.getObjectProperty(last, BLOCK, PARENT_DIAGRAM, diagram);

    // display path
    std::vector<ScicosID> children;
    controller.getObjectProperty(diagram, DIAGRAM, CHILDREN, children);
    
    for (auto it = path.rbegin(); it != path.rend(); ++it)
    {
        controller.getObjectProperty(*it, BLOCK, CHILDREN, children);
    }
    
    // display connection
    std::cerr << " = scicos_link(";
    std::cerr << " from=" << to_string(getLinkEnd(adaptee, controller, SOURCE_PORT));
    std::cerr << ",";
    std::cerr << " to=" << to_string(getLinkEnd(adaptee, controller, DESTINATION_PORT));
    std::cerr << ")";

    ScicosID p = ScicosID();
    ScicosID b = ScicosID();
    controller.getObjectProperty(adaptee, SOURCE_PORT, p);
    controller.getObjectProperty(p, PORT, SOURCE_BLOCK, b);
    std::cerr << "\tconnected ";
    std::cerr << "from ( " << p << ", PORT ) ( " << b << " , BLOCK ) ";
    controller.getObjectProperty(adaptee, DESTINATION_PORT, p);
    controller.getObjectProperty(p, PORT, SOURCE_BLOCK, b);
    std::cerr << "to ( " << p << ", PORT ) ( " << b << " , BLOCK )";
    std::cerr << '\n';
}

void refresh_shared_values(Controller& controller, model::Link* adaptee, partials_links_t::iterator& it, const std::vector<ScicosID>& children)
{
    ScicosID from = ScicosID();
    ScicosID fromBlock = ScicosID();
    controller.getObjectProperty(adaptee, SOURCE_PORT, from);
    
    ScicosID to = ScicosID();
    ScicosID toBlock = ScicosID();
    controller.getObjectProperty(adaptee, DESTINATION_PORT, to);

    bool isConnected = from != ScicosID() && to != ScicosID();
    if (isConnected)
    {
        controller.getObjectProperty(from, PORT, SOURCE_BLOCK, fromBlock);
        controller.getObjectProperty(to, PORT, SOURCE_BLOCK, toBlock);
    }

    bool hasAssociatedBlock = fromBlock != ScicosID() && toBlock != ScicosID();
    
    bool associatedBlocksAreInChildren = false;
    if (hasAssociatedBlock)
    {
        associatedBlocksAreInChildren = std::find(children.begin(), children.end(), fromBlock) != children.end() && \
                                        std::find(children.begin(), children.end(), toBlock) != children.end();
    }
    
    if (isConnected && hasAssociatedBlock && associatedBlocksAreInChildren)
    {
        partial_links.erase(it);
       //DEBUG std::cerr << "partials erased Link " << adaptee->id();
       //DEBUG std::cerr << " from: (" << from << " , PORT) (" << fromBlock << " , BLOCK)";
       //DEBUG std::cerr << " to: (" << to << " , PORT) (" << toBlock << " , BLOCK)";
       //DEBUG std::cerr << '\n';
    }
};

void LinkAdapter::relink(Controller& controller, model::Link* adaptee, const std::vector<ScicosID>& children)
{
    auto it = partial_links.find(adaptee->id());
    if (it == partial_links.end())
    {
        // unable to relink as there is no information to do so
        return;
    }
    const partial_link_t& l = it->second;
    
    if (l.from.block <= 0 || l.to.block <= 0)
    {
        // never reconnect a temporary link
        
        //DEBUG std::cerr << "unable to relink  " << to_string(l) << " " << to_string(l) << "\n";
        return;
    }
    
    setLinkEnd(adaptee, controller, SOURCE_PORT, l.from, children);
    setLinkEnd(adaptee, controller, DESTINATION_PORT, l.to, children);

    refresh_shared_values(controller, adaptee, it, children);
    //DEBUG displayConnection(controller, adaptee);
}

std::vector<model::Port*> getPorts(Controller& controller, model::Block* adaptee, object_properties_t port_kind)
{
    std::vector<ScicosID> ids;
    controller.getObjectProperty(adaptee, port_kind, ids);

    std::vector<model::Port*> ports;
    ports.reserve(ids.size());
    for (ScicosID id : ids)
    {
        ports.push_back(controller.getBaseObject<model::Port>(id));
    }

    return ports;
}

void LinkAdapter::reverse_relink(Controller& controller, model::Block* adaptee, const std::vector<ScicosID>& children)
{
    for (object_properties_t p :
            {
                INPUTS, OUTPUTS, EVENT_INPUTS, EVENT_OUTPUTS
            })
    {
        std::vector<model::Port*> ports = getPorts(controller, adaptee, p);

        for (size_t i = 0; i < ports.size(); i++)
        {
            ScicosID signal = ScicosID();
            controller.getObjectProperty(ports[i], CONNECTED_SIGNALS, signal);
            if (signal == ScicosID())
                continue;
            model::Link* link = controller.getBaseObject<model::Link>(signal);
            //DEBUG displayConnection(controller, link);            

            auto it = partial_links.find(signal);
            if (it != partial_links.end())
            {
                const partial_link_t& l = it->second;

                if (l.from.block <= 0 || l.to.block <= 0)
                {
                    // never reconnect a temporary link
                    
                    //DEBUG std::cerr << "unable to relink  " << to_string(l) << " " << to_string(l) << "\n";
                    return;
                }
                
                setLinkEnd(link, controller, SOURCE_PORT, l.from, children);
                setLinkEnd(link, controller, DESTINATION_PORT, l.to, children);

                refresh_shared_values(controller, link, it, children);
            }
        }
    }
}

void LinkAdapter::cleanup_relink(Controller& controller, model::Link* adaptee, const std::vector<ScicosID>& children)
{
    auto link = partial_links.find(adaptee->id());
    if (link != partial_links.end())
    {
        refresh_shared_values(controller, adaptee, link, children);
    }
}

void LinkAdapter::add_partial_links_information(Controller& controller, ScicosID port)
{
    ScicosID opposite = ScicosID();
    controller.getObjectProperty(port, PORT, CONNECTED_SIGNALS, opposite);
    if (opposite == ScicosID())
        return;

    auto it = partial_links.find(opposite);
    if (it == partial_links.end())
    {
        model::Link* link = controller.getBaseObject<model::Link>(opposite);
        //DEBUG displayConnection(controller, link);

        partial_link_t l;
        l.from = getLinkEnd(link, controller, SOURCE_PORT);
        l.to = getLinkEnd(link, controller, DESTINATION_PORT);
        
        //DEBUG std::cerr << "add " << opposite << " partials from " << to_string(l) << "\n";
        partial_links.insert({opposite, l});
        //DEBUG displayConnection(controller, controller.getBaseObject<model::Link>(opposite));
    }
}

void LinkAdapter::add_partial_links_information(Controller& controller, ScicosID original, ScicosID cloned)
{
    auto it = partial_links.find(original);
    if (it != partial_links.end())
    {
        //DEBUG std::cerr << "copy " << original << " to " << cloned << " partials from " << to_string(it->second) << "\n";
        partial_links.insert({cloned, it->second});
    }
    else
    {
        model::Link* link = controller.getBaseObject<model::Link>(original);
        //DEBUG displayConnection(controller, link);

        partial_link_t l;
        l.from = getLinkEnd(link, controller, SOURCE_PORT);
        l.to = getLinkEnd(link, controller, DESTINATION_PORT);
        
        //DEBUG std::cerr << "add " << cloned << " partials from " << to_string(l) << "\n";
        partial_links.insert({cloned, l});
        //DEBUG displayConnection(controller, controller.getBaseObject<model::Link>(cloned));
    }
}

void reverse_store(Controller& controller, model::Block* removed, object_properties_t port_kind)
{
    std::vector<model::Port*> ports = getPorts(controller, removed, port_kind);
    for (model::Port* p : ports)
    {
        ScicosID signal = ScicosID();
        controller.getObjectProperty(p, CONNECTED_SIGNALS, signal);
        if (signal == ScicosID())
        {
            continue;
        }
        model::Link* link = controller.getBaseObject<model::Link>(signal);
        //DEBUG displayConnection(controller, link);

        auto it = partial_links.find(link->id());
        if (it == partial_links.end())
        {
            partial_link_t l;
            l.from = getLinkEnd(link, controller, SOURCE_PORT);
            l.to = getLinkEnd(link, controller, DESTINATION_PORT);

            //DEBUG std::cerr << "reverse_store " << link->id() << " partials from " << to_string(l) << "\n";
            partial_links.insert({link->id(), l});
        }
    }
}

// manage partial information before a model delete
void LinkAdapter::store_partial_links_information(Controller& controller, model::BaseObject* added, int index, const std::vector<ScicosID>& children)
{
    model::BaseObject* removed = controller.getBaseObject(children[index]);
    if (removed == nullptr || added == nullptr)
    {
        return;
    }

    if (removed->kind() == LINK && added->kind() == LINK)
    {
        model::Link* link = static_cast<model::Link*>(added);
        //DEBUG displayConnection(controller, link);

        ScicosID parent = ScicosID();
        controller.getObjectProperty(link, PARENT_BLOCK, parent);
        if (parent == ScicosID())
        {
            controller.getObjectProperty(link, PARENT_DIAGRAM, parent);
        }
        if (parent != ScicosID())
        {
            partial_link_t l;
            l.from = getLinkEnd(link, controller, SOURCE_PORT);
            l.to = getLinkEnd(link, controller, DESTINATION_PORT);
            
            //DEBUG std::cerr << "store " << link->id() << " partials from " << to_string(l) << "\n";
            partial_links.insert({link->id(), l});
        }
    }
    else if (removed->kind() == BLOCK && added->kind() == BLOCK)
    {
        model::Block* block = static_cast<model::Block*>(removed);

        reverse_store(controller, block, INPUTS);
        reverse_store(controller, block, OUTPUTS);
        reverse_store(controller, block, EVENT_INPUTS);
        reverse_store(controller, block, EVENT_OUTPUTS);
    }
}

// delete all information related to the block
void LinkAdapter::remove_partial_links_information(ScicosID uid)
{
    auto it = partial_links.find(uid);
    if (it != partial_links.end())
       //DEBUG std::cerr << "erase " << uid << " partials " << to_string(it->second) << "\n";
    partial_links.erase(uid);
}

} /* namespace view_scilab */
} /* namespace org_scilab_modules_scicos */
