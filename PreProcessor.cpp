//NB: COMPILATION COMMAND FOR THIS IS:
//g++ PreProcessor.cpp -o PreProcessor -L/usr/lib/ -lboost_regex-mt

#include <fstream>
#include <iostream>
#include <string>
#include <boost/regex.hpp>

using namespace std;

int main(int argc, char* argv[]){
	char* fileName;
	string inString;

	if(argc != 2){
		cout << "Invalid number of command line arguments" << endl;
		cout << "Correct format is: './Preprocessor <filename>'" << endl;
	}
	
	fileName = argv[1];
	ifstream inFile (fileName);
	if(!inFile.is_open()){
		cout << "ERROR: Could not open file for preprocessing" << endl;
		cout << "	Please check directories and arguments and try again" << endl;
		exit(1);
	}
	const boost::regex includes("^\\#[^\\n]*");
	const boost::regex inlineComments("//[^\\n]*");
	const boost::regex multLineComments("/\\*.*?\\*/");
	const boost::regex newLines("\n");
	while(getline(inFile, inString)){
		inString = boost::regex_replace(inString, includes, string(""), boost::match_default | boost::format_sed);
		inString = boost::regex_replace(inString, inlineComments, string(""), boost::match_default | boost::format_sed);
		inString = boost::regex_replace(inString, multLineComments, string(""), boost::match_default | boost::format_sed);
		inString = boost::regex_replace(inString, newLines, string(""), boost::match_default | boost::format_sed);
		cout << inString << endl;
	}
	return 0;
}


