/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2014-2016 - Scilab Enterprises - Clement DAVID
 *  Copyright (C) 2017-2018 - ESI Group - Clement DAVID
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

#include <cwchar>

#include <algorithm>
#include <functional>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

#include "double.hxx"
#include "list.hxx"
#include "string.hxx"
#include "tlist.hxx"

#include "Controller.hxx"
#include "GraphicsAdapter.hxx"
#include "controller_helpers.hxx"
#include "ports_management.hxx"
#include "utilities.hxx"

#include "var2vec.hxx"
#include "vec2var.hxx"

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

const std::wstring MBLOCK(L"MBLOCK");
const std::wstring MPBLOCK(L"MPBLOCK");
const std::wstring in(L"in");
const std::wstring intype(L"intype");
const std::wstring out(L"out");
const std::wstring outtype(L"outtype");
const std::wstring param(L"param");
const std::wstring paramv(L"paramv");
const std::wstring pprop(L"pprop");
const std::wstring nameF(L"nameF");
const std::wstring funtxt(L"funtxt");

// shared informations for relinking across adapters hierarchy
partials_ports_t partial_ports;

struct orig
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        double* data;
        types::Double* o = new types::Double(1, 2, &data);
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> geom;
        controller.getObjectProperty(adaptee, GEOMETRY, geom);

        data[0] = geom[0];
        data[1] = geom[1];

        return o;
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s: Real matrix expected.\n"), "graphics", "orig");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        if (current->getSize() != 2)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s: %d-by-%d expected.\n"), "graphics", "orig", 1, 2);
            return false;
        }

        model::Block* adaptee = adaptor.getAdaptee();
        std::vector<double> geom;
        controller.getObjectProperty(adaptee, GEOMETRY, geom);

        geom[0] = current->get(0);
        geom[1] = current->get(1);

        controller.setObjectProperty(adaptee, GEOMETRY, geom);
        return true;
    }
};

struct sz
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        double* data;
        types::Double* o = new types::Double(1, 2, &data);
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> geom;
        controller.getObjectProperty(adaptee, GEOMETRY, geom);

        data[0] = geom[2];
        data[1] = geom[3];
        return o;
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s: Real matrix expected.\n"), "graphics", "sz");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        if (current->getSize() != 2)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s: %d-by-%d expected.\n"), "graphics", "sz", 1, 2);
            return false;
        }

        model::Block* adaptee = adaptor.getAdaptee();
        std::vector<double> geom;
        controller.getObjectProperty(adaptee, GEOMETRY, geom);

        geom[2] = current->get(0);
        geom[3] = current->get(1);

        controller.setObjectProperty(adaptee, GEOMETRY, geom);
        return true;
    }
};

struct exprs
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> exprs;
        controller.getObjectProperty(adaptee, EXPRS, exprs);

        types::InternalType* res;
        if (!vec2var(exprs, res))
        {
            // if invalid data, return a valid value
            return types::Double::Empty();
        }
        return res;
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        // Corner-case the content is an empty matrix
        if (v->getType() == types::InternalType::ScilabDouble)
        {
            types::Double* current = v->getAs<types::Double>();
            if (!current->isEmpty())
            {
                return false;
            }
        }

        std::vector<double> exprs;
        if (!var2vec(v, exprs))
        {
            return false;
        }
        controller.setObjectProperty(adaptee, EXPRS, exprs);
        return true;
    }
};

