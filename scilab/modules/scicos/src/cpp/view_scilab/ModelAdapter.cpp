/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2014-2016 - Scilab Enterprises - Clement DAVID
 * Copyright (C) 2017 - ESI Group - Clement DAVID
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
#include <cstring>

#include <string>
#include <vector>
#include <algorithm>
#include <sstream>

#include "bool.hxx"
#include "int.hxx"
#include "double.hxx"
#include "string.hxx"
#include "list.hxx"
#include "mlist.hxx"
#include "user.hxx"

#include "Controller.hxx"
#include "ModelAdapter.hxx"
#include "LinkAdapter.hxx"
#include "DiagramAdapter.hxx"
#include "GraphicsAdapter.hxx"

#include "view_scilab/Adapters.hxx"
#include "ports_management.hxx"
#include "utilities.hxx"
#include "controller_helpers.hxx"

#include "var2vec.hxx"
#include "vec2var.hxx"

extern "C" {
#include "sci_malloc.h"
#include "charEncoding.h"
#include "localization.h"
}

namespace org_scilab_modules_scicos
{
namespace view_scilab
{
namespace
{

types::InternalType* get_with_vec2var(const ModelAdapter& adaptor, const Controller& controller, object_properties_t p)
{
    model::Block* adaptee = adaptor.getAdaptee();

    std::vector<double> prop_content;
    controller.getObjectProperty(adaptee, p, prop_content);

    // Corner-case, the empty content is an empty double
    if (prop_content.empty())
    {
        return types::Double::Empty();
    }

    // The returned value is a list
    types::InternalType* res;
    if (!vec2var(prop_content, res))
    {
        // if invalid data, return a valid value
        return types::Double::Empty();
    }

    return res;
}

bool set_with_var2vec(ModelAdapter& adaptor, types::InternalType* v, Controller& controller, object_properties_t p)
{
    model::Block* adaptee = adaptor.getAdaptee();

    // corner-case the empty content is an empty-double
    if (v->getType() == types::InternalType::ScilabDouble)
    {
        types::Double* current = v->getAs<types::Double>();
        if (current->getSize() != 0)
        {
            return false;
        }

        // prop_content should be empty
        std::vector<double> prop_content;
        controller.setObjectProperty(adaptee, p, prop_content);
        return true;
    }

    std::vector<double> prop_content;
    if (!var2vec(v, prop_content))
    {
        return false;
    }

    controller.setObjectProperty(adaptee, p, prop_content);
    return true;
}

struct sim
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        // First, extract the function Name
        std::string name;
        controller.getObjectProperty(adaptee, SIM_FUNCTION_NAME, name);
        types::String* Name = new types::String(1, 1);
        Name->set(0, name.data());

        // Then the Api. If it is zero, then just return the Name. Otherwise, return a list containing both.
        int api;
        controller.getObjectProperty(adaptee, SIM_FUNCTION_API, api);

        if (api == 0)
        {
            return Name;
        }
        else
        {
            types::Double* Api = new types::Double(static_cast<double>(api));
            types::List* o = new types::List();
            o->set(0, Name);
            o->set(1, Api);
            return o;
        }
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() == types::InternalType::ScilabString)
        {
            types::String* current = v->getAs<types::String>();
            if (current->getSize() != 1)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : %d-by-%d expected.\n"), "model", "sim", 1, 1);
                return false;
            }

            char* c_str = wide_string_to_UTF8(current->get(0));
            std::string name(c_str);
            FREE(c_str);

            // If the input is a scalar string, then the functionApi is 0.
            int api = 0;

            controller.setObjectProperty(adaptee, SIM_FUNCTION_NAME, name);
            controller.setObjectProperty(adaptee, SIM_FUNCTION_API, api);
        }
        else if (v->getType() == types::InternalType::ScilabList)
        {
            // If the input is a 2-sized list, then it must be string and positive integer.
            types::List* current = v->getAs<types::List>();
            if (current->getSize() != 2)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong length for field %s.%s : %d expected.\n"), "model", "sim", 2);
                return false;
            }
            if (current->get(0)->getType() != types::InternalType::ScilabString || current->get(1)->getType() != types::InternalType::ScilabDouble)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : String matrix expected.\n"), "model", "sim");
                return false;
            }

            types::String* Name = current->get(0)->getAs<types::String>();
            if (Name->getSize() != 1)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : %d-by-%d expected.\n"), "model", "sim(1)", 1, 1);
                return false;
            }
            char* c_str = wide_string_to_UTF8(Name->get(0));
            std::string name(c_str);
            FREE(c_str);

            types::Double* Api = current->get(1)->getAs<types::Double>();
            if (Api->getSize() != 1)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : %d-by-%d expected.\n"), "model", "sim(2)", 1, 1);
                return false;
            }
            double api = Api->get(0);
            if (floor(api) != api)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : Round number expected.\n"), "model", "sim(2)");
                return false;
            }
            int api_int = static_cast<int>(api);

            controller.setObjectProperty(adaptee, SIM_FUNCTION_NAME, name);
            controller.setObjectProperty(adaptee, SIM_FUNCTION_API, api_int);
        }
        else
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : String matrix expected.\n"), "model", "sim");
            return false;
        }
        return true;
    }
};

