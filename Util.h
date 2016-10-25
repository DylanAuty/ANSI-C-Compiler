#ifndef UTIL_H
#define UTIL_H

#include <sstream>
#include <string>

template<typename T, typename T2>
T convert(const T2& in){
	std::stringstream buf;
	buf << in;
	T result;
	buf >> result;
	return result;
}

#endif // UTIL_H
