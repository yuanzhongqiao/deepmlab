/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    DOTS = 258,                    /* "line break"  */
    EOL = 259,                     /* "end of line"  */
    SPACES = 260,                  /* "spaces"  */
    BOOLTRUE = 261,                /* "%t or %T"  */
    BOOLFALSE = 262,               /* "%f or %F"  */
    QUOTE = 263,                   /* "'"  */
    NOT = 264,                     /* "~ or @"  */
    ARROW = 265,                   /* "->"  */
    SHARP = 266,                   /* "#"  */
    DOLLAR = 267,                  /* "$"  */
    COMMA = 268,                   /* ","  */
    COLON = 269,                   /* ":"  */
    SEMI = 270,                    /* ";"  */
    LPAREN = 271,                  /* "("  */
    RPAREN = 272,                  /* ")"  */
    LBRACK = 273,                  /* "["  */
    RBRACK = 274,                  /* "]"  */
    LBRACE = 275,                  /* "{"  */
    RBRACE = 276,                  /* "}"  */
    DOT = 277,                     /* "."  */
    DOTQUOTE = 278,                /* ".'"  */
    PLUS = 279,                    /* "+"  */
    MINUS = 280,                   /* "-"  */
    TIMES = 281,                   /* "*"  */
    DOTTIMES = 282,                /* ".*"  */
    KRONTIMES = 283,               /* ".*."  */
    CONTROLTIMES = 284,            /* "*."  */
    RDIVIDE = 285,                 /* "/"  */
    DOTRDIVIDE = 286,              /* "./"  */
    CONTROLRDIVIDE = 287,          /* "/."  */
    KRONRDIVIDE = 288,             /* "./."  */
    LDIVIDE = 289,                 /* "\\"  */
    DOTLDIVIDE = 290,              /* ".\\"  */
    CONTROLLDIVIDE = 291,          /* "\\."  */
    KRONLDIVIDE = 292,             /* ".\\."  */
    POWER = 293,                   /* "** or ^"  */
    DOTPOWER = 294,                /* ".^"  */
    EQ = 295,                      /* "=="  */
    NE = 296,                      /* "<> or ~="  */
    LT = 297,                      /* "<"  */
    LE = 298,                      /* "<="  */
    GT = 299,                      /* ">"  */
    GE = 300,                      /* ">="  */
    AND = 301,                     /* "&"  */
    ANDAND = 302,                  /* "&&"  */
    OR = 303,                      /* "|"  */
    OROR = 304,                    /* "||"  */
    ASSIGN = 305,                  /* "="  */
    ARGUMENTS = 306,               /* "arguments"  */
    CLASSDEF = 307,                /* "classdef"  */
    ENUMERATION = 308,             /* "enumeration"  */
    METHODS = 309,                 /* "methods"  */
    PROPERTIES = 310,              /* "properties"  */
    IF = 311,                      /* "if"  */
    THEN = 312,                    /* "then"  */
    ELSE = 313,                    /* "else"  */
    ELSEIF = 314,                  /* "elseif"  */
    END = 315,                     /* "end"  */
    SELECT = 316,                  /* "select"  */
    SWITCH = 317,                  /* "switch"  */
    CASE = 318,                    /* "case"  */
    OTHERWISE = 319,               /* "otherwise"  */
    FUNCTION = 320,                /* "function"  */
    ENDFUNCTION = 321,             /* "endfunction"  */
    FOR = 322,                     /* "for"  */
    WHILE = 323,                   /* "while"  */
    DO = 324,                      /* "do"  */
    BREAK = 325,                   /* "break"  */
    CONTINUE = 326,                /* "continue"  */
    TRY = 327,                     /* "try"  */
    CATCH = 328,                   /* "catch"  */
    RETURN = 329,                  /* "return"  */
    FLEX_ERROR = 330,              /* FLEX_ERROR  */
    STR = 331,                     /* "string"  */
    ID = 332,                      /* "identifier"  */
    VARINT = 333,                  /* "integer"  */
    VARFLOAT = 334,                /* "float"  */
    COMPLEXNUM = 335,              /* "complex number"  */
    NUM = 336,                     /* "number"  */
    PATH = 337,                    /* "path"  */
    COMMENT = 338,                 /* "line comment"  */
    BLOCKCOMMENT = 339,            /* "block comment"  */
    TOPLEVEL = 340,                /* TOPLEVEL  */
    HIGHLEVEL = 341,               /* HIGHLEVEL  */
    UPLEVEL = 342,                 /* UPLEVEL  */
    LISTABLE = 343,                /* LISTABLE  */
    CONTROLBREAK = 344,            /* CONTROLBREAK  */
    UMINUS = 345,                  /* UMINUS  */
    UPLUS = 346,                   /* UPLUS  */
    FUNCTIONCALL = 347             /* FUNCTIONCALL  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define DOTS 258
#define EOL 259
#define SPACES 260
#define BOOLTRUE 261
#define BOOLFALSE 262
#define QUOTE 263
#define NOT 264
#define ARROW 265
#define SHARP 266
#define DOLLAR 267
#define COMMA 268
#define COLON 269
#define SEMI 270
#define LPAREN 271
#define RPAREN 272
#define LBRACK 273
#define RBRACK 274
#define LBRACE 275
#define RBRACE 276
#define DOT 277
#define DOTQUOTE 278
#define PLUS 279
#define MINUS 280
#define TIMES 281
#define DOTTIMES 282
#define KRONTIMES 283
#define CONTROLTIMES 284
#define RDIVIDE 285
#define DOTRDIVIDE 286
#define CONTROLRDIVIDE 287
#define KRONRDIVIDE 288
#define LDIVIDE 289
#define DOTLDIVIDE 290
#define CONTROLLDIVIDE 291
#define KRONLDIVIDE 292
#define POWER 293
#define DOTPOWER 294
#define EQ 295
#define NE 296
#define LT 297
#define LE 298
#define GT 299
#define GE 300
#define AND 301
#define ANDAND 302
#define OR 303
#define OROR 304
#define ASSIGN 305
#define ARGUMENTS 306
#define CLASSDEF 307
#define ENUMERATION 308
#define METHODS 309
#define PROPERTIES 310
#define IF 311
#define THEN 312
#define ELSE 313
#define ELSEIF 314
#define END 315
#define SELECT 316
#define SWITCH 317
#define CASE 318
#define OTHERWISE 319
#define FUNCTION 320
#define ENDFUNCTION 321
#define FOR 322
#define WHILE 323
#define DO 324
#define BREAK 325
#define CONTINUE 326
#define TRY 327
#define CATCH 328
#define RETURN 329
#define FLEX_ERROR 330
#define STR 331
#define ID 332
#define VARINT 333
#define VARFLOAT 334
#define COMPLEXNUM 335
#define NUM 336
#define PATH 337
#define COMMENT 338
#define BLOCKCOMMENT 339
#define TOPLEVEL 340
#define HIGHLEVEL 341
#define UPLEVEL 342
#define LISTABLE 343
#define CONTROLBREAK 344
#define UMINUS 345
#define UPLUS 346
#define FUNCTIONCALL 347

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{

  /* Tokens. */
    double                      number;
    std::wstring*               str;
    std::wstring*               path;
    std::wstring*               comment;

    LineBreakStr*               mute;

    ast::exps_t*                t_list_var;
    ast::exps_t*                t_list_exp;
    std::tuple<ast::exps_t, ast::exps_t, ast::exps_t>* t_tuple_list_exp;
    ast::Exp*                   t_exp;

    ast::SeqExp*                t_seq_exp;
    ast::ReturnExp*             t_return_exp;

    ast::ArgumentsExp*          t_arguments_exp;
    ast::IfExp*                 t_if_exp;
    ast::WhileExp*              t_while_exp;
    ast::ForExp*                t_for_exp;
    ast::TryCatchExp*           t_try_exp;
    ast::SelectExp*             t_select_exp;
    ast::CaseExp*               t_case_exp;
    ast::exps_t*                t_list_case;

    ast::CallExp*               t_call_exp;

    ast::MathExp*               t_math_exp;

    ast::OpExp*                 t_op_exp;
    ast::OpExp::Oper            t_op_exp_oper;
    ast::LogicalOpExp::Oper     t_lop_exp_oper;

    ast::AssignExp*             t_assign_exp;

    ast::StringExp*             t_string_exp;

    ast::ListExp*               t_implicit_list;

    ast::MatrixExp*             t_matrix_exp;
    ast::MatrixLineExp*         t_matrixline_exp;
    ast::exps_t*                t_list_mline;

    ast::CellExp*               t_cell_exp;

    ast::CellCallExp*           t_cell_call_exp;

    ast::FunctionDec*           t_function_dec;
    ast::ArgumentDec*           t_argument_dec;
    ast::EnumDec*               t_enum_dec;
    ast::PropertiesDec*         t_properties_dec;
    ast::MethodsDec*               t_methods_dec;

    ast::ArrayListExp*          t_arraylist_exp;
    ast::AssignListExp*         t_assignlist_exp;
    ast::ArrayListVar*          t_arraylist_var;

    ast::SimpleVar*             t_simple_var;


};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;

int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
