Welcome to Scilab 2026.0.0
==========================

This file details the changes between Scilab 2026.0.0 (this version) and the previous 2025.1.0 stable release.

For changelogs of earlier releases, please see [Scilab 2025.1.0][1].

Summary:

- New features
- Obsolete functions & features
- Removed functions & features
- Known incompatibilities
- Compilation & Packaging
- Fixed issues

Please report anything we may have missed on [Discourse][2] or [GitLab][3].

[1]: https://help.scilab.org/docs/2025.1.0/en_US/CHANGES.html
[2]: https://scilab.discourse.group/
[3]: https://gitlab.com/scilab/scilab/-/issues

New features
------------

For a high-level description of the main new features in this release, please consult the homepage of the embedded documentation, available by simply typing `doc` in the Scilab console.

### New functions

- `cdftnc()`: Cumulative distribution function of the non-central student's T distribution.
- `dbscan()`: Density-based clustering.
- `enumeration()`: Get the enumeration of a classdef or an object.
- `estimate_bandwidth()`: Estimate an appropriate bandwidth for mean shift clustering.
- `gallery()`: Generate test matrices.
- `gradient()`: Compute numerical gradient.
- `isa()`: Check variable type.
- `meanshift()`: Mean shift clustering algorithm.
- `methods()`: Get accessible methods of a classdef or an object.
- `properties()`: Get accessible properties of a classdef or an object.
- `sortrows()` : Sort rows of a vector, matrix, table, or timeseries.
- `spset()`: Set non-zero entries of a sparse matrix.

### Features improvements

- `host()` has been rewritten and is now used as backend for all other functions that perform system calls (`dos()`, `unix()`, `unix_g()`, `unix_s()`, `unix_w()`, and `unix_x()`) which are now obsolete.
- `intersect()` now manages `duration`, `datetime`, `table`, and `timeseries` types.
- `lib()` can now load a library without exposing its symbols (default behavior remains unchanged).
- `setdiff()` now manages `duration`, `datetime`, `table`, and `timeseries` types.
- `table()` and `timeseries()` now manage integers.
- `union()` now manages `duration`, `datetime`, `table`, and `timeseries` types.
- Options names are now case-insensitive for `duration()`, `calendarDuration()`, `datetime()`, `timeseries()`, and `table()` functions.

### Language

- Classes/Objects can now be defined and used in Scilab based on the new `classdef`, `enumeration`, `properties` & `methods` keywords.
- `end` keyword can now be used to specify the last row/column index of an array, similarly to `$`.

### Graphics

- Axes handles can now have their own colormap. If not provided, then the parent figure colormap is used (as in previous versions).

### Xcos

