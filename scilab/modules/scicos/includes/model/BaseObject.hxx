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

#ifndef BASEOBJECT_HXX_
#define BASEOBJECT_HXX_

#include <vector>
#include <initializer_list>

#include "utilities.hxx"

namespace org_scilab_modules_scicos
{
namespace model
{

class BaseObject
{
public:
    explicit BaseObject(kind_t k) :
        m_id(ScicosID()), m_kind(k), m_refCount()
    {
        // m_id will be set by the caller
    }
    BaseObject(const BaseObject& b) :
        m_id(b.m_id), m_kind(b.m_kind), m_refCount()
    {
    }
    BaseObject(BaseObject&& b) :
        m_id(b.m_id), m_kind(b.m_kind), m_refCount()
    {
    }
    BaseObject(ScicosID id, kind_t k) :
        m_id(id), m_kind(k), m_refCount()
    {
    }

    BaseObject& operator=(const BaseObject&) = default;

    inline BaseObject& operator=(BaseObject&& o)
    {
        m_id = o.m_id;
        m_kind = o.m_kind;
        return *this;
    }
    inline bool operator<(BaseObject o) const
    {
        return m_id < o.m_id;
    }
    inline bool operator==(BaseObject o) const
    {
        return m_id == o.m_id;
    }

    inline ScicosID id() const
    {
        return m_id;
    }
    inline void id(ScicosID _id)
    {
        m_id = _id;
    }

    inline kind_t kind() const
    {
        return m_kind;
    }

    inline unsigned& refCount()
    {
        return m_refCount;
    }

private:
    /**
     * An id is used as a reference to the current object
     */
    ScicosID m_id;

    /**
     * Kind of the Object
     */
    kind_t m_kind;

    /**
     * Refcount of this object
     */
    unsigned m_refCount;
};

/** @defgroup utilities Shared utility classes
 * @{
 */

/*
 * Represent a graphical object
 */
struct Geometry
{
    double m_x;
    double m_y;
    double m_width;
    double m_height;

    Geometry() : m_x(0), m_y(0), m_width(20), m_height(20) {};
    Geometry(const std::vector<double>& v) : m_x(v[0]), m_y(v[1]), m_width(v[2]), m_height(v[3]) {};
    Geometry(std::initializer_list<double> l) : m_x(*l.begin()), m_y(*(l.begin() + 1)), m_width(*(l.begin() + 2)), m_height(*(l.begin() + 3)) {};

    void fill(std::vector<double>& v) const
    {
        v.resize(4);
        v[0] = m_x;
        v[1] = m_y;
        v[2] = m_width;
        v[3] = m_height;
    }
    bool operator==(const Geometry& g) const
    {
        return m_x == g.m_x && m_y == g.m_y && m_width == g.m_width && m_height == g.m_height;
    }
};

struct Unit
{
    double kg;
    double m;
    double s;
    double A;
    double K;
    double mol;
    double cd;
    double rad;
    
    double factor;
    double offset;

    std::string name;
    std::string description;

    Unit() : kg(0), m(0), s(0), A(0), K(0), mol(0), cd(0), rad(0), factor(1), offset(0), name("1"), description("") {};
    

    bool operator==(const Unit& u) const
    {
        return (kg == u.kg) && 
            (m == u.m) &&
            (s == u.s) &&
            (A == u.A) &&
            (K == u.K) &&
            (mol == u.mol) &&
            (cd == u.cd) &&
            (rad == u.rad) &&
            (factor == u.factor) &&
            (offset == u.offset) &&
            (name == u.name) &&
            (description == u.description);
    }
    
    bool operator<(const Unit& u) const
    {
        if (kg < u.kg)
            return true;
        if (kg > u.kg)
            return false;

        if (m < u.m)
            return true;
        if (m > u.m)
            return false;

        if (s < u.s)
            return true;
        if (s > u.s)
            return false;

        if (A < u.A)
            return true;
        if (A > u.A)
            return false;

        if (K < u.K)
            return true;
        if (K > u.K)
            return false;

        if (mol < u.mol)
            return true;
        if (mol > u.mol)
            return false;

        if (cd < u.cd)
            return true;
        if (cd > u.cd)
            return false;

        if (rad < u.rad)
            return true;
        if (rad > u.rad)
            return false;

        if (factor < u.factor)
            return true;
        if (factor > u.factor)
            return false;

        if (offset < u.offset)
            return true;
        if (offset > u.offset)
            return false;

        if (name < u.name)
            return true;
        if (name > u.name)
            return false;

        return description < u.description;
    };
};


/**
 * Per port type descriptor
 *
 * FIXME: should reuse Scilab datatypes descriptors
 */
struct Datatype
{
public:
    Datatype() :
        m_refCount(0), m_datatype_id(0), m_rows(0), m_columns(0), m_unit() {};
    Datatype(const Datatype& d) :
        m_refCount(0), m_datatype_id(d.m_datatype_id), m_rows(d.m_rows), m_columns(d.m_columns), m_unit(d.m_unit) {};
    Datatype(const std::vector<int>& v) :
        m_refCount(0), m_datatype_id(v[2]), m_rows(v[0]), m_columns(v[1]), m_unit() {};

    // reference counter for the flyweight pattern
    int m_refCount;

    int m_datatype_id;
    int m_rows;
    int m_columns;

    Unit m_unit;

    bool operator==(const Datatype& d) const
    {
        return (m_datatype_id == d.m_datatype_id) && 
            (m_rows == d.m_rows) &&
            (m_columns == d.m_columns) &&
            (m_unit == d.m_unit);
    }

    bool operator<(const Datatype& d) const
    {
        if (m_datatype_id < d.m_datatype_id)
            return true;
        if (m_datatype_id > d.m_datatype_id)
            return false;

        if (m_rows < d.m_rows)
            return true;
        if (m_rows > d.m_rows)
            return false;

        if (m_columns < d.m_columns)
            return true;
        if (m_columns > d.m_columns)
            return false;
        
        return m_unit < d.m_unit;
    }
};

/** @}*/

} /* namespace model */
} /* namespace org_scilab_modules_scicos */

#endif /* BASEOBJECT_HXX_ */
