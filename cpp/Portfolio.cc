#include "Portfolio.h"

using namespace std;

Portfolio::Portfolio(string const &name) : name(name)
{
    //convert to upper case
    transform(this->name.begin(), this->name.end(), this->name.begin(), [](char &c) { return ::toupper(c); });
}

string Portfolio::get_name() const
{
    return name;
}

void Portfolio::add_trade(Instrument const &instrument, double const &price, int const &quantity)
{
    int existing_idx{};
    if (instrument_in_portfolio(instrument, existing_idx))
    {
        //If the instrument is previously traded, update the position's quantity, and price
        Trade trade_old = trades[existing_idx];

        if (quantity == -trade_old.get_quantity()) {
            //If new quantity is 0, then the position is removed
            trades.erase(trades.begin() + existing_idx);
        }
        else {
            Trade trade_new{instrument, price, trade_old.get_quantity() + quantity};
            trades[existing_idx] = trade_new;
        }
    }
    else
    {
        Trade new_trade{instrument, price, quantity};
        trades.push_back(new_trade);
    }
}

bool Portfolio::instrument_in_portfolio(Instrument const &instrument, int &existing_idx)
{
    vector<Trade>::iterator it = find_if(trades.begin(), trades.end(), [instrument](Trade trade) {
        return trade.get_instrument() == instrument;
    });
    existing_idx = distance(trades.begin(), it);
    return it != trades.end();
}

void Portfolio::print_position_information(int &column_width) const
{
    cout << name << endl;
    for_each(trades.begin(), trades.end(), [&column_width](Trade trade) {
        cout << setw(column_width * 2) << trade.get_instrument().get_name() << setw(column_width)
             << trade.get_instrument().get_currency() << setw(column_width) << trade.get_quantity()
             << setw(column_width) << fixed << setprecision(2) << trade.get_price()
             << setw(column_width) << trade.get_price() * (double)trade.get_quantity() << endl;
    });
}

bool operator==(Portfolio const &left, Portfolio const &right)
{
    return left.get_name() == right.get_name();
}