struct in
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, INPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return update_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, INPUTS, controller, v);
    }
};

struct in2
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_COLS>(adaptor, INPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<ModelAdapter, DATATYPE_COLS>(adaptor, INPUTS, controller, v);
    }
};

struct intyp
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_TYPE>(adaptor, INPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<ModelAdapter, DATATYPE_TYPE>(adaptor, INPUTS, controller, v);
    }
};

struct out
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, OUTPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return update_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, OUTPUTS, controller, v);
    }
};

struct out2
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_COLS>(adaptor, OUTPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<ModelAdapter, DATATYPE_COLS>(adaptor, OUTPUTS, controller, v);
    }
};

struct outtyp
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_TYPE>(adaptor, OUTPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<ModelAdapter, DATATYPE_TYPE>(adaptor, OUTPUTS, controller, v);
    }
};

struct evtin
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, EVENT_INPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return update_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, EVENT_INPUTS, controller, v);
    }
};

struct evtout
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, EVENT_OUTPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return update_ports_property<ModelAdapter, DATATYPE_ROWS>(adaptor, EVENT_OUTPUTS, controller, v);
    }
};

struct state
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> state;
        controller.getObjectProperty(adaptee, STATE, state);

        double* data;
        types::Double* o = new types::Double((int)state.size(), 1, &data);
        std::copy(state.begin(), state.end(), data);
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real vector expected.\n"), "model", "state");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        // Only allow vectors and empty matrices
        if (!current->isVector() && current->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong size for field %s.%s : Real vector expected.\n"), "model", "state");
            return false;
        }

        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> state (current->getSize());
        std::copy(current->getReal(), current->getReal() + current->getSize(), state.begin());

        controller.setObjectProperty(adaptee, STATE, state);
        return true;
    }
};

struct dstate
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<double> dstate;
        controller.getObjectProperty(adaptee, DSTATE, dstate);

        double* data;
        types::Double* o = new types::Double((int)dstate.size(), 1, &data);
        std::copy(dstate.begin(), dstate.end(), data);
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() == types::InternalType::ScilabString)
        {
            /*
             * This seems to be a corner-case used for code generation on ScicosLab
             */

            types::String* current = v->getAs<types::String>();
            if (current->getSize() != 1)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "dstate");
                return false;
            }

            std::vector<double> dstate;
            controller.setObjectProperty(adaptee, DSTATE, dstate);
            return true;
        }

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "dstate");
            return false;
        }
        types::Double* current = v->getAs<types::Double>();
        // Only allow vectors and empty matrices
        if (!current->isVector() && current->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : m-by-1 expected.\n"), "model", "dstate");
            return false;
        }

        std::vector<double> dstate (current->getSize());
        std::copy(current->getReal(), current->getReal() + current->getSize(), dstate.begin());

        controller.setObjectProperty(adaptee, DSTATE, dstate);
        return true;
    }
};

struct odstate
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_with_vec2var(adaptor, controller, ODSTATE);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_with_var2vec(adaptor, v, controller, ODSTATE);
    }
};

/*
 * When setting a diagram in 'rpar', the Superblock's ports must be consistent with the "port blocks" inside it.
 * By "port blocks", we mean IN_f, OUT_f, CLKIN_f, CLKOUT_f, CLKINV_f, CLKOUTV_f, INIMPL_f and OUTIMPL_f.
 */
