/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

package org.scilab.modules.gui.utils;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.scilab.modules.commons.OS;
import org.scilab.modules.commons.ScilabCommons;
import org.scilab.modules.commons.ScilabConstants;

import org.cef.CefApp;
import org.cef.CefClient;
import org.cef.CefSettings;
import org.cef.CefApp.CefAppState;

public final class ScilabBrowser {

    private static CefApp cefApp_;
    /**
     * Constructor
     */
    private ScilabBrowser() { }

    private static void init() {
        if (cefApp_ == null || CefApp.getState() == CefAppState.TERMINATED) {
            CefSettings settings = new CefSettings();
            settings.windowless_rendering_enabled = false;
            settings.log_severity = CefSettings.LogSeverity.LOGSEVERITY_DISABLE;
            List<String> cefArgs = new ArrayList<>();
            if (OS.get() == OS.MAC) {
                // Development version: JCEF is in SCI/lib/thirdparty/jcef/
                // Packaged version:  JCEF is in SCI/../../lib/thirdparty/jcef/
                String pathPrefix = ""; // Development version
                if (new File(ScilabConstants.SCI.getPath() + "/lib/thirdparty/jcef/Chromium Embedded Framework.framework").exists() == false) {
                    pathPrefix = "/../.."; // Packaged version
                }
                cefArgs.add(0, "--framework-dir-path=" + ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/Chromium Embedded Framework.framework");
                cefArgs.add(0, "--main-bundle-path=" + ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/jcef Helper.app");
                cefArgs.add(0, "--browser-subprocess-path=" + ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/jcef Helper.app/Contents/MacOS/jcef Helper");
                // The following settings are mandatory for packaged version
                settings.resources_dir_path = ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/Chromium Embedded Framework.framework/Resources/";
                settings.locales_dir_path = ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/Chromium Embedded Framework.framework/Resources/";
                settings.browser_subprocess_path = ScilabConstants.SCI.getPath() + pathPrefix + "/lib/thirdparty/jcef/jcef Helper.app";
            }

            settings.cache_path = ScilabCommons.getSCIHOME() + "/jcef";
            settings.persist_session_cookies = true;

            CefApp.startup(cefArgs.toArray(new String[0]));
            cefApp_ = CefApp.getInstance(cefArgs.toArray(new String[0]), settings);


            try {
                Class scilab = ClassLoader.getSystemClassLoader().loadClass("org.scilab.modules.core.Scilab");
                Method registerFinalHook = scilab.getDeclaredMethod("registerFinalHook", Runnable.class);
                    registerFinalHook.invoke(null, new Runnable() {
                        public void run() {
                            cefApp_.dispose();
                        }
                    });
            } catch (ClassNotFoundException|
                IllegalAccessException|
                IllegalArgumentException|
                InvocationTargetException|
                NoSuchMethodException|
                SecurityException e) {
                e.printStackTrace();
            }
        }
    }

    public static CefClient get() {
        init();
        return cefApp_.createClient();
    }

    public static void release(CefClient client) {
        client.dispose();
    }

    public static String getJcefVersion() {
        init();
        return cefApp_.getVersion().getJcefVersion();
    }

    public static String getCefVersion() {
        init();
        return cefApp_.getVersion().getCefVersion();
    }

    public static String getChromeVersion() {
        init();
        return cefApp_.getVersion().getChromeVersion();
    }
}