types::InternalType* cached_ports_get(const GraphicsAdapter& adaptor, const object_properties_t port_kind, const Controller& controller)
{
    auto it = partial_ports.find(adaptor.getAdaptee()->id());
    if (it == partial_ports.end())
    {
        return get_ports_property<GraphicsAdapter, CONNECTED_SIGNALS>(adaptor, port_kind, controller);
    }

    std::vector<int>* pPorts;
    switch (port_kind)
    {
        case INPUTS:
            pPorts = &it->second.pin;
            break;
        case OUTPUTS:
            pPorts = &it->second.pout;
            break;
        case EVENT_INPUTS:
            pPorts = &it->second.pein;
            break;
        case EVENT_OUTPUTS:
            pPorts = &it->second.peout;
            break;
        default:
            return nullptr;
    }
    std::vector<int> const& ports = *pPorts;

    double* data;
    types::Double* ret = new types::Double(static_cast<int>(ports.size()), 1, &data);

    std::transform(ports.begin(), ports.end(), data, [](int p)
    {
        return p;
    });

    return ret;
}
bool cached_ports_set(GraphicsAdapter& adaptor, const object_properties_t port_kind, Controller& controller, types::InternalType* v)
{
    auto it = partial_ports.find(adaptor.getAdaptee()->id());
    if (it == partial_ports.end())
    {
        bool status = update_ports_property<GraphicsAdapter, CONNECTED_SIGNALS>(adaptor, port_kind, controller, v);
        if (status)
        {
            return status;
        }
        else
        {
            // allocate partial information and continue
            it = partial_ports.insert({adaptor.getAdaptee()->id(), {}}).first;
        }
    }

    if (v->getType() != types::InternalType::ScilabDouble)
    {
        return false;
    }
    types::Double* value = v->getAs<types::Double>();
    std::vector<int>* pPorts;
    switch (port_kind)
    {
        case INPUTS:
            pPorts = &it->second.pin;
            break;
        case OUTPUTS:
            pPorts = &it->second.pout;
            break;
        case EVENT_INPUTS:
            pPorts = &it->second.pein;
            break;
        case EVENT_OUTPUTS:
            pPorts = &it->second.peout;
            break;
        default:
            return false;
    }
    std::vector<int>& ports = *pPorts;

    // store the updated value locally
    {
        ports.resize(value->getSize());
        for (int i = 0; i < value->getSize(); ++i)
        {
            ports[i] = static_cast<int>(value->get(i));
        }
    }

    // enforce the same number of port on the Model
    {
        std::vector<ScicosID> objects;
        controller.getObjectProperty(adaptor.getAdaptee(), port_kind, objects);

        if (ports.size() < objects.size())
        {
            // remove existing ports
            for (size_t i = ports.size(); i < objects.size(); ++i)
            {
                ScicosID p = objects[i];

                ScicosID signal;
                controller.getObjectProperty(p, PORT, CONNECTED_SIGNALS, signal);
                if (signal != ScicosID())
                {
                    model::Link* link = controller.getBaseObject<model::Link>(signal);
                    ScicosID opposite;
                    controller.getObjectProperty(link, DESTINATION_PORT, opposite);
                    if (opposite == p)
                    {
                        controller.setObjectProperty(link, DESTINATION_PORT, ScicosID());
                    }
                    controller.getObjectProperty(link, SOURCE_PORT, opposite);
                    if (opposite == p)
                    {
                        controller.setObjectProperty(link, SOURCE_PORT, ScicosID());
                    }
                }
                controller.deleteObject(p);
            }
            objects.resize(ports.size());
        }
        else
        {
            // add missing ports
            for (size_t i = objects.size(); i < ports.size(); ++i)
            {
                model::Port* p = controller.createBaseObject<model::Port>(PORT);

                controller.setObjectProperty(p, SOURCE_BLOCK, adaptor.getAdaptee()->id());
                controller.setObjectProperty(p, PORT_KIND, port_from_property(port_kind));

                objects.push_back(p->id());
            }
        }
        controller.setObjectProperty(adaptor.getAdaptee(), port_kind, objects);
    }
    return true;
}

struct pin
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return cached_ports_get(adaptor, INPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return cached_ports_set(adaptor, INPUTS, controller, v);
    }
};

struct pout
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return cached_ports_get(adaptor, OUTPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return cached_ports_set(adaptor, OUTPUTS, controller, v);
    }
};

struct pein
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return cached_ports_get(adaptor, EVENT_INPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return cached_ports_set(adaptor, EVENT_INPUTS, controller, v);
    }
};

struct peout
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return cached_ports_get(adaptor, EVENT_OUTPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return cached_ports_set(adaptor, EVENT_OUTPUTS, controller, v);
    }
};

struct gr_i
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& /*controller*/)
    {
        return adaptor.getGrIContent();
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& /*controller*/)
    {
        adaptor.setGrIContent(v);
        return true;
    }
};

