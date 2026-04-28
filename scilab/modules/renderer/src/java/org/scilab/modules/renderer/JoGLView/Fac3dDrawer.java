package org.scilab.modules.renderer.JoGLView;

import org.scilab.forge.scirenderer.DrawingTools;
import org.scilab.forge.scirenderer.SciRendererException;
import org.scilab.forge.scirenderer.buffers.ElementsBuffer;
import org.scilab.forge.scirenderer.shapes.appearance.Appearance;
import org.scilab.forge.scirenderer.shapes.geometry.DefaultGeometry;
import org.scilab.forge.scirenderer.shapes.geometry.Geometry;
import org.scilab.forge.scirenderer.texture.AbstractTextureDataProvider;
import org.scilab.forge.scirenderer.texture.Texture;
import org.scilab.forge.scirenderer.texture.AnchorPosition;
import org.scilab.modules.graphic_objects.ObjectRemovedException;
import org.scilab.modules.graphic_objects.axes.Axes;
import org.scilab.modules.graphic_objects.surface.Fac3d;
import org.scilab.modules.graphic_objects.figure.ColorMap;
import org.scilab.modules.graphic_objects.graphicObject.GraphicObjectProperties;
import org.scilab.modules.renderer.JoGLView.util.ColorFactory;
import org.scilab.modules.renderer.JoGLView.util.OutOfMemoryException;
import org.scilab.modules.renderer.JoGLView.mark.MarkSpriteManager;
import org.scilab.modules.renderer.JoGLView.util.LightingUtils;
import org.scilab.modules.renderer.JoGLView.axes.AxesDrawer;


import java.awt.Dimension;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Stéphane Mottelet
 */
class Fac3dDrawer {
    /** Set of properties that affect the texture. */
    private static final Set<Integer> TEXTURE_PROPERTIES = new HashSet<Integer>(Arrays.asList(
                GraphicObjectProperties.__GO_DATA_MAPPING__,
                GraphicObjectProperties.__GO_CDATA_BOUNDS__,
                GraphicObjectProperties.__GO_DATA_MODEL__,
                GraphicObjectProperties.__GO_COLOR_RANGE__
            ));
    /** The parent drawer visitor. */
    private final DrawerVisitor drawerVisitor;

    /** Map of texture sorted by fac3d identifier */
    private final Map<Integer, Texture> textureMap;

    /**
     * Default constructor.
     * @param drawerVisitor the parent drawer visitor.
     */
    Fac3dDrawer(DrawerVisitor drawerVisitor) {
        this.drawerVisitor = drawerVisitor;
        textureMap = new HashMap<Integer, Texture>();
    }

