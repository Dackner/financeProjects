#include <string>
#include <vector>
#include <iostream>
#include <iomanip>
#include <algorithm>
#include "Trade.h"

#ifndef PORTFOLIO_H
#define PORTFOLIO_H

class Portfolio
{
public:
    Portfolio(std::string const& name);
    std::string get_name() const;
    std::vector<Trade> get_trades() const;
    void add_trade(Instrument const& instrument, double const& price, int const& quantity);
    void print_position_information(int& column_width) const;

private:
    bool instrument_in_portfolio(Instrument const& instrument, int& existing_idx);
    std::string name;
    std::vector<Trade> trades;
};

bool operator==(Portfolio const &left, Portfolio const &right);
#endif