struct id
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        ScicosID label;
        std::string description;

        controller.getObjectProperty(adaptee, LABEL, label);
        if (label != ScicosID())
        {
            controller.getObjectProperty(label, ANNOTATION, DESCRIPTION, description);
        }
        else
        {
            controller.getObjectProperty(adaptee, DESCRIPTION, description);
        }

        types::String* o = new types::String(1, 1);
        o->set(0, description.data());
        return o;
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabString)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s: string expected.\n"), "graphics", "id");
            return false;
        }

        types::String* current = v->getAs<types::String>();
        if (!current->isScalar())
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s: %d-by-%d expected.\n"), "graphics", "id", 1, 1);
            return false;
        }

        char* c_str = wide_string_to_UTF8(current->get(0));
        std::string description(c_str);
        FREE(c_str);

        model::Block* adaptee = adaptor.getAdaptee();

        ScicosID label;
        controller.getObjectProperty(adaptee, LABEL, label);
        if (label != ScicosID())
        {
            controller.setObjectProperty(label, ANNOTATION, DESCRIPTION, description);
        }
        else
        {
            controller.setObjectProperty(adaptee, DESCRIPTION, description);
        }
        return true;
    }
};

struct in_implicit
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, IMPLICIT>(adaptor, INPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, IMPLICIT>(adaptor, INPUTS, controller, v);
    }
};

struct out_implicit
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, IMPLICIT>(adaptor, OUTPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, IMPLICIT>(adaptor, OUTPUTS, controller, v);
    }
};

struct in_style
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, STYLE>(adaptor, INPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, STYLE>(adaptor, INPUTS, controller, v);
    }
};

struct out_style
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, STYLE>(adaptor, OUTPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, STYLE>(adaptor, OUTPUTS, controller, v);
    }
};

struct in_label
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, NAME>(adaptor, INPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, NAME>(adaptor, INPUTS, controller, v);
    }
};

struct out_label
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<GraphicsAdapter, NAME>(adaptor, OUTPUTS, controller);
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<GraphicsAdapter, NAME>(adaptor, OUTPUTS, controller, v);
    }
};

struct style
{

    static types::InternalType* get(const GraphicsAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::string style;
        controller.getObjectProperty(adaptee, STYLE, style);

        return new types::String(style.c_str());
    }

    static bool set(GraphicsAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();
        if (v->getType() == types::InternalType::ScilabString)
        {
            types::String* current = v->getAs<types::String>();
            if (!current->isScalar())
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s: %d-by-%d expected.\n"), "graphics", "style", 1, 1);
                return false;
            }

            char* c_str = wide_string_to_UTF8(current->get(0));
            std::string style(c_str);
            FREE(c_str);

            controller.setObjectProperty(adaptee, STYLE, style);
            return true;
        }
        else if (v->getType() == types::InternalType::ScilabDouble)
        {
            types::Double* current = v->getAs<types::Double>();
            if (current->getSize() != 0)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s: string expected.\n"), "graphics", "style");
                return false;
            }

            std::string style;
            controller.setObjectProperty(adaptee, STYLE, style);
            return true;
        }

        get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s: string expected.\n"), "graphics", "style");
        return false;
    }
};

} /* namespace */

#ifndef _MSC_VER
template<>
#endif
property<GraphicsAdapter>::props_t property<GraphicsAdapter>::fields = property<GraphicsAdapter>::props_t();
static void initialize_fields()
{
    if (property<GraphicsAdapter>::properties_have_not_been_set())
    {
        property<GraphicsAdapter>::reserve_properties(16);
        property<GraphicsAdapter>::add_property(L"orig", &orig::get, &orig::set);
        property<GraphicsAdapter>::add_property(L"sz", &sz::get, &sz::set);
        property<GraphicsAdapter>::add_property(L"exprs", &exprs::get, &exprs::set);
        property<GraphicsAdapter>::add_property(L"pin", &pin::get, &pin::set);
        property<GraphicsAdapter>::add_property(L"pout", &pout::get, &pout::set);
        property<GraphicsAdapter>::add_property(L"pein", &pein::get, &pein::set);
        property<GraphicsAdapter>::add_property(L"peout", &peout::get, &peout::set);
        property<GraphicsAdapter>::add_property(L"gr_i", &gr_i::get, &gr_i::set);
        property<GraphicsAdapter>::add_property(L"id", &id::get, &id::set);
        property<GraphicsAdapter>::add_property(L"in_implicit", &in_implicit::get, &in_implicit::set);
        property<GraphicsAdapter>::add_property(L"out_implicit", &out_implicit::get, &out_implicit::set);
        property<GraphicsAdapter>::add_property(L"in_style", &in_style::get, &in_style::set);
        property<GraphicsAdapter>::add_property(L"out_style", &out_style::get, &out_style::set);
        property<GraphicsAdapter>::add_property(L"in_label", &in_label::get, &in_label::set);
        property<GraphicsAdapter>::add_property(L"out_label", &out_label::get, &out_label::set);
        property<GraphicsAdapter>::add_property(L"style", &style::get, &style::set);
        property<GraphicsAdapter>::shrink_to_fit();
    }
}

