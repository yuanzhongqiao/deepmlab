// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// Since https://bugs.openjdk.org/browse/JDK-8204187,
// exporting JPG images to clipboard with Alpha channel is no more supported (at least under Windows)
// This generates a warning/error message but the image is still exported to clipboard
// See also https://bugs.openjdk.org/browse/JDK-8204188
// <-- NO CHECK ERROR OUTPUT -->

// <-- Non-regression test for bug 1944 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1944
//
// <-- Short Description -->
// Y ticks labels are displaced when the graphic window is copied
// in the clipboard as bitmap

plot(1:10);
plot(0:9);
fig = gcf();
// export to bitmap and check the result
clipboard(fig.figure_id, "EMF");

