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

#ifndef LOGGERVIEW_HXX_
#define LOGGERVIEW_HXX_

#include <cwchar>
#include <functional>
#include <string>
#include <charconv>

#include "model/BaseObject.hxx"
#include "View.hxx"
#include "utilities.hxx"

namespace org_scilab_modules_scicos
{

enum LogLevel
{
    LOG_UNDEF = -1,   //!< Undefined value
    LOG_TRACE = 0,    //!< more detailed information. Expect these to be written to logs only.
    LOG_DEBUG = 1,    //!< detailed information on the flow through the system. Expect these to be written to logs only.
    LOG_INFO = 2,    //!< Interesting runtime events (startup/shutdown). Expect these to be immediately visible on a console, so be conservative and keep to a minimum.
    LOG_WARNING = 3,    //!<
    LOG_ERROR = 4,    //!< Other runtime errors or unexpected conditions. Expect these to be immediately visible on a status console.
    LOG_FATAL = 5,    //!< Severe errors that cause premature termination. Expect these to be immediately visible on a status console.
};

class LoggerView: public View
{
public:
    LoggerView();
    ~LoggerView();

    /*
     * Implement a classical Logger interface
     */

    static enum LogLevel indexOf(const wchar_t* name);
    static const wchar_t* toString(enum LogLevel level);
    static const std::string toDisplay(enum LogLevel level);

    // get global LogLevel
    inline
    enum LogLevel getLevel() const
    {
        return m_level;
    }
    // get global LogLevel
    inline
    void setLevel(enum LogLevel level)
    {
        this->m_level = level;
    }
    // reset ScicosID numbering to the lastObject value for following logs
    inline
    void setLastObject(ScicosID lastObject)
    {
        this->m_lastObject = lastObject;
    }
    // transform an object to a logging number
    inline
    size_t id(model::BaseObject* o) const
    {
        return id(o->id());
    }
    // transform an object id to a logging number
    inline
    size_t id(ScicosID id) const
    {
        if (id >= m_lastObject)
            return id - m_lastObject;
        return id;
    }

    void log(enum LogLevel level, const std::string& msg);
    void log(enum LogLevel level, const char* msg, ...);
    void log(enum LogLevel level, const wchar_t* msg, ...);
    void log(enum LogLevel level, const std::function <std::to_chars_result(char* first, char* last)> to_chars_fun);

    /*
     * Implement the Logger as a View
     */

    void objectCreated(const ScicosID& uid, kind_t k);
    void objectReferenced(const ScicosID& uid, kind_t k, unsigned refCount);
    void objectUnreferenced(const ScicosID& uid, kind_t k, unsigned refCount);
    void objectDeleted(const ScicosID& uid, kind_t k);
    void objectCloned(const ScicosID& uid, const ScicosID& cloned, kind_t k);
    void propertyUpdated(const ScicosID& uid, kind_t k, object_properties_t p, update_status_t u);

private:
    enum LogLevel m_level;
    ScicosID m_lastObject;

    // shared buffer for logging
    const size_t N = 1024;
    std::string buffer;
};

// helper function: copy a static string str into [first, last), will get inlined
// this will not copy the trailing \0
template<size_t N> constexpr
std::to_chars_result to_chars(char* first, char* last, char const (&str)[N])
{
    if (first == nullptr || last == nullptr)
    {
        return {nullptr, std::errc::invalid_argument};
    }
    if (first >= last)
    {
        return {last, std::errc::value_too_large};
    }
    *first = str[0];

    return to_chars<N - 1>(first + 1, last, (const char (&)[N - 1])(*(str + 1)));
}
template<> constexpr
std::to_chars_result to_chars<1>(char* first, char* last, char const (&str)[1])
{
    if (first == nullptr || last == nullptr)
    {
        return {nullptr, std::errc::invalid_argument};
    }
    // do not copy the trailing \0, return the past-the-end pointer
    return {first, std::errc()};
}
// only available specialisation will apply
template<typename T> constexpr
std::to_chars_result to_chars(char* first, char* last, T t) = delete;
template<> constexpr
std::to_chars_result to_chars(char* first, char* last, std::string_view str)
{
    if (first == nullptr || last == nullptr)
    {
        return {nullptr, std::errc::invalid_argument};
    }
    if (first >= last)
    {
        return {last, std::errc::value_too_large};
    }

    if (str.size() >= static_cast<size_t>(last - first))
    {
        return {last, std::errc::value_too_large};
    }
    for (size_t i = 0; i < str.size(); ++i)
    {
        *first++ = str[i];
    }
    return {first, std::errc()};
}
// fallback to the non-constexpr standard implementation for some arithmetic types
template<> inline
std::to_chars_result to_chars(char* first, char* last, size_t t)
{
    return std::to_chars(first, last, t);
}
template<> inline
std::to_chars_result to_chars(char* first, char* last, unsigned t)
{
    return std::to_chars(first, last, t);
}

// helper struct with an operator+ for concatenating multiple to_chars() functions
struct to_chars_t : std::to_chars_result
{
    char* _last;
 
