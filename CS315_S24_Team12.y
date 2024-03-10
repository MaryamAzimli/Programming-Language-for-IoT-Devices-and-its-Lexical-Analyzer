%token IDENTIFIER CONST ZERO COMMENT_OP 
	FIVE_LP WHITE_LP VOID_KEYWORD INT_KEYWORD OUT_KEYWORD
	SCAN_KEYWORD OUTLN_KEYWORD IF ELSE DEC_KEYWORD RETURN_KEYWORD
	SC COMMA STRING LEFT_SQ RIGHT_SQ LEFT_PRNTH RIGHT_PRNTH
	LEFT_CURLY RIGHT_CURLY PLUS_OP INPUT_OP MINUS_OP MULT_OP 
	DIV_OP EXP_OP MOD_OP OR AND ASSIGN_OP BIG_OR_EQ_OP BIG_OP 
	LESS_OR_EQ_OP LESS_OP EQUALITY_OP NL ELSE_IF
	
	NOT_EQ_OP SENSOR_KEYWORD_DOT TEMPERATURE_KEYWORD 
	HUMIDITY_KEYWORD AIR_PRESSURE AIR_QUALITY
	LIGHT SOUND_LEVEL TIMER_KEYWORD_DOT GET_YEAR GET_MONTH GET_DAY
	GET_HOUR GET_MINUTE GET_SECOND GET_FULL 
	CONNECTION_READ CONNECTION_SEND CONNECTION_KEYWORD CONNECTION_CREATE SWITCH_LIGHTS
	SWITCH_HEATER SWITCH_AIR_CONDITIONER SWITCH_FOUR SWITCH_FIVE SWITCH_SIX 	SWITCH_SEVEN SWITCH_EIGHT
	SWITCH_NINE SWITCH_TEN DOT_ON DOT_OFF URL_HTTP URL_HTTPS 

%%
program: stmt_list 
       {printf("Input program is valid\n");
	return 0;}
;

comment_stmt: COMMENT_OP
;

stmt_list: stmt | stmt stmt_list;

stmt: IF LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ k ELSE LEFT_SQ stmt_list RIGHT_SQ
    | IF LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ ELSE LEFT_SQ stmt_list RIGHT_SQ
    | IF LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ
    | non_if
    ;

k: ELSE_IF LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ | ELSE_IF LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ k;
loop_stmt: five_stmt | white_stmt
;

five_stmt: FIVE_LP LEFT_PRNTH assign_stmt boolean_expr SC IDENTIFIER ASSIGN_OP arithmetic_expr RIGHT_PRNTH
	 LEFT_SQ stmt_list RIGHT_SQ
;

white_stmt: WHITE_LP LEFT_PRNTH boolean_expr RIGHT_PRNTH LEFT_SQ 
	  stmt_list RIGHT_SQ
;

non_if: declaration_stmt 
      | assign_stmt 
      | loop_stmt 
      | function_def_stmt
      | function_call_stmt
      | input_stmt 
      | return_stmt 
      | output_stmt  
      | array_declare_stmt 
      | array_assign_stmt 
      | comment_stmt
      | switch_set_stmt
      | conn_send_stmt 
      | conn_declaration_stmt;

url: URL_HTTP | URL_HTTPS;

conn_declaration_stmt: CONNECTION_KEYWORD ASSIGN_OP CONNECTION_CREATE LEFT_PRNTH url RIGHT_PRNTH SC;

conn_read_stmt: CONNECTION_READ LEFT_PRNTH RIGHT_PRNTH ;

conn_send_stmt: CONNECTION_SEND LEFT_PRNTH IDENTIFIER RIGHT_PRNTH SC 
              | CONNECTION_SEND LEFT_PRNTH const RIGHT_PRNTH SC 
              ;

switch_set_stmt: switch_type turning LEFT_PRNTH RIGHT_PRNTH SC;

turning: DOT_ON | DOT_OFF;

switch_type: SWITCH_LIGHTS
           | SWITCH_HEATER
           | SWITCH_AIR_CONDITIONER
           | SWITCH_FOUR
           | SWITCH_FIVE
           | SWITCH_SIX
           | SWITCH_SEVEN
           | SWITCH_EIGHT
           | SWITCH_NINE
           | SWITCH_TEN
           ;



timer_expr: GET_YEAR LEFT_PRNTH RIGHT_PRNTH
	  | GET_MONTH LEFT_PRNTH RIGHT_PRNTH 
	  | GET_DAY LEFT_PRNTH RIGHT_PRNTH 
	  | GET_HOUR LEFT_PRNTH RIGHT_PRNTH 
	  | GET_MINUTE LEFT_PRNTH RIGHT_PRNTH 
	  | GET_SECOND LEFT_PRNTH RIGHT_PRNTH 
	  | GET_FULL LEFT_PRNTH RIGHT_PRNTH ;


