/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2015 - Scilab Enterprises
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

package org.scilab.modules.ui_data.newsfeed;

import java.io.File;
import java.net.URI;
import java.util.Date;

import org.scilab.modules.commons.ScilabConstants;

/**
 * News data
 */
public class News {

    private String title;
    private Date date;
    private String description;
    private String content;
    private NewsMediaContent mediaContent;
    private String link;

    public News() {
        this.title = "Discover Scilab community";
        this.date = new Date();
        
        URI uri = new File(ScilabConstants.SCI, "modules/graphics/demos/matplot/puffin.png").toURI();
        String icon = "<IMG src=\"file://"+uri.getRawPath()+"\" height=\"80\" width=\"80\" />";
        this.description = "<HTML>"
                        + "<TABLE>"
                        + "<TR valign=baseline>"
                        + "<TD>"
                        + icon
                        + "<TD>"
                        + "<P>Scilab is open source.<P>"
                        + "<P>Giving back support or use cases is appreciated.<P>"
                        + "</TABLE>"
                        + "<UL>"
                        + "<LI>Add and improve functions on <A href=\"https://gitlab.com/scilab/scilab\">GitLab</a>.</LI>"
                        + "<LI>View and edit <A href=\"https://help.scilab.org\">help pages</a>.</LI>"
                        + "<LI>Publish toolboxes on <A href=\"https://atoms.scilab.org\">ATOMS</a>.</LI>"
                        + "<LI>Post questions on <A href=\"https://scilab.discourse.group/\">Discourse</a>.</LI>"
                        + "</UL>";
        this.content = null;
        this.mediaContent = null;
        this.link = null;
    }

    public News(String title, Date date, String description, String content, NewsMediaContent mediaContent, String link) {
        this.title = title;
        this.date = date;
        this.description = description;
        this.content = content;
        this.mediaContent = mediaContent;
        this.link = link;
    }

    String getTitle() {
        return title;
    }

    Date getDate() {
        return date;
    }

    String getDescription() {
        return description;
    }

    String getContent() {
        return content;
    }

    NewsMediaContent getMediaContent() {
        return mediaContent;
    }

    String getLink() {
        return link;
    }
}