/*
bool setInnerBlocksRefs(ModelAdapter& adaptor, const std::vector<ScicosID>& children, Controller& controller)
{
    const std::string input ("input");
    const std::string output ("output");
    const std::string inimpl ("inimpl");
    const std::string outimpl ("outimpl");

    model::Block* adaptee = adaptor.getAdaptee();

    for (std::vector<ScicosID>::const_iterator it = children.begin(); it != children.end(); ++it)
    {
        if (*it == ScicosID())
        {
            continue; // Rule out mlists (Deleted or Annotations)
        }

        model::BaseObject* child = controller.getBaseObject(*it);
        if (child->kind() == BLOCK) // Rule out Annotations and Links
        {
            std::string name;
            controller.getObjectProperty(child, SIM_FUNCTION_NAME, name);

            // Find the "port blocks"
            if (name == input || name == inimpl || name == output || name == outimpl)
            {
                std::vector<int> ipar;
                controller.getObjectProperty(child, IPAR, ipar);
                if (ipar.size() != 1)
                {
                    std::string uid;
                    controller.getObjectProperty(child, UID, uid);
                    get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : %s (%s) has an invalid port number.\n"), "model", "rpar", name.c_str(), uid.c_str());
                    return false;
                }
                int portIndex = ipar[0];

                // "name" is not enough to tell the event and data ports apart, so check the block's port.
                object_properties_t kind;
                std::vector<ScicosID> innerPort;
                if (name == input || name == inimpl)
                {
                    controller.getObjectProperty(child, OUTPUTS, innerPort);
                    if (!innerPort.empty())
                    {
                        kind = INPUTS;
                    }
                    else
                    {
                        kind = EVENT_INPUTS;
                    }
                }
                else
                {
                    controller.getObjectProperty(child, INPUTS, innerPort);
                    if (!innerPort.empty())
                    {
                        kind = OUTPUTS;
                    }
                    else
                    {
                        kind = EVENT_OUTPUTS;
                    }
                }

                std::vector<ScicosID> superPorts;
                controller.getObjectProperty(adaptee, kind, superPorts);
                if (static_cast<int>(superPorts.size()) < portIndex)
                {
                    if (!superPorts.empty())
                    {
                        // Arbitrarily take the highest possible value in case the user enters a wrong number
                        portIndex = (int)superPorts.size();
                    }
                    else
                    {
                        std::string uid;
                        controller.getObjectProperty(child, UID, uid);
                        get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : %s (%s) has an invalid port number.\n"), "model", "rpar", name.c_str(), uid.c_str());
                        return false;
                    }
                }

                ScicosID port = superPorts[portIndex - 1];

                // Check consistency of the implicitness between the inner and outer ports
                bool isImplicit;
                controller.getObjectProperty(port, PORT, IMPLICIT, isImplicit);
                if (name == input || name == output)
                {
                    if (isImplicit)
                    {
                        std::string uid;
                        controller.getObjectProperty(child, UID, uid);
                        get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : %s (%s) has an invalid implicit port.\n"), "model", "rpar", name.c_str(), uid.c_str());
                        return false;
                    }
                }
                else
                {
                    if (!isImplicit)
                    {
                        std::string uid;
                        controller.getObjectProperty(child, UID, uid);
                        get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : %s (%s) has an invalid explicit port.\n"), "model", "rpar", name.c_str(), uid.c_str());
                        return false;
                    }
                }

                controller.setObjectProperty(child, PORT_REFERENCE, port);
            }
        }
    }
    return true;
}
*/

struct rpar
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<ScicosID> diagramChildren;
        controller.getObjectProperty(adaptee, CHILDREN, diagramChildren);

        if (diagramChildren.empty())
        {
            std::vector<double> rpar;
            controller.getObjectProperty(adaptee, RPAR, rpar);

            double *data;
            types::Double* o = new types::Double((int)rpar.size(), 1, &data);
            std::copy(rpar.begin(), rpar.end(), data);
            return o;
        }
        else // SuperBlock, return the contained diagram (allocating it on demand)
        {
            DiagramAdapter* d = new DiagramAdapter(controller, controller.referenceBaseObject(adaptee));
            return d;
        }
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() == types::InternalType::ScilabDouble)
        {
            types::Double* current = v->getAs<types::Double>();

            std::vector<double> rpar (current->getSize());
            for (int i = 0; i < current->getSize(); ++i)
            {
                rpar[i] = current->get(i);
            }

            controller.setObjectProperty(adaptee, RPAR, rpar);
            return true;
        }
        else if (v->getType() == types::InternalType::ScilabString)
        {
            // Allow Text blocks to define strings in rpar
            return true;
        }
        else if (v->getType() == types::InternalType::ScilabUserType)
        {
            // Make sure the input describes a Diagram
            const Adapters::adapters_index_t adapter_index = Adapters::instance().lookup_by_typename(v->getShortTypeStr());
            if (adapter_index != Adapters::DIAGRAM_ADAPTER)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Diagram expected.\n"), "model", "rpar");
                return false;
            }
            const DiagramAdapter* diagram = v->getAs<DiagramAdapter>();
            DiagramAdapter* superblock = new DiagramAdapter(controller, controller.referenceBaseObject(adaptee));

            // copy the values by name to preserve adaptors specific properties
            superblock->copyProperties(*diagram, controller);

            superblock->killMe();
            return true;
        }
        else if (v->getType() == types::InternalType::ScilabMList)
        {
            DiagramAdapter* diagram = new DiagramAdapter(controller, controller.referenceBaseObject(adaptee));
            if (!diagram->setAsTList(v, controller))
            {
                diagram->killMe();
                return false;
            }

            diagram->killMe();
            return true;
        }
        else
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "rpar");
            return false;
        }
    }
};

