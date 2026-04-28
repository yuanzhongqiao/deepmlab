/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2010 - Calixte DENIZET
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2022 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

package org.scilab.modules.scinotes.actions;

import java.awt.Cursor;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.File;

import javax.swing.JFileChooser;
import javax.swing.KeyStroke;

import org.scilab.modules.gui.filechooser.Juigetfile;
import org.scilab.modules.gui.filechooser.FileChooser;
import org.scilab.modules.gui.filechooser.ScilabFileChooser;
import org.scilab.modules.gui.menuitem.MenuItem;
import org.scilab.modules.gui.messagebox.ScilabModalDialog;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.AnswerOption;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.ButtonType;
import org.scilab.modules.gui.messagebox.ScilabModalDialog.IconType;
import org.scilab.modules.gui.utils.ConfigManager;
import org.scilab.modules.gui.utils.SciFileFilter;
import org.scilab.modules.jvm.LoadClassPath;
import org.scilab.modules.localization.Messages;
import org.scilab.modules.scinotes.SciNotes;
import org.scilab.modules.scinotes.ScilabDocument;
import org.scilab.modules.scinotes.utils.CodeExporter;
import org.scilab.modules.scinotes.utils.SciNotesMessages;

/**
 * Class Export action for SciNotes
 * @author Calixte DENIZET, Stéphane MOTTELET
 */
public class ExportAction extends DefaultAction {

    private static final long serialVersionUID = 7796680521955058413L;

    private static final String DOT = ".";

    private boolean codeConverterLoaded;
    private File currentFile;

    /**
     * Default constructor
     * @param name the name of the action
     * @param editor the editor
     */
    public ExportAction(String name, SciNotes editor) {
        super(name, editor);
    }

    /**
     * Function doAction
     */
    public void doAction() {
        String extension = null;
        String title = "Export";
        String path = null;

        String initialDirectoryPath = path;
        if (initialDirectoryPath == null) {
            initialDirectoryPath = getEditor().getTextPane().getName();
        }
        if (initialDirectoryPath == null) {
            initialDirectoryPath =  ConfigManager.getLastOpenedDirectory();
        }

        FileChooser sfc = ScilabFileChooser.createFileChooser();
        sfc.setUiDialogType(Juigetfile.SAVE_DIALOG);
        sfc.setInitialDirectory(initialDirectoryPath);
        sfc.setTitle(Messages.gettext(title));

        String[] mask={"*.html","*.pdf","*.ps","*.eps","*.rtf"};
        sfc.addMask(mask,null);

        String name = getEditor().getTextPane().getName();

        if (name == null) {
            name = ((ScilabDocument) getEditor().getTextPane().getDocument()).getFirstFunctionName();
            if (name == null) {
                name = "";
            }
        }

        name = (new File(name)).getName();
        if (name.lastIndexOf('.') > 0) {
            name = name.substring(0, name.lastIndexOf('.'));            
        }
        sfc.setInitialFileName(name);

        sfc.displayAndWait();

        String[] selection = sfc.getSelection();
        if (selection.length>0 && selection[0] != "") {
            File f = new File(selection[0]);            
            String fileName = f.getAbsolutePath();
            String type = null;
            int index = fileName.lastIndexOf('.');
            if(index > 0) {
                extension = fileName.substring(index+1);
            }

            if (extension.equalsIgnoreCase("html")) {
                type = "text/html";
            } else if (extension.equalsIgnoreCase("pdf")) {
                type = CodeExporter.PDF;
            } else if (extension.equalsIgnoreCase("ps")) {
                type = CodeExporter.PS;
            } else if (extension.equalsIgnoreCase("eps")) {
                type = CodeExporter.EPS;
            } else if (extension.equalsIgnoreCase("rtf")) {
                type = CodeExporter.RTF;
            }

            if (!codeConverterLoaded) {
                LoadClassPath.loadOnUse("copyAsHTMLinScinotes");
                LoadClassPath.loadOnUse("pdf_ps_eps_graphic_export");
                codeConverterLoaded = true;
            }

            if (fileName != null && type != null) {
                getEditor().getTextPane().setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
                CodeExporter.convert(getEditor().getTextPane(), fileName, type, PageSetupAction.getPageFormat());
                getEditor().getTextPane().setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
            }
        }
    }

    /**
     * Create the MenuItem for print action
     * @param label label of the menu
     * @param editor Editor
     * @param key KeyStroke
     * @return a MenuItem
     */
    public static MenuItem createMenu(String label, SciNotes editor, KeyStroke key) {
        return createMenu(label, null, new ExportAction(label, editor), key);
    }
}
