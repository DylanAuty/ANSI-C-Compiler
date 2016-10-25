Compiler: parse.o lex.yy.o Compiler.o
	g++ -o Compiler Compiler.o parse.o lex.yy.o

parse.o: parse.cc Parser.h
	g++ -c parse.cc

lex.yy.o: lex.yy.cc Parserbase.h
	g++ -c lex.yy.cc

Compiler.o: Compiler.cpp Parser.h Util.h
	g++ -c Compiler.cpp

Parserbase.h: parse.cc

parse.cc: Compiler.y stackType.h
	bisonc++ Compiler.y

lex.yy.cc: Compiler.l
	flex++ Compiler.l

# make clean

clean:
	rm -f lex.yy.cc parse.cc Parserbase.h Parser.ih *.o calc
