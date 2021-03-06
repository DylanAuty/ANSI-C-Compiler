// Generated by Bisonc++ V2.09.03 on Wed, 12 Mar 2014 16:18:40 +0000

#ifndef Parser_h_included
#define Parser_h_included

// $insert baseclass
#include "Parserbase.h"

//USER INSERTED
#include <FlexLexer.h>
#include "Util.h"
#include <string>
#include <iostream>
#include <sstream>
#include <fstream>
#include <cstdlib>

#undef Parser

class Parser: public ParserBase
{
        
    public:
		Parser(){	//Constructor
			ifStatementStream.open("ifStatementStream.txt");
			if(!ifStatementStream.is_open()){
				std::cout << "ERROR IN IF CLAUSE: COULD NOT OPEN INTERMEDIATE STREAM" << std::endl;
				exit(1);
			}
			printfStream.open("printfStream.txt");
			if(!printfStream.is_open()){
				std::cout << "ERROR IN PRINTF: COULD NOT OPEN INTERMEDIATE STREAM" << std::endl;
				exit(1);
			}
			msgNum = 0;
			ifNum = 0;
			whileNum = 0;
			forNum = 0;
			argNum = 0;
		}

		~Parser(){	//Destructor
			//close both ofstreams - printfStream, ifStatementStream
			//open tempStream with ifStatementStream.txt
			printfStream.close();
			ifStatementStream.close();
			tempStream.open("ifStatementStream.txt");
			if(!tempStream.is_open()){
				std::cout << "ERROR: could not open append string" << std::endl;
				exit(1);
			}
			while(getline(tempStream, tempString)){
				std::cout << tempString << std::endl;
			}
			tempStream.close();
			//now do the same thing with printfStream.txt
			std::cout << ".data" << std::endl;
			tempStream1.open("printfStream.txt");
			if(!tempStream1.is_open()){
				std::cout << "ERROR: could not open append string (1)" << std::endl;
				exit(1);
			}
			while(getline(tempStream1, tempString)){
				std::cout << tempString << std::endl;
			}
			tempStream1.close();
		}
		
		std::ofstream printfStream;
		std::ofstream ifStatementStream;
		std::stringstream appendStream;
		std::ifstream tempStream;
		std::ifstream tempStream1;
		std::string tempString;
		int parse();
		bool regFree[16];			//Stores the writeable/filled state of the regs
		std::string regType[16];	//Stores stored data type for each reg
		std::string regName[16];	//Stores the name tied to a register
		std::string currType;		//Stores current working type of a declaration
		void initRegs();			//Sets up regFree properly
		std::string functName;		//To store the function name
		int msgNum;					//To store the message num for multiple printfs
		int ifNum;					//Store if statement label number for multiple/nested if statements
		int whileNum;				//Store while statement label
		int forNum;					//Stores for statement label
		void clearTempRegs();		//Nuke any registers called temp
		void clearRegNames();		//Erases all register naming data
		int argNum;					//used to pass arguments to functions

	private:
		
		yyFlexLexer lexer;
		int chooseReg(std::string name, std::string type);	//chooseReg allocates a name and a type provided to it to a given register

        void error(char const *msg);    // called on (syntax) errors
        int lex();                      // returns the next token from the
                                        // lexical scanner. 
        void print();                   // use, e.g., d_token, d_loc

    // support functions for parse():
        void executeAction(int ruleNr);
        void errorRecovery();
        int lookup(bool recovery);
        void nextToken();
};

inline void Parser::clearRegNames(){
	for (int i = 0; i < 15; i++){
		regName[i] = "";
		regType[i] = "";
	}
	initRegs();
}

inline void Parser::clearTempRegs(){
	for(int i = 0; i < 15; i++){
		if(regName[i] == "temp"){
			regName[i] = "";
			regType[i] = "";
			regFree[i] = 0;
		}
	}
}

inline void Parser::initRegs(){	//Says if a register is in use or not
	regFree[0] = 1;	//R0 is the return value for functions
	regFree[1] = 1;
	regFree[2] = 1;
	regFree[3] = 1;
	regFree[4] = 1; //R1-4 are used by function calls
	regFree[5] = 0;
	regFree[6] = 0;
	regFree[7] = 0;
	regFree[8] = 0;
	regFree[9] = 0;
	regFree[10] = 0;
	regFree[11] = 0;
	regFree[12] = 1;
	regFree[13] = 1;
	regFree[14] = 1;
	regFree[15] = 1;	//R12-R15 are in use by the processor - lr, pc, etc.

	msgNum = 0;
	return;
}

inline int Parser::chooseReg(std::string name, std::string type){	//picks a free register and assigns to it a name and type
	int i;
	for(i = 5; i < 15; i++){
		if(regFree[i] == 0){
			regFree[i] = 1;	//The register is now in use
			regName[i] = name;
			regType[i] = type;
		//	std::cout <<"\tRESERVING R" << i << " for " << name << std::endl;
			return i;
		}
	}
	//If the program reaches here then all registers were taken
	if(i == 15){
		std::cerr << "ERROR: Line " << lexer.lineno() << ": Not enough memory to declare variable '" << name << "'" << std::endl;
		exit(1);
	}
}


inline void Parser::error(char const *msg)
{
    std::cerr << msg << '\n';
}

// $insert lex
inline int Parser::lex(){
//	std::cerr << "\t\tTOKEN: "<< lexer.YYText() << std::endl;
	return lexer.yylex();
}

// $insert print
inline void Parser::print()
{}

#endif
