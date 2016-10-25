#include <string>

class stackType{
	public:
		//constructor
		stackType(){	//Constructor member
			APPENDSTRING = "";
			VALUE = "";
			VARNAME = "";
			RESULT = "";
			RETURN = "";
			RETURN2= "";
			ISLITERAL = false;
			ARG1 = "R0";
			ARG2 = "R0";
			ARG3 = "R0";
			ARG4 = "R0";	//Function argument register strings
			AL1 = false;
			AL2 = false;
			AL3 = false;
			AL4 = false;	//Function argument literal bools
			AN1 = "";
			AN2 = "";
			AN3 = "";
			AN4 = "";		//Function argument name strings

		}
		int INT;
		float FLOAT;
		double DOUBLE;
		long LONG;
		short SHORT;
		char CHAR;
		bool ISLITERAL;
		std::string STRING;	//This contains a code string to be output
		//at toplevel.. I think. Gotta check. Hnnng.
		std::string APPENDSTRING; //contains stuff to be printed
								//between functions - used primarily
								//for the printf function
		std::string VARNAME;
		std::string VARTYPE;
		std::string VALUE;
		std::string RESULT;
		std::string RETURN;
		std::string RETURN2;
		
		std::string ARG1;
		std::string ARG2;
		std::string ARG3;
		std::string ARG4;

		bool AL1;
		bool AL2;
		bool AL3;
		bool AL4;

		std::string AN1;
		std::string AN2;
		std::string AN3;
		std::string AN4;
};
	