double toDouble(const int a)
{
    return static_cast<double>(a);
}

struct ipar
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<int> ipar;
        controller.getObjectProperty(adaptee, IPAR, ipar);

        double *data;
        types::Double* o = new types::Double((int)ipar.size(), 1, &data);
        std::transform(ipar.begin(), ipar.end(), data, toDouble);
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() == types::InternalType::ScilabList)
        {
            std::vector<int> ipar;
            controller.setObjectProperty(adaptee, IPAR, ipar);
            get_or_allocate_logger()->log(LOG_TRACE, _("Wrong type for field %s.%s : List clear previous value.\n"), "model", "ipar");
            return true;
        }

        if (v->getType() == types::InternalType::ScilabDouble)
        {
            return set(adaptor, v->getAs<types::Double>(), controller);
        }
        else if (v->getType() == types::InternalType::ScilabInt32)
        {
            return set(adaptor, v->getAs<types::Int32>(), controller);
        }
        else
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "ipar");
            return false;
        }
    }

    static bool set(ModelAdapter& adaptor, types::Int32* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        // Only allow vectors and empty matrices
        if (!v->isVector() && v->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : m-by-1 matrix expected.\n"), "model", "ipar");
            return false;
        }

        std::vector<int> ipar (v->getSize());
        for (int i = 0; i < v->getSize(); ++i)
        {
            ipar[i] = v->get(i);
        }

        controller.setObjectProperty(adaptee, IPAR, ipar);
        return true;
    }

    static bool set(ModelAdapter& adaptor, types::Double* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        // Only allow vectors and empty matrices
        if (!v->isVector() && v->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : m-by-1 matrix expected.\n"), "model", "ipar");
            return false;
        }

        std::vector<int> ipar (v->getSize());
        for (int i = 0; i < v->getSize(); ++i)
        {
            double value = v->get(i);
            if (floor(value) != value)
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : Integer values expected.\n"), "model", "ipar");
                return false;
            }
            ipar[i] = static_cast<int>(value);
        }

        controller.setObjectProperty(adaptee, IPAR, ipar);
        return true;
    }
};

struct opar
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_with_vec2var(adaptor, controller, OPAR);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_with_var2vec(adaptor, v, controller, OPAR);
    }
};

struct blocktype
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::string type;
        controller.getObjectProperty(adaptee, SIM_BLOCKTYPE, type);

        types::String* o = new types::String(type.c_str());
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabString)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : String expected.\n"), "model", "blocktype");
            return false;
        }

        types::String* current = v->getAs<types::String>();
        if (current->getSize() != 1)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : String expected.\n"), "model", "blocktype");
            return false;
        }

        char* c_str = wide_string_to_UTF8(current->get(0));
        std::string type (c_str);
        FREE(c_str);

        // the value validation is performed on the model
        return controller.setObjectProperty(adaptee, SIM_BLOCKTYPE, type) != FAIL;
    }
};

struct firing
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_ports_property<ModelAdapter, FIRING>(adaptor, EVENT_OUTPUTS, controller);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_ports_property<ModelAdapter, FIRING>(adaptor, EVENT_OUTPUTS, controller, v);
    }
};

