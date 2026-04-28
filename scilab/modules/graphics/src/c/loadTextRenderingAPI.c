/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2009 - DIGITEO - Sylvestre Ledru
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2024 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
#include "loadTextRenderingAPI.h"
#include "BOOL.h"
#include "loadOnUseClassPath.h"
#include "string.h"


/* Variable to store if you have already loaded or not the Latex
 * dependencies */
static BOOL loadedDepLatex = FALSE;
/* Variable to store if you have already loaded or not the MathML
 * dependencies */
static BOOL loadedDepMathML = FALSE;

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

void loadTextRenderingAPI(char** text, char** interpreter, int nbText, int nbInter)
{

    int i = 0;
    BOOL bAuto;
    BOOL bForced;
    /* We already loaded both, don't need to check again */
    if (loadedDepLatex && loadedDepMathML)
    {
        return;
    }


    /* For each element in the array, look if the text starts and ends by:
     * '$' for latex
     * '<' and '>' respectivelyfor MathML
     */
    for (i = 0 ; i < nbText ; i++)
    {
        bAuto = interpreter == NULL || strcmp(interpreter[MIN(i,nbInter-1)],"auto") == 0;
        bForced  = !bAuto && strcmp(interpreter[MIN(i,nbInter-1)],"latex") == 0;
        if ( !loadedDepLatex && ( (text[i][0] == '$' && text[i][strlen(text[i])-1] == '$' && bAuto) ||  bForced))
        /* One of the string starts by a $. This might be a Latex expression */
        {
            loadOnUseClassPath("graphics_latex_textrendering");
            loadedDepLatex = TRUE;
        }
        bForced  = !bAuto && strcmp(interpreter[MIN(i,nbInter-1)],"mathml") == 0;
        if (!loadedDepMathML && ( (text[i][0] == '<' && text[i][strlen(text[i])-1] == '>' && bAuto) || bForced))
        /* One of the string starts by a <. This might be a MathML expression */
        {
            loadOnUseClassPath("graphics_mathml_textrendering");
            loadedDepMathML = TRUE;
        }
    }

}