    public void draw(Fac3d fac3d) throws ObjectRemovedException, OutOfMemoryException {
        if (fac3d.getVisible()) {

            DrawingTools drawingTools = drawerVisitor.getDrawingTools();
            DataManager dataManager = drawerVisitor.getDataManager();
            ColorMap colorMap = drawerVisitor.getColorMap();
            AxesDrawer axesDrawer = drawerVisitor.getAxesDrawer();
            Axes currentAxes = drawerVisitor.getAxes();
            MarkSpriteManager markManager = drawerVisitor.getMarkManager();            

            try {
                if (fac3d.getSurfaceMode()) {
                    DefaultGeometry geometry = new DefaultGeometry();
                    geometry.setVertices(dataManager.getVertexBuffer(fac3d.getIdentifier()));
                    geometry.setNormals(dataManager.getNormalBuffer(fac3d.getIdentifier()));
                    geometry.setIndices(dataManager.getIndexBuffer(fac3d.getIdentifier()));

                    geometry.setPolygonOffsetMode(true);

                    /* Front-facing triangles */
                    Appearance appearance = new Appearance();
                    appearance.setMaterial(LightingUtils.getMaterial(fac3d.getMaterial()));
                    LightingUtils.setupLights(drawingTools.getLightManager(), currentAxes);

                    if (fac3d.getColorMode() != 0) {
                        geometry.setFillDrawingMode(Geometry.FillDrawingMode.TRIANGLES);
                        /* Back-facing triangles */
                        if (fac3d.getHiddenColor() > 0) {
                            geometry.setFaceCullingMode(axesDrawer.getBackFaceCullingMode());
                            Appearance backTrianglesAppearance = new Appearance();
                            backTrianglesAppearance.setFillColor(ColorFactory.createColor(colorMap, fac3d.getHiddenColor()));
                            drawingTools.draw(geometry, backTrianglesAppearance);

                            // Now we will draw front face.
                            geometry.setFaceCullingMode(axesDrawer.getFrontFaceCullingMode());
                        } else {
                            geometry.setFaceCullingMode(Geometry.FaceCullingMode.BOTH);
                        }

                        if (fac3d.getColorFlag() == 0) {
                            appearance.setFillColor(ColorFactory.createColor(colorMap, Math.abs(fac3d.getColorMode())));
                        } else if (fac3d.getColorFlag() > 0) {
                            geometry.setTextureCoordinates(dataManager.getTextureCoordinatesBuffer(fac3d.getIdentifier()));
                            appearance.setTexture(getTexture(fac3d));
                        } else {
                            geometry.setColors(null);
                        }
                    } else {
                        geometry.setFillDrawingMode(Geometry.FillDrawingMode.NONE);
                    }

                    if ((fac3d.getColorMode() >= 0) && (fac3d.getLineThickness() > 0.0)) {
                        geometry.setLineDrawingMode(Geometry.LineDrawingMode.SEGMENTS);
                        geometry.setWireIndices(dataManager.getWireIndexBuffer(fac3d.getIdentifier()));
                        Integer lineColor = fac3d.getSelected() ? fac3d.getSelectedColor() : fac3d.getLineColor();
                        appearance.setLineColor(ColorFactory.createColor(colorMap, lineColor));
                        appearance.setLineWidth(fac3d.getLineThickness().floatValue());
                    }

                    drawingTools.draw(geometry, appearance);
                    LightingUtils.setLightingEnable(drawingTools.getLightManager(), false);
                }

                if (fac3d.getMarkMode()) {
                    Appearance appearance = null;
                    if (fac3d.getLineThickness() > 0.0) {
                        appearance = new Appearance();
                        appearance.setLineWidth(fac3d.getLineThickness().floatValue());
                    }

                    Texture texture = markManager.getMarkSprite(fac3d, colorMap, appearance);
                    ElementsBuffer positions = dataManager.getVertexBuffer(fac3d.getIdentifier());
                    drawingTools.draw(texture, AnchorPosition.CENTER, positions);
                }
            } catch (SciRendererException e) {
                System.err.println("A '" + fac3d.getType() + "' is not drawable because: '" + e.getMessage() + "'");
            }
        }
    }
    
    /**
     * Texture getter.
     *
     * This method return the texture associated with the given fac3d object.
     * If no texture is associated, a new one will be created.
     *
     * If the texture to return have no data provider a new one is created.
     *
     * @param fac3d given fac3d object.
     * @return the texture associated with the given fac3d.
     */
    private Texture getTexture(Fac3d fac3d) {
        Texture texture = textureMap.get(fac3d.getIdentifier());
        if (texture == null) {
            texture = drawerVisitor.getCanvas().getTextureManager().createTexture();
            texture.setSWrappingMode(Texture.Wrap.CLAMP);
            texture.setTWrappingMode(Texture.Wrap.CLAMP);
            texture.setMagnificationFilter(Texture.Filter.NEAREST);
            texture.setMinifyingFilter(Texture.Filter.NEAREST);
            textureMap.put(fac3d.getIdentifier(), texture);
        }
        if (texture.getDataProvider() == null) {
            texture.setDataProvider(new Fac3dColorTexture(fac3d));
        }
        return texture;
    }

    /**
     * Manage changes on the given object.
     *
     * If the given property affect the texture of a Fac3d object, the data provider will be reset.
     *
     * @param id the given object id.
     * @param property the changed property.
     */
    public void update(Integer id, int property) {
        if (TEXTURE_PROPERTIES.contains(property)) {
            Texture texture = textureMap.get(id);
            if (texture != null) {
                texture.setDataProvider(null);
            }
        }
    }

    /**
     * Update all texture.
     * Reset all texture data provider.
     * @throws ObjectRemovedException
     */
    void updateAll() throws ObjectRemovedException, OutOfMemoryException {
        for (Map.Entry<Integer, Texture> entry : textureMap.entrySet()) {
            drawerVisitor.getDataManager().updateTextureCoordinatesBuffer(entry.getKey());
            entry.getValue().setDataProvider(null);
        }
    }

