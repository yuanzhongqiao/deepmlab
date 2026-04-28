/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
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

package org.scilab.modules.jvm;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Paths;

public class ScilabClassLoader extends URLClassLoader {

	/**
	 * Constructor with one parameter of {@link ClassLoader} type
	 * Needed to be able to pass this class as parameter to the JVM (-Djava.class.loader=...)
	 * @param parent parent class loader
	 */
	public ScilabClassLoader(ClassLoader parent) {
		super(new URL[0], parent);
	}
	
	/**
	 * Give access to protected {@link URLClassLoader#addURL(URL)}
	 * This avoid to use reflection in {@link ClassPath#addURL(URL, int)}
	 */
	public void addURL(URL url) {
        super.addURL(url);
    }

	/**
	 * Method used to load a class
	 * @param name the name of the class to be loaded
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Class loadClass(String name) throws ClassNotFoundException {
		return super.loadClass(name);
	}

    /**
     * Called by the JVM to support dynamic additions to the class path.
     * Needed when debugging Javasci applications using Eclipse for example.
     */
    final void appendToClassPathForInstrumentation(String jar) {
        try {
            super.addURL(Paths.get(jar).toUri().toURL());
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }
}
