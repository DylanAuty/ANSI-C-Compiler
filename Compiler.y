%baseclass-preinclude stackType.h
%token NUM NAME DECIMAL CHAR STRING
%token INT FLOAT DOUBLE LONG VOID SHORT
%token COMMA LRB RRB LCB RCB LSB RSB INVCOMMA SEMICOLON
%token ADDOP MINUSOP DIVOP MULTOP
%token COMPEQUALS LESSTHAN MORETHAN
%token PLUSPLUS MINUSMINUS
%token EQUALS PLUSEQUALS MINUSEQUALS
%token RETURN PRINTF IF WHILE FOR

%stype stackType

%%
file		: topLevel file
	  		| topLevel
			;

topLevel	: declare declFunctdefAssign {
				if($2.RETURN == "decl"){
		 			//reserve register, tie to name and type
					//std::cout <<"RESERVING R" << regNum << std::endl;
				}
				else if($2.RETURN == "decAssign"){
					int regNum = chooseReg($1.VARNAME, $1.VARTYPE);
					if($2.ISLITERAL == true){
						std::cout << "MOV R" << regNum << ", " << $2.VALUE << std::endl;
					}
					else{
						std::cout << "MOV R" << regNum << ", " << $2.RETURN2 << std::endl;
					}
					//Now nuke the temp registers
					clearTempRegs();
					//reserve reg
					//now output code
				}
				else if($2.RETURN == "functDef"){
					//Spit out function name, then code
					//std::cout<<$1.VARNAME <<": "<<std::endl;
					//std::cout << $2.STRING << std::endl;
				}

			}
			;
		 
declFunctdefAssign:	
			SEMICOLON {
		 		//declaration only, 'type name;'
				$$.RETURN = "decl";
				}
		 	| decAssign SEMICOLON {
				//"<type> <name> = <value>;"
				$$.RETURN = "decAssign";
				$$.VALUE = $1.VALUE;
				$$.ISLITERAL = $1.ISLITERAL;
				$$.RETURN2 = $1.RETURN2;
				}
			| functDef {
				//"<type> <name>(<arguments>){BLOCK OF CODE}
				$$.RETURN = "functDef";
				std::cout << "POP\t{pc}" << std::endl <<std::endl;
		 		clearRegNames();
				}
			;

functDef	: LRB {
		 		clearRegNames();
		 		} argumentList RRB {
		 		std::cout << "\n" <<  functName << ": \nPUSH\t{lr}" << std::endl;
				int i;
				int j;
				//For each of the 4 possible arguments
				for(i = 5; i < 15; i++){
					//find the argument spaces
					//move the arguments into them
					if($3.ARG1 != "R0" && regName[i] == $3.ARG1){
						std::cout << "MOV R" << i << ", R1" << std::endl;
					}
					if($3.ARG2 != "R0" && regName[i] == $3.ARG2){
						std::cout << "MOV R" << i << ", R2" << std::endl;
					}
					if($3.ARG3 != "R0" && regName[i] == $3.ARG3){
						std::cout << "MOV R" << i << ", R3" << std::endl;
					}
					if($3.ARG4 != "R0" && regName[i] == $3.ARG4){
						std::cout << "MOV R" << i << ", R4" << std::endl;
					}
				}
				argNum = 0;
				} block {
				
				$$.APPENDSTRING = $6.APPENDSTRING;
				clearRegNames();
				}
			;

block		: LCB statementList RCB {
	   			$$.APPENDSTRING = $2.APPENDSTRING;
				
				}
	   		;

statementList:
			statement {$$.APPENDSTRING = $1.APPENDSTRING;}
			| statementList statement {
				$$.APPENDSTRING = $1.APPENDSTRING + $2.APPENDSTRING;
				}
			;

