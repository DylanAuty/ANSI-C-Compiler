# ANSI C Compiler
This program is a compiler, intended to convert 
ANSI C code to ARM assembly code, to be run on a 
Raspberry Pi. An overview of the control and parsing
flow can be found in `Compilers Report.docx`. The 
core of the system is the grammar, found in `Compiler.y`.
Tokenization is performed in the manner outlined by 
`Compiler.l`.

## Design System Information
This program was designed and written using a
virtual machine using VirtualBox, hosted by 
MacOS 10.9 and running Ubuntu v.12.04 LTS 32 bit.
- `bisonc++` version	: `V2.09.03`
- `flex++` version	: `2.5.35`
- `gcc` version		: `4.6.3`


## Files
- `Compiler.cpp`
- `Compiler.l`
- `Compiler.y`
- `Parser.h`
- `stackType.h`
- `Util.h`
- `PreProcessor.cpp`
- `Makefile`
- `README`
- `Compilers Report.docx`


## Compilation Instructions
To compile the preprocessor:

`g++ PreProcessor.cpp -o PreProcessor -L/usr/lib/ -lboost_regex-mt`

To compile the compiler:

`make`

## Execution Instructions
### 1) The easy way:
A bash script is included in this folder, called `run`.
It will output to a file called `ASMOUT.s`, and takes
one argument - the file to be compiled.
To use:

`./run <filename>`

### 2) Manual running:

The compiler by default will output code to the terminal.
An input file must be run through the preprocessor first:

`./PreProcessor <filename> > preprocessed.txt`

The file `preprocessed.txt` must then be catted into the
compiler itself. The compiler will output code to the terminal
by default, so the output may be redirected into a file.

For terminal output:

`cat "preprocessed.txt" | ./Compiler`

For file output:

`cat "preprocessed.txt" | ./Compiler > output.s`


