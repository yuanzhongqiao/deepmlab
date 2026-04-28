/*
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 * This file is released under the 3-clause BSD license. See COPYING-BSD.
 *
 */

import org.scilab.modules.javasci.Scilab;
import org.scilab.modules.types.ScilabType;
import org.scilab.modules.types.ScilabDouble;

class Example2 {
	public static void main(String[] args) {
		Scilab scilab = null;

		try {
			/* reopen several times */
			scilab = new Scilab();
			scilab.open();
			Thread.sleep(1000);
			scilab.close();

			Thread.sleep(1000);
			
			scilab.open();
			Thread.sleep(1000);
			scilab.close();

			Thread.sleep(1000);
			
			scilab.open();
			Thread.sleep(1000);
			scilab.close();

			
			System.err.println("===== ALL DONE =====");
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
}

