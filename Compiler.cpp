#include <iostream>
#include "Parser.h"

using namespace std;

int main(){
	//All of this is necessary to be able to do function calls
	//without breaking the main or causing segfaults
	cout << ".global main" << endl;
	cout << "MOV R0, #1" << endl;
	cout << "MOV R1, #1" << endl;
	cout << "MOV R2, #1" << endl;
	cout << "MOV R3, #1" << endl;
	cout << "MOV R4, #1" << endl;
	cout << "PUSH {R0-R4}" << endl;

	Parser p;
	p.initRegs();	//Set initial read/write status of the regs
	p.parse();
	return 0;
}
