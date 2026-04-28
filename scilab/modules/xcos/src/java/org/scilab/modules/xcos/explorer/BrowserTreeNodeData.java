/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2014 - Scilab Enterprises - Clement DAVID
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

package org.scilab.modules.xcos.explorer;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;

import javax.swing.text.BadLocationException;
import javax.swing.text.Element;
import javax.swing.text.html.HTMLDocument;

import org.scilab.modules.xcos.Controller;
import org.scilab.modules.xcos.JavaController;
import org.scilab.modules.xcos.Kind;
import org.scilab.modules.xcos.ObjectProperties;
import org.scilab.modules.xcos.VectorOfDouble;
import org.scilab.modules.xcos.VectorOfString;

public class BrowserTreeNodeData {
    private static final NumberFormat CURRENT_FORMAT = NumberFormat.getNumberInstance(Locale.ENGLISH);

    private final long uid;
    private final Kind kind;
    private int refCount;

    public BrowserTreeNodeData() {
        // root TreeNode, set a default value but kind should not be used
        this.uid = 0l;
        kind = Kind.DIAGRAM;
    }

    public BrowserTreeNodeData(long id, Kind kind) {
        this.uid = id;
        this.kind = kind;
        refCount = 0;
    }

    /*
     * Getters and Setters
     */

    /**
     * @return the id
     */
    public long getId() {
        return uid;
    }

    /**
     * @return the kind
     */
    public Kind getKind() {
        return kind;
    }

    /**
     * @return the decremented reference counter
     */
    public int decRefCount() {
        return --refCount;
    }

    /**
     * @return the incremented reference counter
     */
    public int incRefCount() {
        return ++refCount;
    }

    /**
     * Compute and fill in the HTML data for node's parameters
     *
     * @param document
     *            the currently rendered document
     * @throws IOException
     * @throws BadLocationException
     */

    public void fillOrUpdateContent(HTMLDocument document) throws BadLocationException, IOException {
        final Element html = document.getDefaultRootElement();
        final Element body = html.getElement(html.getElementCount() - 1);

        if (uid == 0) {
            // the root element is selected on delete, the rendering cleanup all content
            document.setOuterHTML(body, "<body />");
            return;
        }

        final StringBuilder str = new StringBuilder();
        final Controller controller = new Controller();
        switch (kind) {
            case ANNOTATION:
                htmlAnnotation(str, controller);
                break;
            case BLOCK:
                htmlBlock(str, controller);
                break;
            case DIAGRAM:
                htmlDiagram(str, controller);
                break;
            case LINK:
                htmlLink(str, controller);
                break;
            default:
                break;
        }
        document.setInnerHTML(body, str.toString());
    }

    private void htmlAnnotation(final StringBuilder str, final Controller controller) {
        tag(str, "h1", "Annotation");
        
        String[] description = new String[1];
        controller.getObjectProperty(uid, kind, ObjectProperties.DESCRIPTION, description);
        tag(str, "code", description[0]);
    }

    private void htmlBlock(final StringBuilder str, final Controller controller) {
        String[] style = new String[1];
        controller.getObjectProperty(uid, kind, ObjectProperties.STYLE, style);
        VectorOfString exprs = new VectorOfString();
        controller.getObjectProperty(uid, kind, ObjectProperties.EXPRS, exprs);
        VectorOfDouble geom = new VectorOfDouble(4);
        controller.getObjectProperty(uid, kind, ObjectProperties.GEOMETRY, geom);
        String interf[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.INTERFACE_FUNCTION, interf);
        String title[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.NAME, title);
        String uuid[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.UID, uuid);

        tag(str, "h1", "Block " + interf[0] + " : " + title[0]);
        
        /*
         * Extract documentation information
         */
        
        String[] description = new String[1];
        controller.getObjectProperty(uid, kind, ObjectProperties.DESCRIPTION, description);
        tag(str, "code", description[0]);

        long[] labelID = { 0 };
        controller.getObjectProperty(uid, kind, ObjectProperties.LABEL, labelID);
        controller.getObjectProperty(labelID[0], Kind.ANNOTATION, ObjectProperties.DESCRIPTION, description);
        if (labelID[0] != 0 && description[0] != "") {
            tag(str, "strong", "Label");
            tag(str, "p", description[0]);
        }

        /*
         * Render some graphics elements
         */
        StringBuilder htmlTable = new StringBuilder();
        tag(htmlTable, "caption", "Graphics");
        tag(htmlTable, "tr", tag("td", "orig").append(tag("td", escapeVector(',', geom.get(0), geom.get(1)))));
        tag(htmlTable, "tr", tag("td", "sz").append(tag("td", escapeVector(',', geom.get(2), geom.get(3)))));
        tag(htmlTable, "tr", tag("td", "exprs").append(tag("td", escapeVector(';', exprs))));
        tag(htmlTable, "tr", tag("td", "id").append(tag("td", title[0])));
        tag(htmlTable, "tr", tag("td", "style").append(tag("td", style[0])));

        tag(str, "table", htmlTable);

        /*
         * Render some model elements
         */
        htmlTable = new StringBuilder();
        tag(htmlTable, "caption", "Model");
        tag(htmlTable, "tr", tag("td", "UID").append(tag("td", uuid[0])));

        tag(str, "table", htmlTable);
    }

