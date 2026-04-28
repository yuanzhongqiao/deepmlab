#  Scicos
#
#  Copyright (C) INRIA - scilab 
#  Copyright (C) DIGITEO - 2009 - Allan CORNET
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# See the file ./license.txt

OCAMLPATH=$(OPAM_SWITCH_PREFIX)

OCAMLPATHBIN=$(OCAMLPATH)\bin
OCAMLPATHLIB=$(OCAMLPATH)\lib
OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
CAMLP4=camlp4
OCAMLYACC=ocamlyacc
OCAMLLEX=ocamllex
RM=del
EXEC=modelicac.exe
OCAMLLIBS=nums.cmxa
PARSER_SRC=parser.mly
LEXER_SRC=lexer.mll

MLS=parseTree.ml linenum.ml parser.ml lexer.ml\
	precompilation.ml compilation.ml instantiation.ml\
	graphNodeSet.ml symbolicExpression.ml\
	squareSparseMatrix.ml bipartiteGraph.ml hungarianMethod.ml\
	causalityGraph.ml\
	optimization.ml xMLCodeGeneration.ml optimizingCompiler.ml\
	scicosCodeGeneration.ml scicosOptimizingCompiler.ml
    
CMACMO=linenum.cmo nums.cma parseTree.cmo parser.cmo \
       lexer.cmo precompilation.cmo compilation.cmo \
       instantiation.cmo graphNodeSet.cmo symbolicExpression.cmo \
       squareSparseMatrix.cmo bipartiteGraph.cmo hungarianMethod.cmo \
       causalityGraph.cmo optimization.cmo scicosCodeGeneration.cmo \
       xMLCodeGeneration.cmo optimizingCompiler.cmo

CMX=parseTree.cmx linenum.cmx parser.cmx lexer.cmx \
	precompilation.cmx compilation.cmx instantiation.cmx \
	graphNodeSet.cmx symbolicExpression.cmx squareSparseMatrix.cmx \
	bipartiteGraph.cmx hungarianMethod.cmx causalityGraph.cmx \
	optimization.cmx xMLCodeGeneration.cmx optimizingCompiler.cmx \
	scicosCodeGeneration.cmx scicosOptimizingCompiler.cmx

all:: step1 step2 step3 step4 step5 step6


step1: 
	@"$(OCAMLLEX)" linenum.mll
	@"$(OCAMLYACC)" $(PARSER_SRC)
	@$(RM) parser.mli
	@"$(OCAMLLEX)" $(LEXER_SRC)
	
	
step2:
	@"$(OCAMLDEP)" $(MLS)
	
step3: 
	@"$(OCAMLC)" -c linenum.ml
	@"$(OCAMLC)" -c parseTree.ml
	@"$(OCAMLC)" -c parser.ml
	@"$(OCAMLC)" -c lexer.ml
	@"$(OCAMLC)" -c precompilation.ml
	@"$(OCAMLC)" -c compilation.ml
	@"$(OCAMLC)" -c instantiation.ml
	@"$(OCAMLC)" -c graphNodeSet.ml
	@"$(OCAMLC)" -c symbolicExpression.ml
	@"$(OCAMLC)" -c squareSparseMatrix.ml
	@"$(OCAMLC)" -c bipartiteGraph.ml
	@"$(OCAMLC)" -c hungarianMethod.ml
	@"$(OCAMLC)" -c causalityGraph.ml
	@"$(OCAMLC)" -c optimization.ml
	@"$(OCAMLC)" -c xMLCodeGeneration.ml
	@"$(OCAMLC)" -c optimizingCompiler.ml
	@"$(OCAMLC)" -c scicosCodeGeneration.ml
	@"$(OCAMLC)" -c scicosOptimizingCompiler.ml
	
	
step4:
	@"$(OCAMLC)" -o $(EXEC) $(CMACMO) scicosOptimizingCompiler.ml
	
	
step5:
	@"$(OCAMLOPT)" -c linenum.ml
	@"$(OCAMLOPT)" -c parseTree.ml
	@"$(OCAMLOPT)" -c parser.ml
	@"$(OCAMLOPT)" -c lexer.ml
	@"$(OCAMLOPT)" -c precompilation.ml
	@"$(OCAMLOPT)" -c compilation.ml
	@"$(OCAMLOPT)" -c instantiation.ml
	@"$(OCAMLOPT)" -c graphNodeSet.ml
	@"$(OCAMLOPT)" -c symbolicExpression.ml
	@"$(OCAMLOPT)" -c squareSparseMatrix.ml
	@"$(OCAMLOPT)" -c bipartiteGraph.ml
	@"$(OCAMLOPT)" -c hungarianMethod.ml
	@"$(OCAMLOPT)" -c causalityGraph.ml
	@"$(OCAMLOPT)" -c optimization.ml
	@"$(OCAMLOPT)" -c xMLCodeGeneration.ml
	@"$(OCAMLOPT)" -c scicosCodeGeneration.ml
	@"$(OCAMLOPT)" -c optimizingCompiler.ml
	@"$(OCAMLOPT)" -c scicosOptimizingCompiler.ml
	
	
step6:
	@"$(OCAMLOPT)" -o $(EXEC) $(OCAMLLIBS) $(CMX)
	@copy  $(EXEC) ..\..\..\..\bin\$(EXEC)
	
clean::
	@-$(RM)  *.cmi
	@-$(RM)  *.cmo
	@-$(RM)  *.cmx
	@-$(RM)  *.obj
	@-$(RM)  parser.ml
	@-$(RM)  lexer.ml
	@-$(RM)  linenum.ml
	@-$(RM)  *.exe
	@-$(RM)  ..\..\..\..\bin\$(EXEC)
	
	
distclean::
	@-$(RM)  *.cmi
	@-$(RM)  *.cmo
	@-$(RM)  *.cmx
	@-$(RM)  *.obj
	@-$(RM)  parser.ml
	@-$(RM)  lexer.ml
	@-$(RM)  linenum.ml
	@-$(RM)  *.exe
	
