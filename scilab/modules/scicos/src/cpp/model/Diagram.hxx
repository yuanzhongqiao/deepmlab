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

#ifndef DIAGRAM_HXX_
#define DIAGRAM_HXX_

#include <string>
#include <vector>

#include "Model.hxx"
#include "model/BaseObject.hxx"
#include "model/Block.hxx"
#include "utilities.hxx"

namespace org_scilab_modules_scicos
{
namespace model
{

class Diagram : public BaseObject
{
  public:
    Diagram() : BaseObject(DIAGRAM), m_name("Untitled"), m_path(), m_properties(), m_debugLevel(), m_context(), m_children(), m_version("scicos4.4"), m_ssp_annotation()
    {
        m_color = {-1, 1};
    }

    Diagram(const Diagram& o) : BaseObject(DIAGRAM), m_name(o.m_name), m_path(o.m_path), m_color(o.m_color), m_properties(o.m_properties),
                                m_debugLevel(o.m_debugLevel), m_context(o.m_context), m_children(o.m_children), m_version(o.m_version), m_ssp_annotation(o.m_ssp_annotation) {};

  private:
    friend class ::org_scilab_modules_scicos::Model;

    void getChildren(std::vector<ScicosID>& c) const
    {
        c = m_children;
    }

    update_status_t setChildren(const std::vector<ScicosID>& c)
    {
        if (c == m_children)
        {
            return NO_CHANGES;
        }

        m_children = c;
        return SUCCESS;
    }

    void getContext(std::vector<std::string>& data) const
    {
        data = m_context;
    }

    update_status_t setContext(const std::vector<std::string>& data)
    {
        if (data == m_context)
        {
            return NO_CHANGES;
        }

        m_context = data;
        return SUCCESS;
    }

    // use the pointers-to-members idiom to generalize on any field and any vector of values
    template<typename NamedParameters, typename T>
    void getNP(std::vector<T>& data, T NamedParameters::*field) const
    {
        data.clear();
        data.reserve(m_parameters.size());

        for (auto& p : m_parameters)
        {
            data.push_back(p.*field);
        }
    }

    // use the pointers-to-members idiom to generalize on any field and any vector of values
    template<typename NamedParameters, typename T>
    update_status_t setNP(const std::vector<T>& data, T NamedParameters::*field)
    {
        typename std::vector<T>::const_iterator data_it = data.begin();
        typename std::vector<NamedParameters>::iterator param_it = m_parameters.begin();

        if (data.size() == m_parameters.size())
        {

            while (data_it != data.end())
            {
                if (*data_it != (*param_it).*field)
                    break;
                data_it++;
                param_it++;
            }

            if (data_it == data.end())
                return NO_CHANGES;
        }

        // copy the data on existing indexes
        while (data_it != data.end() && param_it != m_parameters.end())
        {
            (*param_it).*field = *data_it;

            data_it++;
            param_it++;
        }

        // append added data
        while (data_it != data.end())
        {
            NamedParameter v{};
            v.*field = *data_it++;
            m_parameters.push_back(v);
        }

        // remove extra content
        m_parameters.resize(data.size());

        return SUCCESS;
    }

    void getNamedParameters(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::name);
    }

    update_status_t setNamedParameters(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::name);
    }

