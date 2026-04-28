##
##  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
##  Copyright (C) 2007-2008 - DIGITEO - Bruno JOFRET
##  Copyright (C) 2007-2008 - DIGITEO - Antoine ELIAS
##
# Copyright (C) 2012 - 2016 - Scilab Enterprises
#
# This file is hereby licensed under the terms of the GNU GPL v2.0,
# pursuant to article 5.3.4 of the CeCILL v.2.1.
# This file was originally licensed under the terms of the CeCILL v2.1,
# and continues to be available under such terms.
# For more information, see the COPYING file which you should have received
# along with this program.
##
##

#### Target ######
modulename=slint

####io : init scripts ####
libscislint_la_etcdir = $(mydatadir)/etc
libscislint_la_etc_DATA = \
    etc/slint.quit \
    etc/slint.start \
    etc/slint.xml \
    etc/slint_all.xml \
    etc/cnes_analysis_conf.xml \
    etc/cnes_tool_conf.xml

include $(top_srcdir)/Makefile.incl.am

SLINT_CXX_SOURCES = \
src/cpp/SLintContext.cpp \
src/cpp/SLintChecker.cpp \
src/cpp/SLintVisitor.cpp \
src/cpp/SLint.cpp \
src/cpp/SLintOptions.cpp \
src/cpp/SciFile.cpp \
src/cpp/FileException.cpp \
src/cpp/PCREMatcher.cpp \
src/cpp/PCREException.cpp \
src/cpp/XMLConfig.cpp \
src/cpp/SLintXMLException.cpp \
src/cpp/SLintScilabResult.cpp \
src/cpp/FunctionNameChecker.cpp \
src/cpp/FunctionArgsChecker.cpp \
src/cpp/VariableNameChecker.cpp \
src/cpp/VariablesChecker.cpp \
src/cpp/UselessArgChecker.cpp \
src/cpp/UselessRetChecker.cpp \
src/cpp/RedefinitionChecker.cpp \
src/cpp/SingleInstrChecker.cpp \
src/cpp/EmptyBlockChecker.cpp \
src/cpp/SemicolonAtEOLChecker.cpp \
src/cpp/MopenMcloseChecker.cpp \
src/cpp/PrintfChecker.cpp \
src/cpp/TodoChecker.cpp \
src/cpp/McCabeChecker.cpp \
src/cpp/McCabeVisitor.cpp \
src/cpp/DecimalChecker.cpp \
src/cpp/LineLengthChecker.cpp \
src/cpp/LinesCountChecker.cpp \
src/cpp/IllegalCallsChecker.cpp \
src/cpp/NaNChecker.cpp \
src/cpp/EqEqChecker.cpp \
src/cpp/UselessOpChecker.cpp \
src/cpp/UnreachableCodeChecker.cpp \
src/cpp/DeprecatedChecker.cpp \
src/cpp/SelectChecker.cpp \
src/cpp/ImplicitListChecker.cpp \
src/cpp/StructChecker.cpp \
src/cpp/LoadSaveChecker.cpp \
src/cpp/OldNotChecker.cpp \
src/cpp/SpacesAroundOpChecker.cpp \
src/cpp/BreaksInLoopChecker.cpp \
src/cpp/NestedBlocksChecker.cpp \
src/cpp/BracketedExpChecker.cpp \
src/cpp/NotNotChecker.cpp \
src/cpp/SpacesInArgsChecker.cpp \
src/cpp/GlobalKeywordChecker.cpp \
src/cpp/ExpInCondChecker.cpp \
src/cpp/CommentRatioChecker.cpp \
src/cpp/FunctionArgsOrderChecker.cpp \
src/cpp/FunctionTestReturnChecker.cpp \
src/cpp/ReturnsCountChecker.cpp \
src/cpp/NotEqualChecker.cpp \
src/cpp/XMLtools.cpp \
src/cpp/SLintXmlResult.cpp \
src/cpp/AnalysisConfiguration.cpp \
src/cpp/AnalysisConfigurationType.cpp \
src/cpp/AnalysisRuleParameterType.cpp \
src/cpp/AnalysisRuleType.cpp \
src/cpp/ExcludedProjectFileType.cpp \
src/cpp/RuleLinkType.cpp \
src/cpp/Standard.cpp \
src/cpp/StandardRuleParameterType.cpp \
src/cpp/StandardRuleParameterValueType.cpp \
src/cpp/StandardRuleType.cpp \
src/cpp/StandardType.cpp \
src/cpp/ToolConfiguration.cpp \
src/cpp/ToolConfigurationType.cpp \
src/cpp/CNESException.cpp \
src/cpp/CNESConfig.cpp \
src/cpp/CNESXmlResult.cpp \
src/cpp/CNESCsvResult.cpp

GATEWAY_CXX_SOURCES = \
    sci_gateway/cpp/sci_slint.cpp

