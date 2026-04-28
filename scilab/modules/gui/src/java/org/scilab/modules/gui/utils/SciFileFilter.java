/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2007 - INRIA - Vincent Couvert
 * Copyright (C) 2010 - DIGITEO - Allan CORNET
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

package org.scilab.modules.gui.utils;

import java.io.File;
import javax.swing.filechooser.FileFilter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.scilab.modules.gui.filechooser.FileChooserInfos;
import org.scilab.modules.localization.Messages;

/**
 * Generic file filter used for Scilab file selection GUIs
 * @author Vincent COUVERT
 * @author Sylvestre KOUMAR
 * @author Allan CORNET
 */
public class SciFileFilter extends FileFilter {

    private String mask;
    private String description;
    private int filterIndex;
    private String[] extensions;
    //private int lastFilterIndex;

    /**
     * Constructor
     * @param fileMask the file mask to apply
     * @param maskdescription description of each mask
     * @param filterIndex index the mask from the mask matrix
     */
    public SciFileFilter(String fileMask, String maskdescription, int filterIndex) {

        if (maskdescription == null) {

            if (fileMask.equals("*.sci")) {
                extensions = new String[]{"sci"};
                description = Messages.gettext("Scilab SCI files") + "(*.sci)";
            } else if (fileMask.equals("*.sce")) {
                extensions = new String[]{"sce"};
                description = Messages.gettext("Scilab SCE files") + "(*.sce)";
            } else if (fileMask.equals("*.bin")) {
                extensions = new String[]{"bin"};
                description = Messages.gettext("Scilab binary files") + "(*.bin)";
            } else if (fileMask.equals("*.sc*")) {
                extensions = new String[]{"sci","sce"};
                description = Messages.gettext("All Scilab files") + "(*.sc*)";
            } else if (fileMask.equals("*.ssp")) {
                extensions = new String[]{"ssp"};
                description = Messages.gettext("Xcos files") + "(*.ssp)";
            } else if (fileMask.equals("*.zcos")) {
                extensions = new String[]{"zcos"};
                description = Messages.gettext("Xcos files") + "(*.zcos)";
            } else if (fileMask.equals("*.xcos")) {
                extensions = new String[]{"xcos"};
                description = Messages.gettext("Xcos files") + "(*.xcos)";
            } else if (fileMask.equals("*.cos*")) {
                extensions = new String[]{"cosf"};
                description = Messages.gettext("Scicos files") + "(*.cos*)";
            } else if (fileMask.equals("*.tst")) {
                extensions = new String[]{"tst"};
                description = Messages.gettext("Test files") + "(*.tst)";
            } else if (fileMask.equals("*.start")) {
                extensions = new String[]{"start"};
                description = Messages.gettext("Scilab Start files") + "(*.start)";
            } else if (fileMask.equals("*.quit")) {
                extensions = new String[]{"quit"};
                description = Messages.gettext("Scilab Quit files") + "(*.quit)";
            } else if (fileMask.equals("*.dem")) {
                extensions = new String[]{"dem"};
                description = Messages.gettext("Scilab Demo files") + "(*.dem)";
            } else if (fileMask.equals("all")) {
                extensions = new String[]{"sci","sce","tst","start","quit","dem"};
                description = Messages.gettext("All Scilab files") + "(*.sci,*.sce,*.tst,*.start,*.quit,*.dem)";
            } else if (fileMask.equals("*.pdf")) {
                extensions = new String[]{"pdf"};
                description = Messages.gettext("All PDF files") +  "(*.pdf)";
            } else if (fileMask.equals("*.ps")) {
                extensions = new String[]{"ps"};
                description = Messages.gettext("All Postscript files") +  "(*.ps)";
            } else if (fileMask.equals("*.eps")) {
                extensions = new String[]{"eps"};
                description = Messages.gettext("All Encapsulated PS files") +  "(*.eps)";
            } else if (fileMask.equals("*.png")) {
                extensions = new String[]{"png"};
                description = Messages.gettext("All PNG image files") +  "(*.png)";
            } else if (fileMask.equals("*.rtf")) {
                extensions = new String[]{"rtf"};
                description = Messages.gettext("All RTF (Rich Text Format) files") +  "(*.rtf)";
            } else if (fileMask.equals("*.html")) {
                extensions = new String[]{"html"};
                description = Messages.gettext("All HTML files") +  "(*.html)";
            } else if (fileMask.equals("*.*")) {
                extensions = new String[]{""};
                description = Messages.gettext("All files") +  "(*.*)";
            } else {
                extensions = new String[]{fileMask.substring(fileMask.lastIndexOf(".") + 1)};
                description = String.format(Messages.gettext("All %s files"), fileMask);
            }

        } else {
            //If the mask description is filled
            //we use those descriptions given by the user
            this.description = maskdescription;
            // generate a valid extension in case of a simple mask
            if (fileMask.matches("\\*\\.[a-z]+"))
            {
                this.extensions = new String[]{ fileMask.substring(2) };
            }
        }

        // Create a regexp
        if (fileMask.equals("all")) {
            fileMask = "(*.sci)|(*.sce)|(*.tst)|(*.start)|(*.quit)|(*.dem)";
        }

        mask = fileMask.replaceAll("\\.", "\\\\."); // Point is a special regexp character
        mask = mask.replaceAll("\\*", ".\\*");

        this.filterIndex = filterIndex;
    }

    /**
     * check if it is Windows
     * @return boolean true if it is Windows
     */
    private boolean isWindows() {
        return System.getProperty("os.name").toLowerCase().contains("windows");
    }

    /**
     * get file extension
     * @param file File
     * @return a string file extension with .
     */
    private String getFileExtension(File file) {
        String fileName = file.getName();
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex == -1 || dotIndex == fileName.length() - 1) {
            return new String("");
        }
        return fileName.substring(dotIndex);
    }

    public String[] getExtensions() {
        return extensions;
    }

    /**
     * Accept a file or not ?
     * @param pathname the file to test
     * @return true if the file matches the mask
     * @see java.io.FileFilter#accept(java.io.File)
     */
    public boolean accept(File pathname) {
        if (pathname.isDirectory()) {
            return true;
        }
        if (mask.equals("")) {
            // Bug 2861: have to return true for all files if no mask given
            return true;
        } else if (mask.equals(".*\\..*")) {
            int selectedIndex = this.filterIndex + 1;
            FileChooserInfos.getInstance().setFilterIndex(selectedIndex);
            // bug 7285: *.* as filter returns also files without extension
            return true;
        } else {
            int selectedIndex = this.filterIndex + 1;
            FileChooserInfos.getInstance().setFilterIndex(selectedIndex);
            /* bug 4224 */
            /* On Windows, files are not case sensitive */
            if (isWindows()) {
                Pattern patternExt = Pattern.compile(mask + "$", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher matchExt = patternExt.matcher(pathname.getName());
                return matchExt.find();
            } else {
                return pathname.getName().matches(mask + "$");
            }
        }
    }

    /**
     * Get the description of this filter
     * @return the description of this filter
     * @see javax.swing.filechooser.FileFilter#getDescription()
     */
    public String getDescription() {
        // TODO Auto-generated method stub
        return description;
    }
}