functCall	: name LRB argumentList RRB	{
				std::cout << "PUSH {R5-R12}" << std::endl;	//save the registers of the current scope
				//If the argument is literal, then print $3.ARG1 (contains #n)
				//If not then find the reg associated with the variable name, and move it to the correct scratch register
				if($3.AL1 == true){
					std::cout << "MOV R1, " << $3.ARG1 << std::endl;
				}
				else{
					int i;
					int found = 0; //set to 1 when the variable is found in the registers
					for(i = 5; i < 15; i++){
						if(regName[i] == $3.ARG1 && $3.ARG1 != "R0"){
							//register found
							std::cout << "MOV R1, R" << i << std::endl;
							found = 1;
						}
					}
					if(i == 15 && $3.ARG1 != "R0" && found == 0){
						//Error - variable not declared
						std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $3.ARG1 <<"' not declared in this scope" << std::endl;
						exit(1);
					}
				}
				if($3.AL2 == true){
					std::cout << "MOV R2, " << $3.ARG2 << std::endl;
				}
				else{
					int i;
					int found = 0;
					for(i = 5; i < 15; i++){
						if(regName[i] == $3.ARG2 && $3.ARG2 != "R0"){
							//register found
							std::cout << "MOV R2, R" << i << std::endl;
							found = 1;
						}
					}
					if(i == 15 && $3.ARG2 != "R0" && found == 0){
						//Error - variable not declared
						std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $3.ARG2 <<"' not declared in this scope" << std::endl;
						exit(1);
					}
				}

				if($3.AL3 == true){
					std::cout << "MOV R3, " << $3.ARG3 << std::endl;
				}
				else{
					int i;
					int found = 0;
					for(i = 5; i < 15; i++){
						if(regName[i] == $3.ARG3 && $3.ARG3 != "R0"){
							//register found
							std::cout << "MOV R3, R" << i << std::endl;
							found = 1;
						}
					}
					if(i == 15 && $3.ARG3 != "R0" && found == 0){
						//Error - variable not declared
						std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $3.ARG3 <<"' not declared in this scope" << std::endl;
						exit(1);
					}
				}

				if($3.AL4 == true){
					std::cout << "MOV R4, " << $3.ARG4 << std::endl;
				}
				
				else{
					int i;
					int found = 0;
					for(i = 5; i < 15; i++){
						if(regName[i] == $3.ARG4 && $3.ARG4 != "R0"){
							//register found
							std::cout << "MOV R4, R" << i << std::endl;
							found = 1;
						}
					}
					if(i == 15 && $3.ARG4 != "R0" && found == 0){
						//Error - variable not declared
						std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $3.ARG4 <<"' not declared in this scope" << std::endl;
						exit(1);
					}
				}
		  		
				std::cout << "BL " << $1.STRING << std::endl;	//Branch and link to the function
				std::cout << "POP {R5-R12}" << std::endl;		//return the registers from the stack for use in the current function
				}
			;
			