    /**
     * Dispose the given object.
     * @param id given object identifier.
     */
    public void dispose(Integer id) {
        /** TODO
        Texture texture = textureMap.get(id);
        if (texture != null) {
            drawerVisitor.getCanvas().getTextureManager().release(texture);
        }
         **/
        textureMap.remove(id);
    }
    
    /**
     * This class is an implementation of {@link TextureDataProvider} that provide texture data for a given fac3d object.
     *
     * The texture is a 1D texture with:
     * - at first the minimal outside color.
     * - main colors:
     *  . If colorRange is enable, all color in the color range, in order.
     *  . If colorRange is disable, all color from the color map, in order.
     * - at last, the maximal outside color.
     *
     * The outside colors are always presents.
     *  .As user defined outside colors if any.
     *  .As minimal and maximal color from the main colors otherwise.
     */
    private class Fac3dColorTexture extends AbstractTextureDataProvider {

        /** The fac3d object for which this class provide texture data */
        private final Fac3d fac3d;

        /**
         * Default constructor.
         * @param fac3d The Fac#d object for which this class will provide texture data.
         */
        public Fac3dColorTexture(Fac3d fac3d) {
            this.fac3d = fac3d;
            this.imageType = ImageType.RGBA_BYTE;
        }

        @Override
        public Dimension getTextureSize() {
            return new Dimension(getTextureLength(), 1);
        }

        @Override
        public ByteBuffer getData() {
            ColorMap colorMap = drawerVisitor.getColorMap();
//            Integer[] outsideColor = fac3d.getOutsideColor();

            ByteBuffer buffer = ByteBuffer.allocate(4 * getTextureLength());

            int min;
            int max;
            if (useColorRange()) {
                Integer[] colorRange = fac3d.getColorRange();
                min = Math.max(1, colorRange[0]);
                max = Math.min(colorMap.getSize(), colorRange[1]);
            } else {
                min = 1;
                max = colorMap.getSize();
            }

            // if (outsideColor[0] == 0) {
                buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, min)));
            // } else if (outsideColor[0] > 0) {
            //     buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, outsideColor[0])));
            // } else {
            //     // TODO: transparency.
            //     buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, -2)));
            // }

            for (int i = min; i <= max; i++) {
                buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, i)));
            }

            // if (outsideColor[1] == 0) {
                buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, max)));
            // } else if (outsideColor[1] > 0) {
            //     buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, outsideColor[1])));
            // } else {
            //     // TODO: transparency.
            //     buffer.put(toByte(ColorFactory.createRGBAColor(colorMap, -2)));
            // }

            buffer.rewind();
            return buffer;
        }

        @Override
        public ByteBuffer getSubData(int x, int y, int width, int height) {
            ByteBuffer buffer = getData();
            ByteBuffer tempBuffer = ByteBuffer.allocate(4 * width * height);
            buffer.position(x + y * getTextureLength());
            byte[] data = new byte[4];
            for (int i = x; i < x + width; i++) {
                for (int j = y; j < y + height; j++) {
                    buffer.get(data);
                    tempBuffer.put(data);
                }
            }
            tempBuffer.rewind();
            buffer.rewind();
            return tempBuffer;
        }

        @Override
        public boolean isValid() {
            return true;
        }

        /**
         * Check if color range option is enable.
         * @return true if the color range is valid and not [0, 0].
         */
        private boolean useColorRange() {
            Integer[] colorRange = fac3d.getColorRange();
            return (colorRange != null) && (colorRange.length == 2) && ((colorRange[0] != 0) || (colorRange[1] != 0));
        }

        /**
         * Compute the texture length.
         * @return the texture length.
         */
        private int getTextureLength() {
            ColorMap colorMap = drawerVisitor.getColorMap();
            int length;
            if (useColorRange()) {
                Integer[] colorRange = fac3d.getColorRange();
                int min = Math.max(1, colorRange[0]);
                int max = Math.min(colorMap.getSize(), colorRange[1]);
                length = 1 + max - min;
            } else {
                length = colorMap.getSize();
            }

            // For outside colors.
            length += 2;
            return length;
        }
    }
}