    void getNamedParametersDescription(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::description);
    }

    update_status_t setNamedParametersDescription(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::description);
    }

    void getNamedParametersUnit(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::unit);
    }

    update_status_t setNamedParametersUnit(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::unit);
    }

    void getNamedParametersTypes(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::sspType);
    }

    update_status_t setNamedParametersTypes(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::sspType);
    }

    void getNamedParametersEncodings(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::encoding);
    }

    update_status_t setNamedParametersEncodings(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::encoding);
    }

    void getNamedParametersValues(std::vector<std::string>& data) const
    {
        getNP(data, &NamedParameter::value);
    }

    update_status_t setNamedParametersValues(const std::vector<std::string>& data)
    {
        return setNP(data, &NamedParameter::value);
    }

  public:
    const std::vector<Datatype*>& getDatatypes() const
    {
        return m_datatypes;
    }

    void setDatatypes(const std::vector<Datatype*>& datatypes)
    {
        this->m_datatypes = datatypes;
    }

  private:
    void getProperties(std::vector<double>& v) const
    {
        m_properties.fill(v);
    }

    update_status_t setProperties(const std::vector<double>& v)
    {
        if (v.size() != 8)
        {
            return FAIL;
        }

        SimulationConfig p = SimulationConfig(v);
        if (p == m_properties)
        {
            return NO_CHANGES;
        }

        m_properties = p;
        return SUCCESS;
    }

    void getDebugLevel(int& data) const
    {
        data = m_debugLevel;
    }

    update_status_t setDebugLevel(const int& data)
    {
        if (data == m_debugLevel)
        {
            return NO_CHANGES;
        }

        m_debugLevel = data;
        return SUCCESS;
    }

    void getName(std::string& data) const
    {
        data = m_name;
    }

    update_status_t setName(const std::string& data)
    {
        if (data == m_name)
        {
            return NO_CHANGES;
        }

        m_name = data;
        return SUCCESS;
    }

    void getDescription(std::string& data) const
    {
        data = m_description;
    }

    update_status_t setDescription(const std::string& data)
    {
        if (data == m_description)
        {
            return NO_CHANGES;
        }

        m_description = data;
        return SUCCESS;
    }

    void getPath(std::string& data) const
    {
        data = m_path;
    }

    update_status_t setPath(const std::string& data)
    {
        if (data == m_path)
        {
            return NO_CHANGES;
        }

        m_path = data;
        return SUCCESS;
    }

    void getAuthor(std::string& data) const
    {
        data = m_author;
    }

    update_status_t setAuthor(const std::string& data)
    {
        if (data == m_author)
        {
            return NO_CHANGES;
        }

        m_author = data;
        return SUCCESS;
    }

    void getFileVersion(std::string& data) const
    {
        data = m_file_version;
    }

    update_status_t setFileVersion(const std::string& data)
    {
        if (data == m_file_version)
        {
            return NO_CHANGES;
        }

        m_file_version = data;
        return SUCCESS;
    }

    void getCopyright(std::string& data) const
    {
        data = m_copyright;
    }

    update_status_t setCopyright(const std::string& data)
    {
        if (data == m_copyright)
        {
            return NO_CHANGES;
        }

        m_copyright = data;
        return SUCCESS;
    }

    void getLicense(std::string& data) const
    {
        data = m_license;
    }

    update_status_t setLicense(const std::string& data)
    {
        if (data == m_license)
        {
            return NO_CHANGES;
        }

        m_license = data;
        return SUCCESS;
    }

    void getGenerationTool(std::string& data) const
    {
        data = m_generation_tool;
    }

    update_status_t setGenerationTool(const std::string& data)
    {
        if (data == m_generation_tool)
        {
            return NO_CHANGES;
        }

        m_generation_tool = data;
        return SUCCESS;
    }

    void getGenerationDate(std::string& data) const
    {
        data = m_generation_date;
    }

    update_status_t setGenerationDate(const std::string& data)
    {
        if (data == m_generation_date)
        {
            return NO_CHANGES;
        }

        m_generation_date = data;
        return SUCCESS;
    }

    void getColor(std::vector<int>& data) const
    {
        data = m_color;
    }

    update_status_t setColor(const std::vector<int>& data)
    {
        if (data == m_color)
        {
            return NO_CHANGES;
        }

        m_color = data;
        return SUCCESS;
    }

    void getVersionNumber(std::string& data) const
    {
        data = m_version;
    }

    update_status_t setVersionNumber(const std::string& data)
    {
        if (data == m_version)
        {
            return NO_CHANGES;
        }

        m_version = data;
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

    void getGlobalXMLNS(std::vector<std::string>& data) const
    {
        data = m_global_xmlns;
    }

    update_status_t setGlobalXMLNS(const std::vector<std::string>& data)
    {
        if (data == m_global_xmlns)
        {
            return NO_CHANGES;
        }

        m_global_xmlns = data;
        return SUCCESS;
    }

    void getGlobalSSPAnnotation(std::vector<std::string>& data) const
    {
        data = m_global_ssp_annotation;
    }

    update_status_t setGlobalSSPAnnotation(const std::vector<std::string>& data)
    {
        if (data == m_global_ssp_annotation)
        {
            return NO_CHANGES;
        }

        m_global_ssp_annotation = data;
        return SUCCESS;
    }

  private:
    std::string m_name;
    std::string m_description;
    std::string m_path;
    std::string m_author;
    std::string m_file_version;
    std::string m_copyright;
    std::string m_license;
    std::string m_generation_tool;
    std::string m_generation_date;

    std::vector<int> m_color;
    SimulationConfig m_properties;
    int m_debugLevel;
    std::vector<std::string> m_context;

    std::vector<NamedParameter> m_parameters;

    std::vector<ScicosID> m_children;
    std::vector<Datatype*> m_datatypes;

    std::string m_version;

    std::vector<std::string> m_ssp_annotation;
    std::vector<std::string> m_global_xmlns;
    std::vector<std::string> m_global_ssp_annotation;
};

} /* namespace model */
} /* namespace org_scilab_modules_scicos */

#endif /* DIAGRAM_HXX_ */