    private void htmlDiagram(final StringBuilder str, final Controller controller) {
        String title[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.NAME, title);
        String version[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.VERSION_NUMBER, version);
        String path[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.PATH, path);
        String context[] = { "" };
        controller.getObjectProperty(uid, kind, ObjectProperties.DIAGRAM_CONTEXT, context);

        tag(str, "h1", "Diagram: " + title[0]);

        StringBuilder htmlList = new StringBuilder();
        tag(htmlList, "li", "Version: " + version[0]);
        tag(htmlList, "li", "File: " + path[0]);

        tag(str, "div", tag("ul", htmlList));
        tag(str, "div", tag("p", context[0]));
    }

    private void htmlLink(final StringBuilder str, final Controller controller) {
        tag(str, "h1", "Link");
        
        /*
         * Extract documentation information
         */
        
        String[] description = new String[1];
        controller.getObjectProperty(uid, kind, ObjectProperties.DESCRIPTION, description);
        tag(str, "code", description[0]);

        long[] labelID = { 0 };
        controller.getObjectProperty(uid, kind, ObjectProperties.LABEL, labelID);
        controller.getObjectProperty(labelID[0], Kind.ANNOTATION, ObjectProperties.DESCRIPTION, description);
        if (labelID[0] != 0 && description[0] != "") {
            tag(str, "strong", "Label");
            tag(str, "p", description[0]);
        }
    }

    private static StringBuilder tag(StringBuilder str, String tag, CharSequence content) {
        str.append("<").append(tag).append(">");
        str.append(content);
        str.append("</").append(tag).append(">");
        return str;
    }

    private static StringBuilder tag(String tag, CharSequence content) {
        return tag(new StringBuilder(), tag, content);
    }

    private static CharSequence escapeVector(char sep, double... v) {
        StringBuilder str = new StringBuilder();
        if (v.length > 1) {
            str.append('[');
        }

        for (int i = 0; i < v.length - 1; i++) {
            str.append(CURRENT_FORMAT.format(v[i]));
            str.append(sep);
        }
        if (v.length > 0) {
            str.append(CURRENT_FORMAT.format(v[v.length - 1]));
        }

        if (v.length > 1) {
            str.append(']');
        }
        return str;
    }

    private static CharSequence escapeVector(char sep, String... v) {
        StringBuilder str = new StringBuilder();
        if (v.length > 1) {
            str.append('[');
        }

        for (int i = 0; i < v.length - 1; i++) {
            str.append('"').append(v[i]).append('"');
            str.append(sep);
        }
        if (v.length > 0) {
            str.append('"').append(v[v.length - 1]).append('"');
        }

        if (v.length > 1) {
            str.append(']');
        }
        return str;
    }

    private static CharSequence escapeVector(char sep, VectorOfString v) {
        final int length = v.size();

        StringBuilder str = new StringBuilder();
        if (length > 1) {
            str.append('[');
        }

        for (int i = 0; i < length - 1; i++) {
            str.append('"').append(v.get(i)).append('"');
            str.append(sep);
        }
        if (length > 0) {
            str.append('"').append(v.get(length - 1)).append('"');
        }

        if (length > 1) {
            str.append(']');
        }
        return str;
    }

    /*
     * Utilities
     */
    @Override
    public String toString() {
        if (uid == 0) {
            // root TreeNode
            return "Root";
        }

        String str = "";
        boolean status;
        String[] interf = { "" };
        String[] name = { "" };
        final boolean ALWAYS_DISPLAY_ID = true;
        JavaController controller = new JavaController();
        switch (kind) {
            case ANNOTATION:
                status = controller.getObjectProperty(uid, kind, ObjectProperties.NAME, name);
                if (!status || name[0].isEmpty()) {
                    return "Annotation" + " : " + uid;
                }
                str = "Annotation " + name[0];
                break;
            case BLOCK:
                status = controller.getObjectProperty(uid, kind, ObjectProperties.INTERFACE_FUNCTION, interf);
                if (!status || interf[0].isEmpty()) {
                    return "Block" + " : " + uid;
                }
                status = controller.getObjectProperty(uid, kind, ObjectProperties.NAME, name);
                if (!status || name[0].isEmpty()) {
                    str = "Block " + interf[0];
                    break;
                }
                str = "Block " + interf[0] + " \"" + name[0] + "\"";
                break;
            case DIAGRAM: {
                status = controller.getObjectProperty(uid, kind, ObjectProperties.NAME, name);
                if (!status || name[0].isEmpty()) {
                    return "Diagram" + " : " + uid;
                }
                str = "Diagram " + name[0];
                break;
            }
            case LINK:
                status = controller.getObjectProperty(uid, kind, ObjectProperties.NAME, name);
                if (!status || name[0].isEmpty()) {
                    return "Link" + " : " + uid;
                }
                str = "Link " + name[0];
                break;
            case PORT:
                status = controller.getObjectProperty(uid, kind, ObjectProperties.NAME, name);
                if (!status || name[0].isEmpty()) {
                    return "Port" + " : " + uid;
                }
                str = "Port " + name[0];
                break;
        }

        if (ALWAYS_DISPLAY_ID) {
            str = str + " : " + uid;
        }

        return str;
    }

    /*
     * (non-Javadoc)
     *
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + (int) (uid ^ (uid >>> 32));
        return result;
    }

    /*
     * (non-Javadoc)
     *
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        BrowserTreeNodeData other = (BrowserTreeNodeData) obj;
        if (uid != other.uid) {
            return false;
        }
        return true;
    }
}