GraphicsAdapter::GraphicsAdapter() : BaseAdapter<GraphicsAdapter, org_scilab_modules_scicos::model::Block>(),
    gr_i_content(reference_value(types::Double::Empty()))
{
    initialize_fields();
}

GraphicsAdapter::GraphicsAdapter(const Controller& c, model::Block* adaptee) : BaseAdapter<GraphicsAdapter, org_scilab_modules_scicos::model::Block>(c, adaptee),
    gr_i_content(reference_value(types::Double::Empty()))
{
    initialize_fields();
}

GraphicsAdapter::~GraphicsAdapter()
{
    gr_i_content->DecreaseRef();
    gr_i_content->killMe();
}

std::wstring GraphicsAdapter::getTypeStr() const
{
    return getSharedTypeStr();
}

std::wstring GraphicsAdapter::getShortTypeStr() const
{
    return getSharedTypeStr();
}

types::InternalType* GraphicsAdapter::getGrIContent() const
{
    return gr_i_content;
}

void GraphicsAdapter::setGrIContent(types::InternalType* v)
{
    types::InternalType* temp = gr_i_content;

    v->IncreaseRef();
    gr_i_content = v;

    temp->DecreaseRef();
    temp->killMe();
}

static void resolve_log_information(Controller& controller, model::BaseObject* adaptee, object_properties_t p, std::string& property_name, std::string& uid)
{
    std::map<object_properties_t, std::string> map{
        {INPUTS, "pin"},
        {OUTPUTS, "pout"},
        {EVENT_INPUTS, "pein"},
        {EVENT_OUTPUTS, "peout"},
    };
    property_name = map[p];
    controller.getObjectProperty(adaptee, UID, uid);
}


static void relink_cached(Controller& controller, model::BaseObject* adaptee, const std::vector<ScicosID>& children, partial_port_t::value_type& cached_information, object_properties_t p)
{
    std::vector<ScicosID> ports;
    controller.getObjectProperty(adaptee, p, ports);

    if (cached_information.size() < ports.size())
    {
        // model.out contains more ports than graphics.pout ; grows with zero
        cached_information.resize(ports.size());
    }
    else if (cached_information.size() > ports.size() && cached_information != partial_port_t::value_type(cached_information.size()))
    {
        // defensive programming: there is more connections than ports
        // error out as something goes wrong on the adapters
        std::string property_name, uid;
        resolve_log_information(controller, adaptee, p, property_name, uid);
        get_or_allocate_logger()->log(LOG_ERROR, _("Wrong number of \"%s\" ports for Block #%d - \"%s\" : %d expected.\n"), property_name.c_str(), indexOf(adaptee->id(), children), uid.c_str(), (int) cached_information.size());
        return;
    }

    for (size_t i = 0; i < cached_information.size(); ++i)
    {
        // relink
        int index = cached_information[i];
        if (0 < index && index <= (int) children.size())
        {
            // common case: relink to a pre-connected block
            model::Link* opposite = controller.getBaseObject<model::Link>(children[index - 1]);
            if (opposite == nullptr || opposite->kind() != LINK)
            {
                continue;
            }

            model::Port* port = controller.getBaseObject<model::Port>(ports[i]);
            controller.setObjectProperty(port, CONNECTED_SIGNALS, opposite->id());
        }

        // two cases discard the relink here:
        //  * index is set to a link not created yet, it will be resolved at link creation
        //  * index == 0, this is a not connected ; keep it as unconnected
    }
}