struct dep_ut
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<int> dep_ut;
        controller.getObjectProperty(adaptee, SIM_DEP_UT, dep_ut);

        int* dep;
        types::Bool* o = new types::Bool(1, 2, &dep);

        dep[0] = dep_ut[0];
        dep[1] = dep_ut[1];

        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabBool)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Boolean matrix expected.\n"), "model", "dep_ut");
            return false;
        }

        types::Bool* current = v->getAs<types::Bool>();
        if (current->getSize() != 2)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : %d-by-%d expected.\n"), "model", "dep_ut", 1, 2);
            return false;
        }

        std::vector<int> dep_ut (2);
        dep_ut[0] = current->get(0);
        dep_ut[1] = current->get(1);

        controller.setObjectProperty(adaptee, SIM_DEP_UT, dep_ut);
        return true;
    }
};

// Valid C identifier definition
// https://msdn.microsoft.com/en-us/library/e7f8y25b.aspx
bool isValidCIdentifier(const std::string& label)
{
    auto is_nondigit = [](char c)
    {
        return ('A' <= c && c <= 'Z') || ('a' <= c && c <= 'z') || '_' == c;
    };
    auto is_digit = [](char c)
    {
        return ('0' <= c && c <= '9');
    };

    // is a valid but empty string
    if (label.empty())
    {
        return true;
    }
    // the first character should be a non digit
    if (!is_nondigit(label[0]))
    {
        return false;
    }
    // others  should be either a digit or a non digit
    auto found = std::find_if_not(label.begin(), label.end(), [is_nondigit, is_digit](char c)
    {
        return is_nondigit(c) || is_digit(c);
    } );
    return found == label.end();
}

struct label
{
    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::string name;
        controller.getObjectProperty(adaptee, NAME, name);

        types::String* o = new types::String(1, 1);
        o->set(0, name.data());

        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabString)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : String expected.\n"), "model", "label");
            return false;
        }

        types::String* current = v->getAs<types::String>();
        if (current->getSize() != 1)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : String expected.\n"), "model", "label");
            return false;
        }

        model::Block* adaptee = adaptor.getAdaptee();

        char* c_str = wide_string_to_UTF8(current->get(0));
        std::string name(c_str);
        FREE(c_str);

        if (isValidCIdentifier(name))
        {
            //FIXME: is this DESCRIPTION an identifier ?
        //    get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : valid C identifier expected.\n"), "model", "label");
        //    return false;
        }
        else
        {
            name = "";
        }
        return controller.setObjectProperty(adaptee, NAME, name) != FAIL;
    }
};

struct nzcross
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<int> nzcross;
        controller.getObjectProperty(adaptee, NZCROSS, nzcross);

        double *data;
        types::Double* o = new types::Double((int)nzcross.size(), 1, &data);
        std::transform(nzcross.begin(), nzcross.end(), data, toDouble);
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "nzcross");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        // Only allow vectors and empty matrices
        if (!current->isVector() && current->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : m-by-1 expected.\n"), "model", "nzcross");
            return false;
        }

        std::vector<int> nzcross (current->getSize());
        for (int i = 0; i < current->getSize(); ++i)
        {
            if (floor(current->get(i)) != current->get(i))
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : Integer values expected.\n"), "model", "nzcross");
                return false;
            }
            nzcross[i] = static_cast<int>(current->get(i));
        }

        controller.setObjectProperty(adaptee, NZCROSS, nzcross);
        return true;
    }
};

struct nmode
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::vector<int> nmode;
        controller.getObjectProperty(adaptee, NMODE, nmode);

        double *data;
        types::Double* o = new types::Double((int)nmode.size(), 1, &data);
        std::transform(nmode.begin(), nmode.end(), data, toDouble);
        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        if (v->getType() != types::InternalType::ScilabDouble)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : Real matrix expected.\n"), "model", "nmode");
            return false;
        }

        types::Double* current = v->getAs<types::Double>();
        // Only allow vectors and empty matrices
        if (!current->isVector() && current->getSize() != 0)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : m-by-1 expected.\n"), "model", "nzcross");
            return false;
        }

        std::vector<int> nmode (current->getSize());
        for (int i = 0; i < current->getSize(); ++i)
        {
            if (floor(current->get(i)) != current->get(i))
            {
                get_or_allocate_logger()->log(LOG_ERROR, _("Wrong value for field %s.%s : Integer values expected.\n"), "model", "nzcross");
                return false;
            }
            nmode[i] = static_cast<int>(current->get(i));
        }

        controller.setObjectProperty(adaptee, NMODE, nmode);
        return true;
    }
};

