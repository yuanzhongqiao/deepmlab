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

#ifndef PORT_HXX_
#define PORT_HXX_

#include <string>
#include <vector>

#include "utilities.hxx"
#include "Model.hxx"
#include "model/BaseObject.hxx"

namespace org_scilab_modules_scicos
{
namespace model
{

class Port: public BaseObject
{
public:
    Port() : BaseObject(PORT), m_uid(), m_dataType(nullptr), m_sourceBlock(ScicosID()), m_kind(PORT_UNDEF), m_implicit(false),
        m_style(), m_name(), m_description(), m_unit(), m_firing(0), m_connectedSignals(), m_ssp_annotation()
    {
        m_connectedSignals = {ScicosID()};
    }
    Port(const Port& o) : BaseObject(PORT), m_uid(o.m_uid), m_dataType(o.m_dataType), m_sourceBlock(o.m_sourceBlock), m_kind(o.m_kind), m_implicit(o.m_implicit),
        m_style(o.m_style), m_name(o.m_name), m_description(o.m_description), m_unit(o.m_unit), m_firing(0), m_connectedSignals(o.m_connectedSignals), m_ssp_annotation(o.m_ssp_annotation) {};

private:
    friend class ::org_scilab_modules_scicos::Model;

    void getUID(std::string& data) const
    {
        data = m_uid;
    }

    update_status_t setUID(const std::string& data)
    {
        if (data == m_uid)
        {
            return NO_CHANGES;
        }

        m_uid = data;
        return SUCCESS;
    }

    const std::vector<ScicosID>& getConnectedSignals() const
    {
        return m_connectedSignals;
    }

    update_status_t setConnectedSignals(const std::vector<ScicosID>& connectedSignals)
    {
        if (this->m_connectedSignals == connectedSignals)
        {
            return NO_CHANGES;
        }

        this->m_connectedSignals = connectedSignals;
        if (m_connectedSignals.empty())
        {
            m_connectedSignals = std::vector<ScicosID> (1, 0);
        }
        return SUCCESS;
    }

    void getDataType(std::vector<int>& v) const
    {
        if (m_dataType == nullptr)
        {
            // By default, size is set to [-1,1] and type to real (1)
            v.assign(3, 1);
            v[0] = -1;
        }
        else
        {
            v.resize(3);
            v[0] = m_dataType->m_rows;
            v[1] = m_dataType->m_columns;
            v[2] = m_dataType->m_datatype_id;
        }
    }

    update_status_t setDataType(Model* model, const std::vector<int>& v)
    {
        if (v.size() != 3)
        {
            return FAIL;
        }

        model::Datatype datatype = model::Datatype(v);
        if (this->m_dataType != 0 && *this->m_dataType == datatype)
        {
            return NO_CHANGES;
        }

        this->m_dataType = model->flyweight(std::move(datatype));
        return SUCCESS;
    }

    void getDataTypeRows(int& v) const
    {
        if (m_dataType == 0)
        {
            // By default, size is set to [-1,1] and type to real (1)
            v = -1;
        }
        else
        {
            v = m_dataType->m_rows;
        }
    }

    update_status_t setDataTypeRows(Model* model, const int& v)
    {
        
        if (this->m_dataType != 0 && this->m_dataType->m_datatype_id == v)
        {
            return NO_CHANGES;
        }

        std::vector<int> d;
        getDataType(d);
        d[0] = v;

        return setDataType(model, d);
    }

    void getDataTypeCols(int& v) const
    {
        if (m_dataType == 0)
        {
            // By default, size is set to [-1,1] and type to real (1)
            v = 1;
        }
        else
        {
            v = m_dataType->m_columns;
        }
    }

    update_status_t setDataTypeCols(Model* model, const int& v)
    {
        
        if (this->m_dataType != 0 && this->m_dataType->m_columns == v)
        {
            return NO_CHANGES;
        }

        std::vector<int> d;
        getDataType(d);
        d[1] = v;

        return setDataType(model, d);
    }

    void getDataTypeType(int& v) const
    {
        if (m_dataType == 0)
        {
            // By default, size is set to [-1,1] and type to real (1)
            v = 1;
        }
        else
        {
            v = m_dataType->m_datatype_id;
        }
    }

    update_status_t setDataTypeType(Model* model, const int& v)
    {
        
        if (this->m_dataType != 0 && this->m_dataType->m_datatype_id == v)
        {
            return NO_CHANGES;
        }

        std::vector<int> d;
        getDataType(d);
        d[2] = v;

        return setDataType(model, d);
    }

    void getKind(int& k) const
    {
        k = m_kind;
    }

    update_status_t setKind(int k)
    {
        if (k < PORT_UNDEF || k > PORT_EOUT)
        {
            return FAIL;
        }

        if (k == m_kind)
        {
            return NO_CHANGES;
        }

        m_kind = static_cast<portKind>(k);
        return SUCCESS;
    }

    void getSourceBlock(ScicosID& sb) const
    {
        sb = m_sourceBlock;
    }

    update_status_t setSourceBlock(const ScicosID sb)
    {
        if (sb == this->m_sourceBlock)
        {
            return NO_CHANGES;
        }
        this->m_sourceBlock = sb;
        return SUCCESS;
    }

    void getImplicit(bool& v) const
    {
        v = m_implicit;
    }

    update_status_t setImplicit(bool implicit)
    {
        if (implicit == this->m_implicit)
        {
            return NO_CHANGES;
        }
        this->m_implicit = implicit;
        return SUCCESS;
    }

    void getStyle(std::string& s) const
    {
        s = m_style;
    }

    update_status_t setStyle(const std::string& style)
    {
        if (style == this->m_style)
        {
            return NO_CHANGES;
        }
        this->m_style = style;
        return SUCCESS;
    }

    void getName(std::string& l) const
    {
        l = m_name;
    }

    update_status_t setName(const std::string& name)
    {
        if (name == this->m_name)
        {
            return NO_CHANGES;
        }
        this->m_name = name;
        return SUCCESS;
    }

    void getDescription(std::string& description) const
    {
        description = m_description;
    }

    update_status_t setDescription(const std::string& description)
    {
        if (description == this->m_description)
        {
            return NO_CHANGES;
        }
        this->m_description = description;
        return SUCCESS;
    }

    void getUnit(std::string& unit) const
    {
        unit = m_unit;
    }

    update_status_t setUnit(const std::string& unit)
    {
        if (unit == this->m_unit)
        {
            return NO_CHANGES;
        }
        this->m_unit = unit;
        return SUCCESS;
    }

    void getFiring(double& f) const
    {
        f = m_firing;
    }

    update_status_t setFiring(double firing)
    {
        if (firing == this->m_firing)
        {
            return NO_CHANGES;
        }
        this->m_firing = firing;
        return SUCCESS;
    }

    void getSSPAnnotation(std::vector<std::string>& data) const
    {
        data = m_ssp_annotation;
    }

    update_status_t setSSPAnnotation(const std::vector<std::string>& data)
    {
        if (data == m_ssp_annotation)
        {
            return NO_CHANGES;
        }

        m_ssp_annotation = data;
        return SUCCESS;
    }

private:
    std::string m_uid;
    Datatype* m_dataType;
    ScicosID m_sourceBlock;
    portKind m_kind;
    bool m_implicit;
    std::string m_style;
    std::string m_name;
    std::string m_description;
    std::string m_unit;
    double m_firing;

    std::vector<ScicosID> m_connectedSignals;

    std::vector<std::string> m_ssp_annotation;
};

} /* namespace model */
} /* namespace org_scilab_modules_scicos */

#endif /* PORT_HXX_ */
