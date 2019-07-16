#include "Trade.h"

using namespace std;

Trade::Trade(Instrument const &instrument, double const &price, int const &quantity) : instrument(instrument), price(price), quantity(quantity) {}

Instrument Trade::get_instrument() const
{
    return instrument;
}

double Trade::get_price() const
{
    return price;
}

int Trade::get_quantity() const
{
    return quantity;
}