statement	: declare declFunctdefAssign {
		  		if($2.RETURN == "decl"){
				}
				else if($2.RETURN == "decAssign"){
					int regNum = chooseReg($1.VARNAME, $1.VARTYPE);	//Reserve a register; tie to a type and a name
					std::cout << "MOV R" << regNum << ", " << $2.RETURN2 << std::endl;
				}
				else if($2.RETURN == "functDef"){
					//ERROR HERE - function definitions not allowed inside another function
					std::cerr << "ERROR: Line " << lexer.lineno() << ": Cannot declare function " << $1.VARNAME << " inside a function" << std::endl;
					exit(1);
				}
			}
			| IF LRB {
					std::cout << "ifBlock" << ifNum << ": " << std::endl;	//Label the if statement
					}
					boolExpr {	//boolExpr is meant to do the requisite comparing
						std::cout << $4.STRING << std::endl;
						//If the requisite condition is NOT met, then branch to the END of the IF loop
						if($4.RETURN == "COMPEQUALS"){
							std::cout << "BNE aIfBlock" << ifNum << std::endl;
							//for == - skip block if NOT equal
						}
					}
					RRB block {
					std::cout << "aIfBlock" << ifNum << ":\t" << std::endl;	//Label the end of the if block
					//aIfBlockn is branched to if the condition is NOT met
					//It is printed after all the code from the block
						ifNum++;	//Increment ifNum so that no two if blocks have identical labels
				}

		  	| PRINTF LRB string COMMA name RRB SEMICOLON{
				//Push R0-R4 onto the stack
				//Find register with name "name"
				//load whatever's in there into R1
				//print "bl printf"
				//Pop R0-R4 off the stack
				//set APPENDSTRING
				
				std::cout << "PUSH\t{R0-R4}" << std::endl;	//Push R0-R4 onto the stack

				//Find the variable reg
				int i;
				int found = 0;
				for(i = 5; i<15; i++){
					if(regName[i] == $5.STRING){
						std::cout<< "MOV R1, R" << i <<std::endl;
						found = 1;
					break;
					}
				}
				if(i == 15 && found == 0){
					//Error handling
					std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $5.STRING << "' not declared in this scope" << std::endl;
					exit(1);
				}
				//Generate and assemble the inline code
				std::string temp1 = "LDR R0, =message";
				std::string temp2 = convert<std::string>(msgNum);
				std::cout << temp1 << temp2 << std::endl;
				std::cout << "BL printf" << std::endl;
				std::cout << "POP\t{R0-R4}" << std::endl;

				//Generate and assemble code to be appended
				temp1 = "message";
				temp1 = temp1 + temp2;	//temp2 contains msgNum as string
				temp2 = ":\n";
				temp1 = temp1 + temp2;
				temp2 = ".asciz ";
				temp1 = temp1 + temp2;
				temp2 = $3.STRING;
				temp1 = temp1 + temp2;
				temp2 = "\n";

				printfStream << temp1+temp2 << std::endl; //Output to printfStream, which gets appended to the output by the destructor
				msgNum++;		//Increment msgNum so no 2 labels will be identical
				}
			| name unaryop SEMICOLON{	//Handles unary statements - e.g. i++.
				int i;
				int found = 0;
				for(i = 5; i < 15; i++){
					if(regName[i] == $1.STRING){
						found = 1;
						if($2.RETURN == "PLUSPLUS"){
							std::cout << "ADD R" << i << ", R" << i << ", #1" << std::endl;
						}
						else if($2.RETURN == "MINUSMINUS"){
							std::cout << "SUB R" << i << ", R" << i << ", #1" << std::endl;
						}
						break;
					}
				}
				if(i == 15 && found == 0){
					//variable not found
					std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $1.STRING << "' not declared in this scope" << std::endl;
					exit(1);
				}
				}	
			| expression SEMICOLON
			| WHILE LRB {
				//Label the while loop
				std::cout << "\nwhile" << whileNum << ": " << std::endl;
				}
				boolExpr RRB block {
					//appends the branch and comparisons to the end of the block code
					//If the condition is met then branch to the start of the while loop
					std::cout << $4.STRING << std::endl;
					if($4.RETURN == "COMPEQUALS"){
						std::cout << "BEQ while" << whileNum << std::endl;
					}
					if($4.RETURN == "LESSTHAN"){
						std::cout << "BLT while" << whileNum << std::endl;
					}
					std::cout << std::endl;
					whileNum++;
				}
			| FOR LRB statement {
				std::cout << "\nfor"<< forNum << ": "<< std::endl;	//Label the for loop
				}
				boolExpr
				SEMICOLON 
				name unaryop 
				RRB block {
					int i;
					int found = 0;
					for(i = 5; i < 15; i++){
						if(regName[i] == $7.STRING){
							found = 1;
							if($8.RETURN == "PLUSPLUS"){
								std::cout << "ADD R" << i << ", R" << i << ", #1" << std::endl;
							}
							else if($8.RETURN == "MINUSMINUS"){
								std::cout << "SUB R" << i << ", R" << i << ", #1" << std::endl;
							}
							break;
						}
					}
					if(i == 15 && found == 0){
						//Error - variable not found
						std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $7.STRING << "' not declared in current scope" << std::endl;
						exit(1);
					}

					std::cout << $5.STRING << std::endl; //output the correct compare statement from the boolean condition expression
					//Branching to start of for loop occurs on the requisite conditions:
					if($5.RETURN == "COMPEQUALS"){
							std::cout << "BEQ for" << forNum << std::endl;
					}
					if($5.RETURN == "LESSTHAN"){
						std::cout << "BLT for" << forNum << std::endl;
					}
					std::cout << std::endl;

				}
			| RETURN exprSub SEMICOLON {
				//exprSub returns either a register name or a literal
				//it also returns $2.ISLITERAL to say if it's literal
				//Now we need to put it into R0 (R0 is used exclusively for function returns and printf), then pop to return.
				std::cout << "MOV R0, " << $2.RETURN << std::endl;
				std::cout << "POP {pc}" << std::endl;
				}
			| RETURN SEMICOLON {
				std::cout << "POP {pc}" << std::endl;
				}
			;