- Diagrams are saved as [SSP](https://ssp-standard.org/) (System Structure and Parametrization) files by default. This setting can be edited in user preferences.
- Users are now enabled to save their diagrams as COSF files.
- COS format is no more associated with Xcos under Windows.
- SSP files are associated with Scilab during installation under Windows.

Obsolete functions or features
------------------------------

All these functions and features will be removed in Scilab 2026.1.0 (May 2026):

- `demo_begin()`: Please use `exec()` instead.
- `demo_choose()`: Please use `x_choose()` instead.
- `demo_compiler()`: Please use `haveacompiler()` instead.
- `demo_end()`: Please use `exec()` instead.
- `demo_file_choice()`: Please use `x_choose()` instead.
- `demo_function_choice()`: Please use `x_choose()` instead.
- `demo_run()`: Please use `exec()` instead.

All these functions and features will be removed in Scilab 2027.0.0 (October 2026):

- `dos()`: Please use `host()` instead.
- `unix()`: Please use `host()` instead.
- `unix_g()`: Please use `host()` instead.
- `unix_s()`: Please use `host()` instead.
- `unix_w()`: Please use `host()` instead.
- `unix_x()`: Please use `host()` instead.

Removed Functions
-----------------

The following functions have been removed:

- `demo_folder_choice()`: undocumented and not used, replaced by `x_choose()`.
- `lft(P, p, R, r)`: obsolete since 2025.0.0, no more supported.
- `h2norm(Sl [,tol])` (with `Sl` a matrix of doubles): obsolete since 2025.0.0, no more supported.
- `linf(g [,eps, tol])` (with `g` a matrix of doubles): obsolete since 2025.0.0, no more supported.
- `nicholschart(modules,, colors)` (syntax with skipped arguments): obsolete since 2025.0.0, no more supported.
- `st_ility(Sl [,tol])` (with `Sl` a matrix of doubles): obsolete since 2025.0.0, no more supported.
- `syssize(Sl)` (with `Sl` a matrix of doubles): obsolete since 2025.0.0, no more supported.
- `help()`: obsolete since 2025.0.0, please use `doc()` instead.
- `daskr()`: obsolete since 2024.1.0, please use `dae()` instead.
- `dasrt()`: obsolete since 2024.1.0, please use `dae()` instead.
- `dassl()`: obsolete since 2024.1.0, please use `dae()` instead.
- `impl()`: obsolete since 2025.0.0, please use `dae()` instead.
- `testmatrix()`: obsolete since 2025.0.0, please use `magic()`, `invhilb()` or `frank()` instead.
- `captions()`: obsolete since 2025.0.0, please use `legend()` instead.
- `figure_style` property: obsolete since 2025.1.0, no more supported.
- `princomp()`: obsolete since 2025.0.0, please use `pca()` instead.

Known incompatibilities
-----------------------

- `genlib()` no more loads generated library (see [#15918](https://gitlab.com/scilab/scilab/-/issues/15918)). `lib()` function must be called to load the generated library.
- `host()` function now returns `0` (success) instead of `1` (error) when called with an empty character string as input.

Compilation
-----------

- Windows: Migration to Intel® oneAPI HPC Toolkit 2025.2.
- Linux: GCC 15 is now supported.

If you are familiar with building Scilab from sources, the following dependencies have been updated.

- Required API version of JCEF updated to 130.1.9 (Scilab is packaged with version 135.0.20).
- PCRE2 10.43 (or more recent) is now required (instead of PCRE1).
- Scilab now uses SUNDIALS 7.4.
- Under Windows, Scilab now uses HDF5 1.14.3 instead of 1.14.4 (see [#17441](https://gitlab.com/scilab/scilab/-/issues/17441)).

Packaging & Supported Operating Systems
---------------------------------------

- To run or compile Scilab, you might need:
  - Windows (amd64):
    - Windows 11 (Desktop)
    - Windows 10 (Desktop)
  - macOS:
    - M1-based Mac running macOS 11+ (compile and run)
    - Intel-based Mac running macOS 11+ (compile and run)
  - Linux (amd64):
    - debian: 13
    - ubuntu: 22.04, 24.04, 25.04
    - fedora: 42

Issue Fixes
-----------

### Scilab 2026.0.0

- [#7113](https://gitlab.com/scilab/scilab/-/issues/7113): `demo_compiler()` was a useless wrapper for `haveacompiler()` and has been removed.
- [#7258](https://gitlab.com/scilab/scilab/-/issues/7258): There were 8 functions to run an operating-system command, all have been merged in new `host()` function.
- [#8212](https://gitlab.com/scilab/scilab/-/issues/8212): Some deprecated functions such as `demo_begin()` and `demo_end)` were no longer maintained; they are now tagged as obsolete.
- [#12955](https://gitlab.com/scilab/scilab/-/issues/12955): `Matplot()` extension to (#,#,3) true colors ND-arrays was not documented.
- [#13260](https://gitlab.com/scilab/scilab/-/issues/13260): There was no CDF for the non central student distribution.
- [#13875](https://gitlab.com/scilab/scilab/-/issues/13875): `spset(A, v)`, dual of `[ij, v]=spget(A)` was missing.
- [#14713](https://gitlab.com/scilab/scilab/-/issues/14713): `demo_run(file)` was useless and no longer maintained; it is now tagged as obsolete.
- [#14790](https://gitlab.com/scilab/scilab/-/issues/14790): The "Axes" `ticks_format` and `ticks_st properties` were no more taken into account.
- [#15214](https://gitlab.com/scilab/scilab/-/issues/15214): Colormaps can now be assigned to "Axes" handles.
- [#15442](https://gitlab.com/scilab/scilab/-/issues/15442): `printf()` did not handle "uint64" integers greater than 2^32-1.
- [#15918](https://gitlab.com/scilab/scilab/-/issues/15918): `mylib = lib(libdir)` registered functions in the default library instead of in the one given as output argument.
- [#16074](https://gitlab.com/scilab/scilab/-/issues/16074): `msprintf("%ld\n", i)` and `mprintf("%ld\n", i)` appended some "d" for "int64" or "uint64" inputs.
- [#16546](https://gitlab.com/scilab/scilab/-/issues/16546): `cdft()`, T-distribution, returned wrong values when used with a low degree of freedom.
- [#17089](https://gitlab.com/scilab/scilab/-/issues/17089): Scilab now uses PCRE2 for regular expression support (instead of deprecated PCRE 1.3 version).
- [#17240](https://gitlab.com/scilab/scilab/-/issues/17240): `unix_g()` did not read standard error output when exit code was 0 or 1 and did not read stdout when exit code was 2 or more.
- [#17242](https://gitlab.com/scilab/scilab/-/issues/17242): SciPowerlab toolbox did not work with Scilab 2024.0.0.
- [#17243](https://gitlab.com/scilab/scilab/-/issues/17243): Xcos sometimes displayed an error about port size or type.
- [#17357](https://gitlab.com/scilab/scilab/-/issues/17357): `demo_file_choice()` was no longer maintained; it is now tagged as obsolete.
- [#17378](https://gitlab.com/scilab/scilab/-/issues/17378): Variables returned by `jarray()` could not be used/initialized.
- [#17391](https://gitlab.com/scilab/scilab/-/issues/17391): `csvRead()` was extremely slow to detect errors in column structure.
- [#17410](https://gitlab.com/scilab/scilab/-/issues/17410): Most recent version of FORTRAN OneAPI can now be detected and used by Scilab.
- [#17432](https://gitlab.com/scilab/scilab/-/issues/17432): Simple `table()` Matlab example did not work in Scilab.
- [#17435](https://gitlab.com/scilab/scilab/-/issues/17435): `table()` creation did not support empty matrices.
- [#17436](https://gitlab.com/scilab/scilab/-/issues/17436): Context was empty in "Water tank" demonstration and now contains variables needed for simulation.
- [#17437](https://gitlab.com/scilab/scilab/-/issues/17437): If the "Find/Replace" window of SciNotes was opened when Scilab was closed, it could not be closed.
- [#17438](https://gitlab.com/scilab/scilab/-/issues/17438): Scilab could not be compiled using GCC 15.
- [#17439](https://gitlab.com/scilab/scilab/-/issues/17439): Annotations were not supported for Xcos links.
- [#17441](https://gitlab.com/scilab/scilab/-/issues/17441): `xsave()` and `save()` no more worked with accented letters in the filename since Scilab 2025.0.0 on Windows.
- [#17442](https://gitlab.com/scilab/scilab/-/issues/17442): Documentation example for installing an ATOMS module from a file did not work.
- [#17443](https://gitlab.com/scilab/scilab/-/issues/17443): Changing the input/output format of duration object failed when forcing 'HH' to 24h format.
- [#17445](https://gitlab.com/scilab/scilab/-/issues/17445): `copyfile()` (used by `tbx_package()`) ddid not preserve symbolic links.
- [#17446](https://gitlab.com/scilab/scilab/-/issues/17446): `isvector()` documentation was wrong for scalar case.
- [#17447](https://gitlab.com/scilab/scilab/-/issues/17447): Some `java.nio.file.AccessDeniedException` errors were displayed by FileBrowser.
- [#17452](https://gitlab.com/scilab/scilab/-/issues/17452): `genlib()` made Scilab crash when macro code contained extra parentheses.
- [#17458](https://gitlab.com/scilab/scilab/-/issues/17458): Scilab could not be built against recent versions of JCEF.
- [#17459](https://gitlab.com/scilab/scilab/-/issues/17459): `std::from_chars` is now replaced by `fast_float::from_chars` for FreeBSD & macOS.
- [#17460](https://gitlab.com/scilab/scilab/-/issues/17460): Reading JSON files with empty objects made Scilab crash.
- [#17462](https://gitlab.com/scilab/scilab/-/issues/17462): `call_scilab` examples could not be built on recent GCC versions.
- [#17464](https://gitlab.com/scilab/scilab/-/issues/17464): `demo_function_choice()` was no longer maintained; it is now tagged as obsolete.
- [#17466](https://gitlab.com/scilab/scilab/-/issues/17466): An empty figure was drawn by `plot()` for data with a varying `X` and a close-to-constant `Y`.
- [#17468](https://gitlab.com/scilab/scilab/-/issues/17468): Scilab could not be built against recent versions libXML2 (>=2.14).
- [#17473](https://gitlab.com/scilab/scilab/-/issues/17473): Under Windows, background launch of Scilab created zombies.
- [#17477](https://gitlab.com/scilab/scilab/-/issues/17477): Since Scilab 2024.1.0, error reporting was broken when no `DISPLAY` variable was set.
- [#17478](https://gitlab.com/scilab/scilab/-/issues/17478): Compilation failed after SUNDIALS update.
- [#17479](https://gitlab.com/scilab/scilab/-/issues/17479): Inline documentation failed for non existing language documentation.
- [#17482](https://gitlab.com/scilab/scilab/-/issues/17482): Legend processing was broken if not all curves were given a string.
