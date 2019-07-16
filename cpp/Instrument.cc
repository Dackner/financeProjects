#include "Instrument.h"

using namespace std;

Instrument::Instrument(string const &name, string const &currency, string const &issuer) : name(name), currency(currency), issuer(issuer)
{
    //convert to upper case
    transform(this->name.begin(), this->name.end(), this->name.begin(), [](char &c) { return ::toupper(c); });
    transform(this->currency.begin(), this->currency.end(), this->currency.begin(), [](char &c) { return ::toupper(c); });
    transform(this->issuer.begin(), this->issuer.end(), this->issuer.begin(), [](char &c) { return ::toupper(c); });
}

string Instrument::get_name() const
{
    return name;
}

string Instrument::get_currency() const
{
    return currency;
}

string Instrument::get_issuer() const
{
    return issuer;
}

bool operator==(Instrument const &left, Instrument const &right)
{
    return left.get_name() == right.get_name() && left.get_currency() == right.get_currency() && left.get_issuer() == right.get_issuer();
}