#include <string>
#include <algorithm>
#include <cctype>

#ifndef INSTRUMENT_H
#define INSTRUMENT_H

class Instrument
{
public:
    Instrument(std::string const& name, std::string const& currency, std::string const& issuer);
    std::string get_name() const;
    std::string get_currency() const;
    std::string get_issuer() const;

private:
    std::string name;
    std::string currency;
    std::string issuer;
};
bool operator==(Instrument const &left, Instrument const &right);
#endif