sensor_expr:  SENSOR_KEYWORD_DOT sensor_type LEFT_PRNTH RIGHT_PRNTH;

sensor_type: TEMPERATURE_KEYWORD | HUMIDITY_KEYWORD | AIR_PRESSURE | AIR_QUALITY | LIGHT | SOUND_LEVEL ;


function_def_stmt: VOID_KEYWORD IDENTIFIER LEFT_PRNTH DEC_KEYWORD ident_list RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ 
                 | INT_KEYWORD IDENTIFIER LEFT_PRNTH DEC_KEYWORD ident_list RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ 
                 | VOID_KEYWORD IDENTIFIER LEFT_PRNTH RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ 
                 | INT_KEYWORD IDENTIFIER LEFT_PRNTH RIGHT_PRNTH LEFT_SQ stmt_list RIGHT_SQ 

;

function_call_stmt: IDENTIFIER LEFT_PRNTH ident_list RIGHT_PRNTH SC 
                  | IDENTIFIER LEFT_PRNTH RIGHT_PRNTH SC
;

input_stmt: SCAN_KEYWORD INPUT_OP IDENTIFIER SC 
;

return_stmt: RETURN_KEYWORD IDENTIFIER SC 
           | RETURN_KEYWORD const SC
;

array_declare_stmt: DEC_KEYWORD IDENTIFIER LEFT_CURLY positive_const RIGHT_CURLY SC
;

array_assign_stmt: DEC_KEYWORD IDENTIFIER LEFT_CURLY RIGHT_CURLY ASSIGN_OP LEFT_SQ mixed_list RIGHT_SQ SC 
		 | IDENTIFIER LEFT_CURLY positive_const RIGHT_CURLY ASSIGN_OP arithmetic_expr SC
;

output_stmt: OUT_KEYWORD LEFT_PRNTH STRING RIGHT_PRNTH SC 
	   | OUT_KEYWORD LEFT_PRNTH IDENTIFIER RIGHT_PRNTH SC 
	   | OUTLN_KEYWORD LEFT_PRNTH STRING RIGHT_PRNTH SC
	   | OUTLN_KEYWORD LEFT_PRNTH IDENTIFIER RIGHT_PRNTH SC
;

assign_stmt: DEC_KEYWORD IDENTIFIER ASSIGN_OP expr SC 
	   | IDENTIFIER ASSIGN_OP expr SC 
;

declaration_stmt: DEC_KEYWORD ident_list SC
;

expr: arithmetic_expr | boolean_expr
;

arithmetic_expr: arithmetic_expr PLUS_OP mult_expr | arithmetic_expr MINUS_OP mult_expr | mult_expr
;

mult_expr: mult_expr MULT_OP expo_term | mult_expr DIV_OP expo_term |
mult_expr MOD_OP expo_term | expo_term
;
expo_term: expo_term EXP_OP term | term
;
term: LEFT_PRNTH arithmetic_expr RIGHT_PRNTH | IDENTIFIER | const | IDENTIFIER LEFT_CURLY positive_const RIGHT_CURLY | IDENTIFIER LEFT_CURLY IDENTIFIER RIGHT_CURLY | IDENTIFIER LEFT_PRNTH ident_list RIGHT_PRNTH | IDENTIFIER LEFT_PRNTH RIGHT_PRNTH | timer_expr |conn_read_stmt|sensor_expr
;

boolean_expr: boolean_expr OR bool_expo | bool_expo 
	;
bool_expo: bool_expo AND bool_term | bool_term
	;
bool_term: LEFT_PRNTH boolean_expr RIGHT_PRNTH | comparison_expr
	;
comparison_expr: arithmetic_expr comp_operator arithmetic_expr
	;

ident_list: IDENTIFIER 
          | IDENTIFIER COMMA ident_list
	  ;
comp_operator: BIG_OP 
             | BIG_OR_EQ_OP 
             | LESS_OR_EQ_OP 
             | LESS_OP 
	     | EQUALITY_OP
             | NOT_EQ_OP
	     ;
mixed_list: const 
          | IDENTIFIER 
          | const COMMA mixed_list 
	  | IDENTIFIER COMMA mixed_list 
	  ;

positive_const: CONST 
              | PLUS_OP CONST		
	      ;

negative_const: MINUS_OP CONST 
;

const: positive_const 
     | negative_const 
     | ZERO
;


%%

#include "lex.yy.c"
int lineNumber = 1;
void yyerror(char* s) {printf("Syntax error on line %d!\n", lineNumber);}
int main() {
	return yyparse();
}