// delete the current shared values if the block is fully connected
static void refresh_shared_values(Controller&, model::Block*, partials_ports_t::iterator&)
{
    /*
    // early cleanup is commented out to pass tests where :
    //  1. within a SuperBlock
    //  2. a link is created
    //  3. connected using lnk.from (which might erase the partials)
    //  4. connected using lnk.to
    //
    //  The check show that as the partials are deleted on 3 (if commented out) *BUT* the
    //  block does not appear as connected due to setLinkEnd extra checks for both start
    //  and end. On 4, where setLinkEnd succeed for both side, we have already lost the
    //  reference on this block.

    auto are_all_connected = [&controller,
                              adaptee](object_properties_t portKind)
    {
        std::vector<ScicosID> ports;
        controller.getObjectProperty(adaptee, portKind, ports);

        for (ScicosID p : ports)
        {
            ScicosID connectedSignal = ScicosID();
            controller.getObjectProperty(p, PORT, CONNECTED_SIGNALS, connectedSignal);

            if (connectedSignal == ScicosID())
            {
                return false;
            }
        }
        return true;
    };

    if (are_all_connected(INPUTS) && are_all_connected(OUTPUTS) && are_all_connected(EVENT_INPUTS) && are_all_connected(EVENT_OUTPUTS))
    {

        partial_ports.erase(it);
    }
    */
}

void GraphicsAdapter::relink(Controller& controller, model::Block* adaptee, const std::vector<ScicosID>& children)
{
    auto it = partial_ports.find(adaptee->id());
    if (it == partial_ports.end())
    {
        // unable to relink as there is no information to do so
        return;
    }
    
    relink_cached(controller, adaptee, children, it->second.pin, INPUTS);
    relink_cached(controller, adaptee, children, it->second.pout, OUTPUTS);
    relink_cached(controller, adaptee, children, it->second.pein, EVENT_INPUTS);
    relink_cached(controller, adaptee, children, it->second.peout, EVENT_OUTPUTS);

    refresh_shared_values(controller, adaptee, it);
}

static bool correctly_connected(Controller& controller, ScicosID port,
                                  partial_port_t::value_type& graphics_port,
                                  const std::vector<ScicosID>& children)
{
    ScicosID signal;
    controller.getObjectProperty(port, PORT, CONNECTED_SIGNALS, signal);
    for (int idx : graphics_port)
    {
        if (0 > idx || idx >= (int) children.size())
        {
            return false;
        }
        else if (children[idx] == signal)
        {
            return true;
        }
    }

    return false;
};

static bool incorrectly_connected(Controller& controller, model::Port* port,
                                  partial_port_t::value_type& graphics_port,
                                  const std::vector<ScicosID>& children)
{
    ScicosID signal;
    controller.getObjectProperty(port, CONNECTED_SIGNALS, signal);
    for (int idx : graphics_port)
    {
        if (0 > idx || idx >= (int) children.size())
        {
            return true;
        }
        else if (children[idx] != signal)
        {
            return true;
        }
    }

    return false;
};

// Remove partial information if not needed anymore
static void cleanup(Controller& controller, const std::vector<ScicosID>& children, model::Port* src, model::Port* dst)
{
    // check if the source block is fully connected
    ScicosID source_block = ScicosID();
    controller.getObjectProperty(src, SOURCE_BLOCK, source_block);

    auto source_it = partial_ports.find(source_block);
    if (source_it == partial_ports.end())
    {
        return;
    }

    if (incorrectly_connected(controller, src, source_it->second.pin, children) ||
            incorrectly_connected(controller, src, source_it->second.pout, children) ||
            incorrectly_connected(controller, src, source_it->second.pein, children) ||
            incorrectly_connected(controller, src, source_it->second.peout, children))
    {
        return;
    }

    // check if the destination block is fully connected
    ScicosID destination_block = ScicosID();
    controller.getObjectProperty(dst, SOURCE_BLOCK, destination_block);

    auto destination_it = partial_ports.find(destination_block);
    if (destination_it == partial_ports.end())
    {
        return;
    }

    if (incorrectly_connected(controller, dst, destination_it->second.pin, children) ||
            incorrectly_connected(controller, dst, destination_it->second.pout, children) ||
            incorrectly_connected(controller, dst, destination_it->second.pein, children) ||
            incorrectly_connected(controller, dst, destination_it->second.peout, children))
    {
        return;
    }


    // erase the partial information
    partial_ports.erase(source_it);
    partial_ports.erase(destination_it);
};

