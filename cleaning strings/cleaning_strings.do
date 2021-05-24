* Cleaning strings
********************************************************************************
/*
	LITTLE DICTIONARY ON STATA REGULAR EXPRESSION USEFUL TO HANDLE STRING VARIABLES

	Counting
	*	Asterisk means “match zero or more” of the preceding expression.
	+	Plus sign means “match one or more” of the preceding expression.
	?	Question mark means “match either zero or one” of the preceding expression.
	
	Characters
	a–z	The dash operator means “match a range of characters or numbers”. The “a” and “z” are merely an example. It could also be 0–9, 5–8, F–M, etc.
	.	Period means “match any character”.
	/	A backslash is used as an escape character to match characters that would otherwise be interpreted as a regular-expression operator.
	
	Anchors
	^	When placed at the beginning of a regular expression, the caret means “match expression at beginning of string”. This character can be thought of as an “anchor” character since it does not directly match a character, only the location of the match.
	$	When the dollar sign is placed at the end of a regular expression, it means “match expression at end of string”. This is the other anchor character.
	
	Groups
	|	The pipe character signifies a logical “or” that is often used in character sets (see square brackets below).
	[ ]	Square brackets denote a set of allowable characters/expressions to use in matching, such as [a-zA-Z0-9] for all alphanumeric characters.
	( )	Parentheses must match and denote a subexpression group.
*/
	* Examples
	
	* Generate a variable that takes the last value of a string variable in case it is a number
	
	gen lastnum = regexs(1) if regexm(var,"([0-9]+)$")
	
	* Generate a variable that takes the last value of a string variable in case it is NOT number
	
	gen lastnum = regexs(1) if regexm(var,"([0-9]+)$") == 0
	
	* Generate a variable that takes the last value of a string variable in case it is a number
	
	gen firstnum = regexs(1) if regexm(v1, "^([0-9]+)")
	
	* Generate a variable that takes the last value of a string variable in case it is NOT number
	
	gen firstnum = regexs(1) if regexm(v1, "^([0-9]+)") == 0
	
*** Split

/*   You have a string variable, and you want to separate the content
 	 of that based on a symbol (might come handy with dates, when you 
	 have 
*/	
	
	split nvar, parse("-")

*** Substr

/* 
	You want to extract a portion of a variable to replace the variable itself
	or generate a new variable
	
	gen var2_abbr = substr(var,startpos,nchar)
	
	gives you the substring of var, starting at startpos, for a length of nchar
	
	N.B. if you want to start substringing from the right, you have to put a -
	in front of startpos, e.g. if you wnat to extract the last 4 digit of a variable:
	
	gen var2_abbr = substr(var,-4,4)
	
*/
	
	sysuse census, clear
	
	gen state3 = substr(state,1,2)
	
*** Strpos
/* 
	strpos returns a number that is the position of a character in a string
	useful to use in combination with susbtr if, for example, if we want to
	substitute a variable up to a certain point.

*/
	
	gen state_clean = substr(state3,1,strpos(state3,".")-1)
	replace state_clean=state3 if missing(state_clean)
	
	* N.B. strpos is case sensitive!
	
*** Subinstr

/* 
	subinstr substitute a string with another one or with nothing (""). For 
	example, let's say we want to get rid of all the a in state
	
	Syntax:
	subinstr(var,"stringtosubstitute","newstring",noccur)
	
	where noccur is the number of ways you want stata to substitute your stringtosubstitute with newstring
	
	N.B. subinstr is case sensitive!
	
*/
	
	replace state=subinstr(state,"a","",.) // replaced all the lowercase a	
	
	
