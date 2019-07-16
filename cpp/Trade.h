#include "Instrument.h"

#ifndef TRADE_H
#define TRADE_H

class Trade
{
public:
    Trade(Instrument const& instrument, double const& price, int const& quantity);
    Instrument get_instrument() const;
    double get_price() const;
    int get_quantity() const;

private:
    Instrument instrument;
    double price;
    int quantity;
};

#endif