boolExpr	: exprSub comparisonOp exprSub {	//This will return a string containing the correct compare statement
		 		std::string temp1 = "CMP ";
				std::string temp2 = $1.RETURN;
				std::string temp3 = ", ";
				std::string temp4 = $3.RETURN;

				$$.STRING = temp1 + temp2 + temp3 + temp4;
				$$.RETURN = $2.RETURN;
				}
			;

comparisonOp: COMPEQUALS {$$.RETURN = "COMPEQUALS";}
			| LESSTHAN	{$$.RETURN = "LESSTHAN";}
			;

expression	: value /*Technically this is allowed*/
		    | name assign exprSub {
				//return from exprSub is Rn, containing result of expression
				//fetch name register, throw error if nonexistant
				int j;
				int found = 0;
				for (j = 5; j < 15; j++){
					if ($1.STRING == regName[j]){
						found = 1;
						if($2.CHAR == '='){
							std::cout << "MOV R" << j << ", " <<$3.RETURN << std::endl;
						}
						break;
					}
				}
				if (j == 15 && found == 0){
					//at this point we need to throw an error
					std::cerr << "ERROR: Line " << lexer.lineno() <<  ": Variable '" << $1.STRING <<"' not declared in this scope" << std::endl;
				}
				}
			;

exprSub		: term	{
		 		$$.RETURN = $1.RETURN;
		 		$$.ISLITERAL = $1.ISLITERAL;
				$$.VALUE = $1.VALUE;
				}
		 	| exprSub ADDOP term	{
				std::string tempString = $1.RETURN;
				int regNum = chooseReg("temp", "int");
				//The literal must be put into a reg for manipulation
				//Construct the string containing the result register
				tempString = "R";
				std::string temp2 = convert<std::string>(regNum);
				tempString = tempString + temp2;
				if($1.ISLITERAL == true){
					std::cout << "MOV R" << regNum << ", " << $1.RETURN << std::endl;
				} //This handles literal values
				std::cout << "ADD " << tempString << ", " << $1.RETURN << ", " << $3.RETURN << std::endl;
				$$.RETURN = tempString;
				}
			| exprSub MINUSOP term	{
				std::string tempString = $1.RETURN;
				if($1.ISLITERAL == true){
					int regNum = chooseReg("temp", "int");
					std::cout << "MOV R" << regNum << ", " << $1.RETURN << std::endl;
					tempString = "R";
					std::string temp2 = convert<std::string>(regNum);
					tempString = tempString + temp2;
				}
				std::cout << "SUBS " << tempString << ", " << $1.RETURN << ", " << $3.RETURN << std::endl;
				$$.RETURN = tempString;
				}
			| functCall {
				$$.RETURN = "R0"; //function calls always store the return value in R0
				}
			;

term		: term MULTOP factor {
	  			std::cout << "MULS" << $1.RETURN << ", " << $1.RETURN << ", " << $3.RETURN << std::endl;
				$$.RETURN = $1.RETURN;
				$$.VALUE = $1.VALUE;
				$$.ISLITERAL = $1.ISLITERAL;
				}
			| factor	{
				$$.RETURN = $1.RETURN;
				$$.VALUE = $1.VALUE;
				$$.ISLITERAL = $1.ISLITERAL;
				}
			;

factor		: LRB exprSub RRB	{
				$$.RETURN = $2.RETURN;
				}
			| value				{	
				$$.RETURN = $1.VALUE;	//Pass the result register up the tree
				$$.VALUE = $1.VALUE;
				$$.ISLITERAL = $1.ISLITERAL;
				}
			| name		{
				int i;
				int found = 0;
				for(i = 5; i < 15; i++){
					if(regName[i] == $1.STRING){
						found = 1;
						std::string temp1 = "R";
						std::string temp2 = convert<std::string>(i);
						$$.RETURN = temp1 + temp2;
						break;
					}
				}
				if(i == 15 && found == 0){
					//throw error
					std::cerr << "ERROR: Line " << lexer.lineno() << ": Variable '" << $1.STRING << "' not declared in this scope" << std::endl;
					exit(1);
				}
				}
			;

unaryop		: PLUSPLUS	{$$.RETURN = "PLUSPLUS";}
		 	| MINUSMINUS {$$.RETURN = "MINUSMINUS";}
			;