    explicit constexpr
    to_chars_t(char* first, char* last) : to_chars_result{first, {}}, _last(last) {}

    template<size_t N> constexpr
    to_chars_t operator+(char const (&str)[N])
    {
        if (ec != std::errc())
        {
            return *this;
        }
        auto result = to_chars<>(ptr, _last, str);
        ptr = result.ptr;
        ec = result.ec;
        return *this;
    }

    template<typename T> constexpr
    to_chars_t operator+(const T& t)
    {
        if (ec != std::errc())
        {
            return *this;
        }
        auto result = to_chars<>(ptr, _last, t);
        ptr = result.ptr;
        ec = result.ec;
        return *this;
    }
};

// helper functions generated with :
// awk ' $2 == "//!<" {sub(",","", $1); print "case " $1 ":\n    return to_chars(first, last, \"" $1 "\";" }' modules/scicos/includes/utilities.hxx

template<> inline
std::to_chars_result to_chars(char* first, char* last, update_status_t u)
{
    switch (u)
    {
        case SUCCESS:
            return to_chars(first, last, "SUCCESS");
        case NO_CHANGES:
            return to_chars(first, last, "NO_CHANGES");
        case FAIL:
            return to_chars(first, last, "FAIL");
    }
    return {last, std::errc::invalid_argument};
}

template<> inline
std::to_chars_result to_chars(char* first, char* last, kind_t k)
{
    switch (k)
    {
        case ANNOTATION:
            return to_chars(first, last, "ANNOTATION");
        case BLOCK:
            return to_chars(first, last, "BLOCK");
        case DIAGRAM:
            return to_chars(first, last, "DIAGRAM");
        case LINK:
            return to_chars(first, last, "LINK");
        case PORT:
            return to_chars(first, last, "PORT");
    }
    return {last, std::errc::invalid_argument};
}

template<> inline
std::to_chars_result to_chars(char* first, char* last, object_properties_t p)
{
    switch (p)
    {
        case AUTHOR:
            return to_chars(first, last, "AUTHOR");
        case CHILDREN:
            return to_chars(first, last, "CHILDREN");
        case COLOR:
            return to_chars(first, last, "COLOR");
        case CONNECTED_SIGNALS:
            return to_chars(first, last, "CONNECTED_SIGNALS");
        case CONTROL_POINTS:
            return to_chars(first, last, "CONTROL_POINTS");
        case COPYRIGHT:
            return to_chars(first, last, "COPYRIGHT");
        case DATATYPE_COLS:
            return to_chars(first, last, "DATATYPE_COLS");
        case DATATYPE_ROWS:
            return to_chars(first, last, "DATATYPE_ROWS");
        case DATATYPE_TYPE:
            return to_chars(first, last, "DATATYPE_TYPE");
        case DATATYPE:
            return to_chars(first, last, "DATATYPE");
        case DEBUG_LEVEL:
            return to_chars(first, last, "DEBUG_LEVEL");
        case DESCRIPTION:
            return to_chars(first, last, "DESCRIPTION");
        case DESTINATION_PORT:
            return to_chars(first, last, "DESTINATION_PORT");
        case DIAGRAM_CONTEXT:
            return to_chars(first, last, "DIAGRAM_CONTEXT");
        case DSTATE:
            return to_chars(first, last, "DSTATE");
        case EQUATIONS:
            return to_chars(first, last, "EQUATIONS");
        case EVENT_INPUTS:
            return to_chars(first, last, "EVENT_INPUTS");
        case EVENT_OUTPUTS:
            return to_chars(first, last, "EVENT_OUTPUTS");
        case EXPRS:
            return to_chars(first, last, "EXPRS");
        case FILE_VERSION:
            return to_chars(first, last, "FILE_VERSION");
        case FIRING:
            return to_chars(first, last, "FIRING");
        case FONT_SIZE:
            return to_chars(first, last, "FONT_SIZE");
        case FONT:
            return to_chars(first, last, "FONT");
        case GENERATION_DATE:
            return to_chars(first, last, "GENERATION_DATE");
        case GENERATION_TOOL:
            return to_chars(first, last, "GENERATION_TOOL");
        case GEOMETRY:
            return to_chars(first, last, "GEOMETRY");
        case GLOBAL_SSP_ANNOTATION:
            return to_chars(first, last, "GLOBAL_SSP_ANNOTATION");
        case GLOBAL_XMLNS:
            return to_chars(first, last, "GLOBAL_XMLNS");
        case IMPLICIT:
            return to_chars(first, last, "IMPLICIT");
        case INPUTS:
            return to_chars(first, last, "INPUTS");
        case INTERFACE_FUNCTION:
            return to_chars(first, last, "INTERFACE_FUNCTION");
        case IPAR:
            return to_chars(first, last, "IPAR");
        case KIND:
            return to_chars(first, last, "KIND");
        case LABEL:
            return to_chars(first, last, "LABEL");
        case LICENSE:
            return to_chars(first, last, "LICENSE");
        case NAME:
            return to_chars(first, last, "NAME");
        case NMODE:
            return to_chars(first, last, "NMODE");
        case NZCROSS:
            return to_chars(first, last, "NZCROSS");
        case ODSTATE:
            return to_chars(first, last, "ODSTATE");
        case OPAR:
            return to_chars(first, last, "OPAR");
        case OUTPUTS:
            return to_chars(first, last, "OUTPUTS");
        case PARAMETER_DESCRIPTION:
            return to_chars(first, last, "PARAMETER_DESCRIPTION");
        case PARAMETER_ENCODING:
            return to_chars(first, last, "PARAMETER_ENCODING");
        case PARAMETER_NAME:
            return to_chars(first, last, "PARAMETER_NAME");
        case PARAMETER_TYPE:
            return to_chars(first, last, "PARAMETER_TYPE");
        case PARAMETER_UNIT:
            return to_chars(first, last, "PARAMETER_UNIT");
        case PARAMETER_VALUE:
            return to_chars(first, last, "PARAMETER_VALUE");
        case PARENT_BLOCK:
            return to_chars(first, last, "PARENT_BLOCK");
        case PARENT_DIAGRAM:
            return to_chars(first, last, "PARENT_DIAGRAM");
        case PATH:
            return to_chars(first, last, "PATH");
        case PORT_KIND:
            return to_chars(first, last, "PORT_KIND");
        case PORT_NUMBER:
            return to_chars(first, last, "PORT_NUMBER");
        case PORT_REFERENCE:
            return to_chars(first, last, "PORT_REFERENCE");
        case PROPERTIES:
            return to_chars(first, last, "PROPERTIES");
        case RELATED_TO:
            return to_chars(first, last, "RELATED_TO");
        case RPAR:
            return to_chars(first, last, "RPAR");
        case SIM_BLOCKTYPE:
            return to_chars(first, last, "SIM_BLOCKTYPE");
        case SIM_DEP_UT:
            return to_chars(first, last, "SIM_DEP_UT");
        case SIM_FUNCTION_API:
            return to_chars(first, last, "SIM_FUNCTION_API");
        case SIM_FUNCTION_NAME:
            return to_chars(first, last, "SIM_FUNCTION_NAME");
        case SIM_SCHEDULE:
            return to_chars(first, last, "SIM_SCHEDULE");
        case SOURCE_BLOCK:
            return to_chars(first, last, "SOURCE_BLOCK");
        case SOURCE_PORT:
            return to_chars(first, last, "SOURCE_PORT");
        case SSP_ANNOTATION:
            return to_chars(first, last, "SSP_ANNOTATION");
        case STATE:
            return to_chars(first, last, "STATE");
        case STYLE:
            return to_chars(first, last, "STYLE");
        case THICK:
            return to_chars(first, last, "THICK");
        case UID:
            return to_chars(first, last, "UID");
        case VERSION_NUMBER:
            return to_chars(first, last, "VERSION_NUMBER");
        case MAX_OBJECT_PROPERTIES: // fallthrough
        default:
            return to_chars(first, last, "");
    }
}

// helper function to render model::BaseObject kind
std::ostream& operator<<(std::ostream& os, kind_t k);
// helper function to render model properties
std::ostream& operator<<(std::ostream& os, object_properties_t p);

} /* namespace org_scilab_modules_scicos */

#endif /* LOGGERVIEW_HXX_ */
