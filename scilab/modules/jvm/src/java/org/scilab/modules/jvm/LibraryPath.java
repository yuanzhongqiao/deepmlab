/*--------------------------------------------------------------------------*/
/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) INRIA - Allan CORNET
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

/*--------------------------------------------------------------------------*/
package org.scilab.modules.jvm;

import java.io.File;
import java.io.IOException;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.VarHandle;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;

import jdk.internal.loader.NativeLibraries;

/**
 * LibraryPath to overload java.library.path.
 */
public class LibraryPath {

    private static final String JAVALIBRARYPATH = "java.library.path";
    /**
     * Constructor
     */
    protected LibraryPath() {
        /*  indicate that the requested operation is not supported */
        throw new UnsupportedOperationException();
    }
    /*--------------------------------------------------------------------------*/
    /**
     * checks if pathToAdd already exists
     * @param currentpaths list of current paths
     * @param pathToAdd path to add
     * @return a boolean true if path already exists
     */
    private static boolean pathAlreadyExists(String currentpaths, String pathToAdd) {
        String[] paths = currentpaths.split("" + File.pathSeparatorChar);
        for (String libraryPath : paths) {
            if (libraryPath.equalsIgnoreCase(pathToAdd)) {
                return true;
            }
        }
        return false;
    }
    /*--------------------------------------------------------------------------*/
    /**
     * add a path to java.library.path
     * @param p path to add
     * @throws IOException return a exception
     */
    public static void addPath(final String p) throws IOException {
        if (!pathAlreadyExists(System.getProperty(JAVALIBRARYPATH), p)) {
            /* The order matter here... see bug #4022 */
            String newLibPath = System.getProperty(JAVALIBRARYPATH) + File.pathSeparator + p;
            System.setProperty(JAVALIBRARYPATH, newLibPath);
            try {
            	/* Enable modifications on USER_PATHS field in LibraryPaths class */
            	final Class<?>[] declClassArr = NativeLibraries.class.getDeclaredClasses();
            	final Class<?> libraryPaths = Arrays.stream(declClassArr).filter(klass -> klass.getSimpleName().equals("LibraryPaths")).findFirst().get();
            	final Field field = libraryPaths.getDeclaredField("USER_PATHS");
            	final MethodHandles.Lookup lookup = MethodHandles.privateLookupIn(Field.class, MethodHandles.lookup());
            	final VarHandle varHandle = lookup.findVarHandle(Field.class, "modifiers", int.class);
            	varHandle.set(field, field.getModifiers() & ~Modifier.FINAL);
            	field.setAccessible(true);
            	
            	/* Update field by adding new path to current value */
            	String[] paths = (String[])field.get(null);
                String[] newPaths = new String[paths.length+1];
                System.arraycopy(paths, 0, newPaths, 0, paths.length);
                newPaths[paths.length] = p;
                field.set(null, newPaths);
                
            } catch (NoSuchFieldException e) {
        		throw new IOException("Error NoSuchFieldException, could not add path to " + JAVALIBRARYPATH);
            } catch (IllegalAccessException e) {
                throw new IOException("Error IllegalAccessException, could not add path to " + JAVALIBRARYPATH);
            }
        }
    }

    /*--------------------------------------------------------------------------*/
    /**
     * get the scilab java.library.path.
     * @return librarypath
     */
    public static String[] getLibraryPath() {
        String librarypath = System.getProperty(JAVALIBRARYPATH);
        String[] paths = librarypath.split("" + File.pathSeparatorChar);
        return paths;
    }
}
/*--------------------------------------------------------------------------*/
