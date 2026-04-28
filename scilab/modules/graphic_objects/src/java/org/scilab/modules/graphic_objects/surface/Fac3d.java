/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2010 - DIGITEO - Manuel JULIACHS
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2023 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

package org.scilab.modules.graphic_objects.surface;

import org.scilab.modules.graphic_objects.ObjectRemovedException;
import org.scilab.modules.graphic_objects.graphicObject.GraphicObjectProperties;
import org.scilab.modules.graphic_objects.graphicObject.Visitor;
import org.scilab.modules.graphic_objects.graphicObject.GraphicObject.UpdateStatus;

import static org.scilab.modules.graphic_objects.graphicObject.GraphicObjectProperties.*;

/**
 * Fac3d class
 * @author Manuel JULIACHS
 * @author Stéphane MOTTELET
 */
public class Fac3d extends Surface {
    /** Fac3d properties names */
    private enum Fac3dProperty { DATAMAPPING, CDATABOUNDS, COLORRANGE};

    /** Data mapping type */
    private enum DataMapping { SCALED, DIRECT;

                               /**
                                * Converts an integer to the corresponding enum
                                * @param intValue the integer value
                                * @return the data mapping enum
                                */
    public static DataMapping intToEnum(Integer intValue) {
        switch (intValue) {
            case 0:
                return DataMapping.SCALED;
            case 1:
                return DataMapping.DIRECT;
            default:
                return null;
        }
    }
                             }

    /** Specifies how colors are mapped to scalar values */
    private DataMapping dataMapping;

    /** color data bounds: 2-element array */
    private double[] cDataBounds;

    /** colormap range 2-element array */
    private int[] colorRange;

    /** Constructor */
    public Fac3d() {
        super();
        dataMapping = DataMapping.DIRECT;
        cDataBounds = new double[] {0.0, 0.0};
        colorRange = new int[] {0, 0};
    }

    @Override
    public void accept(Visitor visitor) throws ObjectRemovedException {
        visitor.visit(this);
    }

    /**
     * Returns the enum associated to a property name
     * @param propertyName the property name
     * @return the property enum
     */
    public Object getPropertyFromName(int propertyName) {
        switch (propertyName) {
            case __GO_DATA_MAPPING__ :
                return  Fac3dProperty.DATAMAPPING;
            case __GO_CDATA_BOUNDS__ :
                return Fac3dProperty.CDATABOUNDS;
            case __GO_COLOR_RANGE__ :
                return Fac3dProperty.COLORRANGE;
            default :
                return super.getPropertyFromName(propertyName);
        }
    }

    /**
     * Fast property get method
     * @param property the property to get
     * @return the property value
     */
    
    public Object getProperty(Object property) {
        if (property instanceof Fac3dProperty) {
            Fac3dProperty sp = (Fac3dProperty)property;
            switch (sp) {
                case DATAMAPPING:
                    return getDataMapping();
                case CDATABOUNDS:
                    return getCDataBounds();
                case COLORRANGE:
                    return getColorRange(); 
            }
        }
        return super.getProperty(property);
    }
    

    /**
     * Fast property set method
     * @param property the property to set
     * @param value the property value
     * @return true if the property has been set, false otherwise
     */
    public UpdateStatus setProperty(Object property, Object value) {
        if (property instanceof Fac3dProperty) {
            Fac3dProperty sp = (Fac3dProperty)property;
            switch (sp) {
                case DATAMAPPING:
                    setDataMapping((Integer) value);
                    break;
                case CDATABOUNDS:
                    setCDataBounds((Double[]) value);
                    break;
                case COLORRANGE:
                    setColorRange((Integer[]) value);
                    break;
            }
        } else {
            return super.setProperty(property, value);
        }
        return UpdateStatus.Success;
    }
    
    /**
     * @return the dataMapping
     */
    public Integer getDataMapping() {
        return getDataMappingAsEnum().ordinal();
    }

    /**
     * @return the dataMapping
     */
    public DataMapping getDataMappingAsEnum() {
        return dataMapping;
    }

    /**
     * @param dataMapping the dataMapping to set
     */
    public UpdateStatus setDataMapping(Integer dataMapping) {
        setDataMappingAsEnum(DataMapping.intToEnum(dataMapping));
        return UpdateStatus.Success;
    }

    /**
     * @param dataMapping the dataMapping to set
     */
    public UpdateStatus setDataMappingAsEnum(DataMapping dataMapping) {
        this.dataMapping = dataMapping;
        return UpdateStatus.Success;
    }

    /**
     * @return the colorRange
     */
    public Integer[] getColorRange() {
        Integer[] retColorRange = new Integer[2];
        retColorRange[0] = colorRange[0];
        retColorRange[1] = colorRange[1];

        return retColorRange;
    }

    /**
     * @param colorRange the colorRange to set
     */
    public UpdateStatus setColorRange(Integer[] colorRange) {
        this.colorRange[0] = colorRange[0];
        this.colorRange[1] = colorRange[1];
        return UpdateStatus.Success;
    }
    /**
     * @return the colorBound
     */
    public Double[] getCDataBounds() {
        Double[] retCDataBounds = new Double[2];
        retCDataBounds[0] = cDataBounds[0];
        retCDataBounds[1] = cDataBounds[1];

        return retCDataBounds;
    }

    /**
     * @param bounds the cDataBounds to set
     */
    public UpdateStatus setCDataBounds(Double[] cDataBounds) {
        this.cDataBounds[0] = cDataBounds[0];
        this.cDataBounds[1] = cDataBounds[1];
        return UpdateStatus.Success;
    }

    /**
     * @return Type as String
     */
    public Integer getType() {
        return GraphicObjectProperties.__GO_FAC3D__;
    }

}
