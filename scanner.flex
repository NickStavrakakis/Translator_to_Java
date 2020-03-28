import java_cup.runtime.*;

%%

%class Scanner
%unicode
%cup
%line
%column

%{
	StringBuffer string = new StringBuffer();
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

LineTerminator	= \r|\n|\r\n
WhiteSpace	= {LineTerminator} | [ \t\f]
/* Identifier matches each string that starts with a character of class jletter followed
by zero or more characters of class jletterdigit. jletter and jletterdigit
are predefined character classes. jletter includes all characters for which the Java
function Character.isJavaIdentifierStart returns true and jletterdigit
all characters for that Character.isJavaIdentifierPart returns true. */
Identifier	= [:jletter:] [:jletterdigit:]*

//declares the lecixal state string
%state STRING

%%

<YYINITIAL> {
	","		{ return symbol(sym.COMMA); }
	"("		{ return symbol(sym.LPAREN); }
	")"		{ return symbol(sym.RPAREN); }
	"{"		{ return symbol(sym.LBRACK); }
	"}"		{ return symbol(sym.RBRACK); }
 	"+"		{ return symbol(sym.CONCAT); }
	"if"        	{ return symbol(sym.IF, yytext()); }
	"else"       	{ return symbol(sym.ELSE, yytext()); }
	"prefix"       	{ return symbol(sym.PREFIX, yytext()); }
	"reverse"      	{ return symbol(sym.REVERSE, yytext()); }
	\"		{ string.setLength(0); yybegin(STRING); } // resetting the buffer and knowing that we are about to read a string
	{Identifier} 	{ return symbol(sym.IDENTIFIER, yytext()); }
	{WhiteSpace}	{ /* ignore */ }
}

<STRING> {
	\"		{ yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); }
	[^\n\r\"\\]+	{ string.append( yytext() ); }
	\\t		{ string.append('\t'); }
	\\n		{ string.append('\n'); }
	\\r		{ string.append('\r'); }
	\\\"		{ string.append('\"'); }
	\\		{ string.append('\\'); }
}

[^]			{ throw new Error("Illegal character <"+yytext()+">"); }