libscislint_la_CPPFLAGS = \
    -I$(srcdir)/includes/ \
    -I$(srcdir)/src/cpp/ \
    -I$(top_srcdir)/modules/ast/includes/ast/ \
    -I$(top_srcdir)/modules/ast/includes/exps/ \
    -I$(top_srcdir)/modules/ast/includes/operations/ \
    -I$(top_srcdir)/modules/ast/includes/parse/ \
    -I$(top_srcdir)/modules/ast/includes/symbol/ \
    -I$(top_srcdir)/modules/ast/includes/system_env/ \
    -I$(top_srcdir)/modules/ast/includes/types/ \
    -I$(top_srcdir)/modules/core/includes/ \
    -I$(top_srcdir)/modules/api_scilab/includes/ \
    -I$(top_srcdir)/modules/localization/includes/ \
    -I$(top_srcdir)/modules/output_stream/includes/ \
    -I$(top_srcdir)/modules/string/includes/ \
    -I$(top_srcdir)/modules/fileio/includes/ \
    -I$(top_srcdir)/modules/string/includes/ \
    -I$(top_srcdir)/modules/dynamic_link/includes \
    -I$(top_srcdir)/modules/threads/includes/ \
    $(XML_FLAGS) \
    $(PCRE2_CFLAGS) \
    $(SLINT_FLAGS) \
    $(AM_CPPFLAGS)

pkglib_LTLIBRARIES = libscislint.la
noinst_LTLIBRARIES = libscislint-algo.la

libscislint_algo_la_SOURCES = $(SLINT_CXX_SOURCES)
libscislint_la_SOURCES = $(GATEWAY_CXX_SOURCES)
libscislint_algo_la_CPPFLAGS = $(libscislint_la_CPPFLAGS)

libscislint_la_LDFLAGS = $(AM_LDFLAGS)
libscislint_la_LIBADD = libscislint-algo.la $(XML_LIBS)

# For the code check (splint)
INCLUDE_FLAGS = $(libscislint_la_CPPFLAGS)

#### slint : include files ####
libscislint_la_includedir=$(pkgincludedir)
libscislint_la_include_HEADERS = \
includes/FileException.hxx \
includes/PCREException.hxx \
includes/PCREMatcher.hxx \
includes/SLintContext.hxx \
includes/SLintOptions.hxx \
includes/SLintVisitor.hxx \
includes/dynlib_slint.h \
includes/SLintXMLException.hxx \
includes/XMLtools.hxx \
includes/PCRE.hxx \
includes/SciFile.hxx \
includes/SLint.hxx

libscislint_la_include_configdir=$(pkgincludedir)/config
libscislint_la_include_config_HEADERS = \
includes/config/XMLConfig.hxx

libscislint_la_include_outputdir=$(pkgincludedir)/output
libscislint_la_include_output_HEADERS = \
includes/output/SLintXmlResult.hxx \
includes/output/SLintResult.hxx \
includes/output/SLintScilabResult.hxx

libscislint_la_include_checkersdir=$(pkgincludedir)/checkers
libscislint_la_include_checkers_HEADERS = \
includes/checkers/CommentRatioChecker.hxx \
includes/checkers/PrintfChecker.hxx \
includes/checkers/FunctionTestReturnChecker.hxx \
includes/checkers/FindSymVisitor.hxx \
includes/checkers/ExpInCondChecker.hxx \
includes/checkers/NotNotChecker.hxx \
includes/checkers/ImplicitListChecker.hxx \
includes/checkers/NaNChecker.hxx \
includes/checkers/FunctionArgsChecker.hxx \
includes/checkers/VariableNameChecker.hxx \
includes/checkers/LinesCountChecker.hxx \
includes/checkers/LineLengthChecker.hxx \
includes/checkers/TodoChecker.hxx \
includes/checkers/VariablesChecker.hxx \
includes/checkers/OldNotChecker.hxx \
includes/checkers/StructChecker.hxx \
includes/checkers/MopenMcloseChecker.hxx \
includes/checkers/AllCheckers.hxx \
includes/checkers/BracketedExpChecker.hxx \
includes/checkers/SelectChecker.hxx \
includes/checkers/UselessArgChecker.hxx \
includes/checkers/LoadSaveChecker.hxx \
includes/checkers/RedefinitionChecker.hxx \
includes/checkers/ReturnsCountChecker.hxx \
includes/checkers/SemicolonAtEOLChecker.hxx \
includes/checkers/McCabeChecker.hxx \
includes/checkers/UselessOpChecker.hxx \
includes/checkers/BreaksInLoopChecker.hxx \
includes/checkers/EqEqChecker.hxx \
includes/checkers/EmptyBlockChecker.hxx \
includes/checkers/ReturnChecker.hxx \
includes/checkers/DeprecatedChecker.hxx \
includes/checkers/GlobalKeywordChecker.hxx \
includes/checkers/NestedBlocksChecker.hxx \
includes/checkers/IllegalCallsChecker.hxx \
includes/checkers/SpacesAroundOpChecker.hxx \
includes/checkers/UselessRetChecker.hxx \
includes/checkers/SingleInstrChecker.hxx \
includes/checkers/FunctionNameChecker.hxx \
includes/checkers/UnreachableCodeChecker.hxx \
includes/checkers/SLintChecker.hxx \
includes/checkers/NotEqualChecker.hxx \
includes/checkers/DecimalChecker.hxx \
includes/checkers/FunctionArgsOrderChecker.hxx \
includes/checkers/SpacesInArgsChecker.hxx \
includes/checkers/McCabeVisitor.hxx

#### slint : gateway declaration ####
libscislint_la_sci_gatewaydir = $(mydatadir)/sci_gateway
libscislint_la_sci_gateway_DATA = sci_gateway/slint_gateway.xml