void GraphicsAdapter::reverse_relink(Controller& controller, model::Link* adaptee, int index, const std::vector<ScicosID>& children)
{
    ScicosID source = ScicosID();
    ScicosID destination = ScicosID();
    controller.getObjectProperty(adaptee, SOURCE_PORT, source);
    controller.getObjectProperty(adaptee, DESTINATION_PORT, destination);

    model::Port* src = controller.getBaseObject<model::Port>(source);
    model::Port* dst = controller.getBaseObject<model::Port>(destination);

    ScicosID source_parent = ScicosID();
    ScicosID destination_parent = ScicosID();
    controller.getObjectProperty(src, SOURCE_BLOCK, source_parent);
    controller.getObjectProperty(dst, SOURCE_BLOCK, destination_parent);

    int linkType = 0;
    controller.getObjectProperty(adaptee, KIND, linkType);

    auto source_it = partial_ports.find(source_parent);
    if (source_it != partial_ports.end())
    {
        if (linkType == model::activation)
        {
            std::vector<ScicosID> ports;
            controller.getObjectProperty(source_parent, BLOCK, EVENT_OUTPUTS, ports);
            int port_index = indexOf(source, ports);
            if (port_index < (int) source_it->second.peout.size() && 0 <= port_index)
            {
                source_it->second.peout[port_index] = index + 1;
            }
        }
        else // model::regular || model::implicit
        {
            std::vector<ScicosID> ports;
            controller.getObjectProperty(source_parent, BLOCK, OUTPUTS, ports);
            int port_index = indexOf(source, ports);
            if (port_index < (int) source_it->second.pout.size() && 0 <= port_index) // regular indexing
            {
                source_it->second.pout[port_index] = index + 1;
            }
            else if (linkType == model::implicit &&
                     port_index < (int) source_it->second.pin.size() && 0 <= port_index) // second try for implicit reversed link
            {
                source_it->second.pin[port_index] = index + 1;
            }
        }
    }

    auto destination_it = partial_ports.find(destination_parent);
    if (destination_it != partial_ports.end())
    {
        if (linkType == model::activation)
        {
            std::vector<ScicosID> ports;
            controller.getObjectProperty(destination_parent, BLOCK, EVENT_INPUTS, ports);
            int port_index = indexOf(destination, ports);
            if (port_index < (int) destination_it->second.pein.size() && 0 <= port_index)
            {
                destination_it->second.pein[port_index] = index + 1;
            }
        }
        else // model::regular || model::implicit
        {
            std::vector<ScicosID> ports;
            controller.getObjectProperty(destination_parent, BLOCK, INPUTS, ports);
            int port_index = indexOf(destination, ports);
            if (port_index < (int) destination_it->second.pin.size() && 0 <= port_index) // regular indexing
            {
                destination_it->second.pin[port_index] = index + 1;
            }
            else if (linkType == model::implicit &&
                     port_index < (int) destination_it->second.pout.size() && 0 <= port_index) // second try for implicit reversed link
            {
                destination_it->second.pout[port_index] = index + 1;
            }
        }
    }

    cleanup(controller, children, src, dst);
}

void GraphicsAdapter::cleanup_relink(Controller& controller, model::Block* adaptee, const std::vector<ScicosID>& children)
{
    auto it = partial_ports.find(adaptee->id());
    if (it == partial_ports.end())
        return;

    std::vector<ScicosID> ports;
    object_properties_t p = INPUTS;
    controller.getObjectProperty(adaptee, p, ports);
    
    for (ScicosID src : ports)
    {
        if (correctly_connected(controller, src, it->second.pin, children))
            continue;
        else
            return;
    }

    p = OUTPUTS;
    controller.getObjectProperty(adaptee, p, ports);
    for (ScicosID src : ports)
    {
        if (correctly_connected(controller, src, it->second.pin, children))
            continue;
        else
            return;
    }

    p = EVENT_INPUTS;
    controller.getObjectProperty(adaptee, p, ports);
    for (ScicosID src : ports)
    {
        if (correctly_connected(controller, src, it->second.pein, children))
            continue;
        else
            return;
    }

    p = EVENT_OUTPUTS;
    controller.getObjectProperty(adaptee, p, ports);
    for (ScicosID src : ports)
    {
        if (correctly_connected(controller, src, it->second.peout, children))
            continue;
        else
            return;
    }

    // erase the partial information
    partial_ports.erase(it);
}

