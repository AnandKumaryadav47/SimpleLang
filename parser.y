%{
#include <stdio.h>
#include <stdlib.h>

// Symbol table for single-letter variables like a, b, c, etc.
int sym[26];

// Declare the lexical analyzer and error handling functions
int yylex();
int yyerror(const char *s);
%}

/* Token declarations */
%token IDENTIFIER NUMBER ASSIGN PLUS IF ELSE EQ SEMICOLON LPAREN RPAREN

/* Operator precedence */
%left PLUS

/* Grammar rules */
%%
program:
    statement_list
    ;

statement_list:
    statement_list statement
    | statement
    ;

statement:
    assignment SEMICOLON
    | if_statement
    ;

assignment:
    IDENTIFIER ASSIGN expression { 
        sym[$1 - 'a'] = $3;  // Store the result in the symbol table
    }
    ;

expression:
    expression PLUS term { 
        $$ = $1 + $3;  // Addition
    }
    | term {
        $$ = $1;  // Single term
    }
    ;

term:
    IDENTIFIER { 
        $$ = sym[$1 - 'a'];  // Retrieve variable value from symbol table
    }
    | NUMBER { 
        $$ = $1;  // Number literal
    }
    ;

if_statement:
    IF LPAREN condition RPAREN statement ELSE statement
    ;

condition:
    expression EQ expression { 
        if ($1 == $3) 
            printf("YES\n");
        else 
            printf("NO\n");
    }
    ;

%%

/* Main function */
int main() {
    FILE *txtFile;
    FILE *cFile;
    char ch;

    // Open the .txt file containing the C program
    txtFile = fopen("program.txt", "r");
    if (txtFile == NULL) {
        printf("Error opening program.txt!\n");
        return 1;
    }

    // Create and open a .c file to write the code into
    cFile = fopen("temp_program.c", "w");
    if (cFile == NULL) {
        printf("Error creating temp_program.c!\n");
        fclose(txtFile);
        return 1;
    }

    // Copy the contents of the .txt file to the .c file
    while ((ch = fgetc(txtFile)) != EOF) {
        fputc(ch, cFile);
    }

    // Close the files
    fclose(txtFile);
    fclose(cFile);

    // Compile the temporary C file using the GCC command
    int compileStatus = system("gcc temp_program.c -o temp_program");
    if (compileStatus != 0) {
        printf("Compilation failed!\n");
        return 1;
    }

    // Run the compiled program
    printf("Running the program:\n");
    system("temp_program");
    yyparse();
    return 0;
}

/* Error handling */
int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return  0;
}