argumentList: argument {	
				$$.ARG1 = $1.ARG1;
				$$.AL1 = $1.AL1;
				$$.ARG2 = $1.ARG2;
				$$.AL2 = $1.AL2;
				$$.ARG3 = $1.ARG3;
				$$.AL3 = $1.AL3;
				$$.ARG4 = $1.ARG4;
				$$.AL4 = $1.AL4;

				regName[1] = $1.AN1;
				regName[2] = $1.AN2;
				regName[3] = $1.AN3;
				regName[4] = $1.AN4;	//This code is to set up arguments into R1-R4 for passing to functions
				}/*
			| argument COMMA argumentList{

				$$.ARG1 = $3.ARG1;
				$$.AL1 = $3.AL1;
				$$.ARG2 = $3.ARG2;
				$$.AL2 = $3.AL2;
				$$.ARG3 = $3.ARG3;
				$$.AL3 = $3.AL3;
				$$.ARG4 = $3.ARG4;
				$$.AL4 = $3.AL4;
				
				}*/
			;

argument	: /*No argument*/
		 	| keyword name	{/*Handles the form "int <varName>"*/
				int regNum = chooseReg($2.STRING, "int");
				if(argNum == 0){
					$$.ARG1 = $2.STRING;
					$$.AN1 = $2.STRING;
				}
				else if(argNum == 1){
					$$.ARG2 = $2.STRING;
					$$.AN2 = $2.STRING;
				}
				else if(argNum == 2){
					$$.ARG3 = $2.STRING;
					$$.AN3 = $2.STRING;
				}
				else if(argNum == 3){
					$$.ARG4 = $2.STRING;
					$$.AN4 = $2.STRING;
				}

				argNum++;
				}
		 	| name {
				if(argNum == 0){
					$$.ARG1 = $1.STRING;
					$$.AN1 = $1.STRING;
				}
				else if(argNum == 1){
					$$.ARG2 = $1.STRING;
					$$.AN2 = $1.STRING;
				}
				else if(argNum == 2){
					$$.ARG3 = $1.STRING;
					$$.AN3 = $1.STRING;
				}
				else if(argNum == 3){
					$$.AN4 = $1.STRING;
					$$.ARG4 = $1.STRING;
				}
				argNum++;
				}
			| value {	
				if(argNum == 0){
					$$.ARG1 = $1.VALUE;
					$$.AL1 = $1.ISLITERAL;
				}
				else if(argNum == 1){
					$$.ARG2 = $1.VALUE;
					$$.AL2 = $1.ISLITERAL;
				}
				else if(argNum == 2){
					$$.ARG3 = $1.VALUE;
					$$.AL3 = $1.ISLITERAL;
				}
				else if(argNum == 3){
					$$.ARG4 = $1.VALUE;
					$$.AL4 = $1.ISLITERAL;
				}

				argNum++;
				}
			;

decAssign	: assign exprSub {
				$$.RETURN2 = $2.RETURN;
				$$.VALUE = $2.VALUE;
				$$.ISLITERAL = $2.ISLITERAL;
			}
			;

declare		: keyword nameList {
				functName = $2.STRING;
				}
			;

nameList	: name	{	//Allows lists of names
				int regNum = chooseReg($1.STRING, $1.VARTYPE);	//names are allocated a register as they're found
			}
		  	| name COMMA nameList {
				int regNum = chooseReg($1.STRING, $1.VARTYPE);
				}
			;

name		: NAME	{	//Returns the name token as a string
	  			$$.STRING = convert<std::string>(lexer.YYText());
				}
	  		;

assign		: EQUALS	{$$.CHAR = convert<char>(lexer.YYText());}
			/*MTC: +=, -= etc.*/
			;

keyword		: INT	{$$.STRING = convert<std::string>(lexer.YYText());}
		 	;

string		: STRING {$$.STRING = convert<std::string>(lexer.YYText());}
			;

value		: NUM	{//Creates a string for literal values and returns it to above
	   			std::string a = "#"; 
	   			std::string b = (convert<std::string>(lexer.YYText()));
	   			$$.VARTYPE = "int";
				$$.VALUE = a + b;
				$$.ISLITERAL = true;
				}
	   		;