static void resolve_ports(Controller& controller, model::Block* block, const object_properties_t port_kind, std::vector<int>& resolved, const std::vector<ScicosID>& children)
{
    std::vector<ScicosID> ports;
    controller.getObjectProperty(block, port_kind, ports);

    resolved.resize(ports.size());
    for (size_t i = 0; i < ports.size(); ++i)
    {
        ScicosID link;
        controller.getObjectProperty(ports[i], PORT, CONNECTED_SIGNALS, link);
        if (link == ScicosID())
        {
            resolved[i] = 0;
        }
        else
        {
            resolved[i] = indexOf(link, children) + 1;
        }
    }
}

void GraphicsAdapter::add_partial_links_information(Controller& controller, ScicosID original, ScicosID cloned)
{
    auto it = partial_ports.find(original);
    if (it != partial_ports.end())
    {
        partial_ports.insert(std::make_pair(cloned, it->second));
    }
    else
    {
        model::Block* block = controller.getBaseObject<model::Block>(original);

        std::vector<ScicosID> children;
        ScicosID parentBlock;
        controller.getObjectProperty(block, PARENT_BLOCK, parentBlock);
        if (parentBlock == ScicosID())
        {
            // Adding to a diagram
            ScicosID parentDiagram;
            controller.getObjectProperty(block, PARENT_DIAGRAM, parentDiagram);

            controller.getObjectProperty(parentDiagram, DIAGRAM, CHILDREN, children);
        }
        else
        {
            // Adding to a superblock
            controller.getObjectProperty(parentBlock, BLOCK, CHILDREN, children);
        }

        partial_port_t removed_interface;
        resolve_ports(controller, block, INPUTS, removed_interface.pin, children);
        resolve_ports(controller, block, OUTPUTS, removed_interface.pout, children);
        resolve_ports(controller, block, EVENT_INPUTS, removed_interface.pein, children);
        resolve_ports(controller, block, EVENT_OUTPUTS, removed_interface.peout, children);

        partial_ports.insert(std::make_pair(cloned, removed_interface));
    }
}

static bool connected(const partial_port_t& p)
{
    for (int idx : p.pin)
    {
        if (idx == 0)
        {
            return false;
        }
    }
    for (int idx : p.pout)
    {
        if (idx == 0)
        {
            return false;
        }
    }
    for (int idx : p.pein)
    {
        if (idx == 0)
        {
            return false;
        }
    }
    for (int idx : p.peout)
    {
        if (idx == 0)
        {
            return false;
        }
    }

    return true;
}

static bool compatible(const partial_port_t& added, const partial_port_t& removed)
{
    return added.pin.size() == removed.pin.size() &&
           added.pout.size() == removed.pout.size() &&
           added.pein.size() == removed.pein.size() &&
           added.peout.size() == removed.peout.size();
}

// manage partial information before a model delete
void GraphicsAdapter::store_partial_links_information(Controller& controller, model::BaseObject* added, int index, const std::vector<ScicosID>& children)
{
    model::BaseObject* removed = controller.getBaseObject(children[index]);
    if (removed == nullptr || removed->kind() != BLOCK)
    {
        return;
    }
    if (added == nullptr || added->kind() != BLOCK)
    {
        return;
    }

    // use the cached added information by default
    auto added_it = partial_ports.find(added->id());
    partial_port_t added_interface;
    if (added_it == partial_ports.end())
    {
        return;
    }
    added_interface = added_it->second;

    // resolve the removed information
    auto removed_it = partial_ports.find(removed->id());
    partial_port_t removed_interface;
    if (removed_it == partial_ports.end())
    {
        model::Block* block = static_cast<model::Block*>(removed);

        resolve_ports(controller, block, INPUTS, removed_interface.pin, children);
        resolve_ports(controller, block, OUTPUTS, removed_interface.pout, children);
        resolve_ports(controller, block, EVENT_INPUTS, removed_interface.pein, children);
        resolve_ports(controller, block, EVENT_OUTPUTS, removed_interface.peout, children);
    }
    else
    {
        removed_interface = removed_it->second;
    }

    // relink automatically
    if (!connected(added_interface) && compatible(added_interface, removed_interface))
    {
        added_it->second = removed_interface;
    }
}

// delete all information related to the block
void GraphicsAdapter::remove_partial_links_information(ScicosID uid)
{
    partial_ports.erase(uid);
}

} /* namespace view_scilab */
} /* namespace org_scilab_modules_scicos */