struct equations
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        return get_with_vec2var(adaptor, controller, EQUATIONS);
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        return set_with_var2vec(adaptor, v, controller, EQUATIONS);
    }
};

struct uid
{

    static types::InternalType* get(const ModelAdapter& adaptor, const Controller& controller)
    {
        model::Block* adaptee = adaptor.getAdaptee();

        std::string uid;
        controller.getObjectProperty(adaptee, UID, uid);

        types::String* o = new types::String(1, 1);
        o->set(0, uid.data());

        return o;
    }

    static bool set(ModelAdapter& adaptor, types::InternalType* v, Controller& controller)
    {
        if (v->getType() != types::InternalType::ScilabString)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong type for field %s.%s : String expected.\n"), "model", "uid");
            return false;
        }

        types::String* current = v->getAs<types::String>();
        if (current->getSize() != 1)
        {
            get_or_allocate_logger()->log(LOG_ERROR, _("Wrong dimension for field %s.%s : String expected.\n"), "model", "uid");
            return false;
        }

        model::Block* adaptee = adaptor.getAdaptee();

        char* c_str = wide_string_to_UTF8(current->get(0));
        std::string uid(c_str);
        FREE(c_str);

        controller.setObjectProperty(adaptee, UID, uid);
        return true;
    }
};

} /* namespace */

#ifndef _MSC_VER
template<>
#endif
property<ModelAdapter>::props_t property<ModelAdapter>::fields = property<ModelAdapter>::props_t();
static void initialize_fields()
{
    if (property<ModelAdapter>::properties_have_not_been_set())
    {
        property<ModelAdapter>::reserve_properties(23);
        property<ModelAdapter>::add_property(L"sim", &sim::get, &sim::set);
        property<ModelAdapter>::add_property(L"in", &in::get, &in::set);
        property<ModelAdapter>::add_property(L"in2", &in2::get, &in2::set);
        property<ModelAdapter>::add_property(L"intyp", &intyp::get, &intyp::set);
        property<ModelAdapter>::add_property(L"out", &out::get, &out::set);
        property<ModelAdapter>::add_property(L"out2", &out2::get, &out2::set);
        property<ModelAdapter>::add_property(L"outtyp", &outtyp::get, &outtyp::set);
        property<ModelAdapter>::add_property(L"evtin", &evtin::get, &evtin::set);
        property<ModelAdapter>::add_property(L"evtout", &evtout::get, &evtout::set);
        property<ModelAdapter>::add_property(L"state", &state::get, &state::set);
        property<ModelAdapter>::add_property(L"dstate", &dstate::get, &dstate::set);
        property<ModelAdapter>::add_property(L"odstate", &odstate::get, &odstate::set);
        property<ModelAdapter>::add_property(L"rpar", &rpar::get, &rpar::set);
        property<ModelAdapter>::add_property(L"ipar", &ipar::get, &ipar::set);
        property<ModelAdapter>::add_property(L"opar", &opar::get, &opar::set);
        property<ModelAdapter>::add_property(L"blocktype", &blocktype::get, &blocktype::set);
        property<ModelAdapter>::add_property(L"firing", &firing::get, &firing::set);
        property<ModelAdapter>::add_property(L"dep_ut", &dep_ut::get, &dep_ut::set);
        property<ModelAdapter>::add_property(L"label", &label::get, &label::set);
        property<ModelAdapter>::add_property(L"nzcross", &nzcross::get, &nzcross::set);
        property<ModelAdapter>::add_property(L"nmode", &nmode::get, &nmode::set);
        property<ModelAdapter>::add_property(L"equations", &equations::get, &equations::set);
        property<ModelAdapter>::add_property(L"uid", &uid::get, &uid::set);
        property<ModelAdapter>::shrink_to_fit();
    }
}

ModelAdapter::ModelAdapter() :
    BaseAdapter<ModelAdapter, org_scilab_modules_scicos::model::Block>()
{
    initialize_fields();
}

ModelAdapter::ModelAdapter(const Controller& c, model::Block* adaptee) :
    BaseAdapter<ModelAdapter, org_scilab_modules_scicos::model::Block>(c, adaptee)
{
    initialize_fields();
}

ModelAdapter::~ModelAdapter()
{
}

std::wstring ModelAdapter::getTypeStr() const
{
    return getSharedTypeStr();
}

std::wstring ModelAdapter::getShortTypeStr() const
{
    return getSharedTypeStr();
}

} /* namespace view_scilab */
} /* namespace org_scilab_modules_scicos */
