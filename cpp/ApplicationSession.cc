#include <thread>   //sleep_for()
#include <chrono>   //second()
#include "Instrument.h"
#include "Portfolio.h"

using namespace std;

//Forward declaration of help functions for "GUI" printing
void print_position_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width);
void print_available_instruments_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width);
void print_add_instrument_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width);
void print_add_portfolio_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width);
void print_make_trade_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width);

//Main program
int main(int argc, char *argv[])
{
    // Vectors for storing intruments and portfolios for the session
    vector<Instrument> instruments;
    vector<Portfolio> portfolios;

    //If any arguments on top of ./a.out is passed, we add some initial instruments, portfolios and trades.
    bool add_initial_data{argc > 1};
    if (add_initial_data)
    {
        //Add some instruments
        Instrument instr1{"VOLVb.ST", "SEK", "Volvo AB"};
        Instrument instr2{"SEBc.ST", "SEK", "SEB AB"};
        Instrument instr3{"APPL.O", "USD", "Apple Inc."};
        Instrument instr4{"AXN.ST", "SEK", "Astra Zeneca"};
        instruments.push_back(instr1);
        instruments.push_back(instr2);
        instruments.push_back(instr3);
        instruments.push_back(instr4);

        //Create two empty portfolios
        Portfolio p1{"my portfolio"};
        Portfolio p2{"my other portfolio"};
        portfolios.push_back(p1);
        portfolios.push_back(p2);

        //Make some trades
        portfolios[0].add_trade(instruments[0], 99.99, 11000);
        portfolios[0].add_trade(instruments[1], 45.53, 20000);
        portfolios[0].add_trade(instruments[2], 25.94, 30000);
        portfolios[1].add_trade(instruments[0], 101.11, 113);
        portfolios[1].add_trade(instruments[1], 46.22, 233);
        portfolios[0].add_trade(instruments[0], 102.25, -5);
        portfolios[0].add_trade(instruments[3], 15, -15);
    }

    //Variable for terminal prints
    int column_width = 20;

    //Start the "application"
    print_position_view(portfolios, instruments, column_width);
    cin.ignore(INT8_MAX, '\n');
}

// Help functions for printing the "graphical user interface"
void print_position_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width)
{
    system("clear");

    //Print header
    string header = "Position view, all trades";
    cout << setw(column_width * 6) << setfill('-') << "" << endl;
    cout << setw(column_width * 3 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 6) << setfill('-') << "" << endl;

    if (portfolios.empty())
    {
        cout << "There are no positions to show. Create a new portfolio and instruments to start trading." << endl;
    }
    else
    {
        //Print column names
        cout << setw(column_width * 2) << setfill(' ') << "Instrument" << setw(column_width)
             << " Currency" << setw(column_width) << "Position" << setw(column_width) << setw(column_width)
             << "Price" << setw(column_width) << "Market value" << endl;

        //Print data
        for_each(portfolios.begin(), portfolios.end(), [&column_width](Portfolio p) {
            p.print_position_information(column_width);
        });
    }

    //Print menu
    string menu_header = "Menu";
    cout << setw(column_width * 3) << setfill('-') << "" << endl;
    cout << setw(column_width * 1.5 + menu_header.size() / 2) << setfill(' ') << menu_header << endl;
    cout << setw(column_width * 3) << setfill('-') << "" << endl;
    cout << "Type an integer and press ENTER to select an alternative:" << endl;
    cout << "1. View available instruments." << endl;
    cout << "2. Create a new instrument to trade." << endl;
    cout << "3. Add a new portfolio." << endl;
    cout << "4. Make a trade." << endl;
    cout << "0. Exit application." << endl;
    cout << "Choose:" << endl;

    //Receive input, with some error handling
    int choice{-1};
    while (1)
    {
        cin >> choice;

        if (cin.fail() || (choice != 1 && choice != 2 && choice != 3 && choice != 4 && choice != 0))
        {
            cout << "Invalid input, please try again." << endl;
            cout << "Choose: " << endl;
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else
        {
            switch (choice)
            {
            case 1:
                print_available_instruments_view(portfolios, instruments, column_width);
                break;
            case 2:
                print_add_instrument_view(portfolios, instruments, column_width);
                break;
            case 3:
                print_add_portfolio_view(portfolios, instruments, column_width);
                break;
            case 4:
                print_make_trade_view(portfolios, instruments, column_width);
                break;
            case 0:
                cout << "Exiting application." << endl;
                break;
            }
            break;
        }
    }
}

void print_available_instruments_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width)
{
    system("clear");

    //Print header
    string header = "Available instruments to trade";
    cout << setw(column_width * 3) << setfill('-') << "" << endl;
    cout << setw(column_width * 1.5 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 3) << setfill('-') << "" << endl;

    if (instruments.empty())
    {
        cout << "There are no available instruments to trade. Use the menu to create new instruments." << endl;
    }
    else
    {   
        //Print column names
        cout << setw(column_width) << setfill(' ') << "Name" << setw(column_width)
             << " Currency" << setw(column_width) << "Issuer" << setw(column_width) << endl;

        //Print data
        for_each(instruments.begin(), instruments.end(), [&column_width](Instrument &instrument) {
            cout << setw(column_width) << instrument.get_name() << setw(column_width) << instrument.get_currency() << setw(column_width) << instrument.get_issuer() << endl;
        });
    }

    //Print menu
    string menu_header = "Menu";
    cout << setw(column_width * 3) << setfill('-') << "" << endl;
    cout << setw(column_width * 1.5 + menu_header.size() / 2) << setfill(' ') << menu_header << endl;
    cout << setw(column_width * 3) << setfill('-') << "" << endl;
    cout << "Type an integer and press ENTER to select an alternative:" << endl;
    cout << "1. Create a new instrument to trade." << endl;
    cout << "2. Back to main menu/position view." << endl;
    cout << "0. Exit application." << endl;
    cout << "Choose:" << endl;

    //Receive input, with some error handling
    int choice{};
    while (1)
    {
        cin >> choice;

        if (cin.fail() || (choice != 1 && choice != 2 && choice != 0))
        {
            cout << "Invalid input, please try again." << endl;
            cout << "Choose: " << endl;
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else
        {
            switch (choice)
            {
            case 1:
                print_add_instrument_view(portfolios, instruments, column_width);
                break;
            case 2:
                print_position_view(portfolios, instruments, column_width);
                break;
            case 0:
                cout << "Exiting application." << endl;
                break;
            }
            break;
        }
    }
}

void print_add_instrument_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width)
{
    system("clear");

    //Print header
    string header = "Create a new instrument to trade";
    cout << setw(column_width * 5) << setfill('-') << "" << endl;
    cout << setw(column_width * 2.5 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 5) << setfill('-') << "" << endl;

    //Receive input, with some error handling
    cout << "Type name, currency and issuer of the instrument (on the suggested format), press ENTER after each entry. " << endl;
    string name{};
    string currency{};
    string issuer{};
    cin.ignore(INT8_MAX, '\n');
    while (1)
    {
        cout << "Name (string): " << endl;
        getline(cin, name);
        cout << "Currency (string: ABC): " << endl;
        getline(cin, currency);
        cout << "Issuer (string): " << endl;
        getline(cin, issuer);

        if (cin.fail() || currency.size() != 3 || name.size() == 0 || issuer.size() == 0)
        {
            cout << "Invalid input, please try again." << endl;
            cin.clear();
        }
        else
        {
            Instrument instrument_new{name, currency, issuer};
            vector<Instrument>::iterator it = find(instruments.begin(), instruments.end(), instrument_new);
            if (it == instruments.end())
            {
                instruments.push_back(instrument_new);
            }
            else
            {
                cout << "Instrument \"" << instrument_new.get_name() << "\" is already listed among the available instruments." << endl;
                cout << "You will be redirected to the instruments view within 5 seconds." << endl;
                this_thread::sleep_for(chrono::seconds(5));
            }
            break;
        }
    }
    print_available_instruments_view(portfolios, instruments, column_width);
}

void print_add_portfolio_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width)
{
    system("clear");

    //Print header
    string header = "Add a new portfolio";
    cout << setw(column_width * 5) << setfill('-') << "" << endl;
    cout << setw(column_width * 2.5 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 5) << setfill('-') << "" << endl;

    //Receive input, with some error handling
    cout << "Type the name of your new portfolio and then press ENTER." << endl;
    string name{};
    cin.ignore(INT8_MAX, '\n');
    while (1)
    {
        cout << "Name: ";
        getline(cin, name);

        if (cin.fail() || name.size() == 0)
        {
            cout << "Invalid input, please try again." << endl;
            cin.clear();
        }
        else
        {
            Portfolio portfolio_new{name};
            vector<Portfolio>::iterator it = find(portfolios.begin(), portfolios.end(), portfolio_new);
            if (it == portfolios.end())
            {
                portfolios.push_back(portfolio_new);
            }
            else
            {
                cout << "Portfolio \"" << portfolio_new.get_name() << "\" already exists." << endl;
                cout << "You will be redirected to the main menu/position view within 5 seconds." << endl;
                this_thread::sleep_for(chrono::seconds(5));
            }
            break;
        }
    }
    print_position_view(portfolios, instruments, column_width);
}

void print_make_trade_view(vector<Portfolio> &portfolios, vector<Instrument> &instruments, int &column_width)
{
    system("clear");

    //Print header
    string header = "Choose portfolio to trade in";
    cout << setw(column_width * 5) << setfill('-') << "" << endl;
    cout << setw(column_width * 2.5 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 5) << setfill('-') << "" << endl;

    //Some error handling
    if (portfolios.empty())
    {
        cout << "You have to add a new portfolio to trade in." << endl;
        cout << "You will be redirected to the main menu within 5 seconds." << endl;
        this_thread::sleep_for(chrono::seconds(5));
        print_position_view(portfolios, instruments, column_width);
        return;
    }

    //Print column names
    cout << setw(column_width) << setfill(' ') << "Portfolio number" << setw(column_width)
         << "Name" << endl;
    
    //Print available portfolios 
    for (int i = 0; i < portfolios.size(); i++)
    {
        cout << setw(column_width) << i + 1 << setw(column_width) << portfolios[i].get_name() << endl;
    }

    //Receive portfolio choice input, with some error handling
    cout << "Choose portfolio by portfolio number or enter 0 to cancel trade:" << endl;
    cout << "Choose: " << endl;
    int portfolio_choice{-1};
    while (1)
    {
        cin >> portfolio_choice;

        if (cin.fail() || portfolio_choice > portfolios.size() || portfolio_choice < 0)
        {
            cout << "Invalid input, please try again." << endl;
            cout << "Choose: " << endl;
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else if (portfolio_choice == 0)
        {
            print_position_view(portfolios, instruments, column_width);
            return;
        }
        else
        {
            break;
        }
    }

    //Print header
    header = "Choose from available intruments to trade";
    cout << setw(column_width * 5) << setfill('-') << "" << endl;
    cout << setw(column_width * 2.5 + header.size() / 2) << setfill(' ') << header << endl;
    cout << setw(column_width * 5) << setfill('-') << "" << endl;

    //Some error handling
    if (instruments.empty())
    {
        cout << "You have to create new instruments to trade." << endl;
        cout << "You will be redirected to the main menu within 5 seconds." << endl;
        this_thread::sleep_for(chrono::seconds(5));
        print_position_view(portfolios, instruments, column_width);
        return;
    }

    //Print column names
    cout << setw(column_width) << setfill(' ') << "Instrument number" << setw(column_width)
         << "Name" << setw(column_width) << " Currency" << setw(column_width) << "Issuer" << setw(column_width) << endl;

    //Print intrument information
    for (int i = 0; i < instruments.size(); i++)
    {
        cout << setw(column_width) << i + 1 << setw(column_width) << instruments[i].get_name() << setw(column_width)
             << instruments[i].get_currency() << setw(column_width) << instruments[i].get_issuer() << endl;
    }

    //Receive instrument choice input, with some error handling
    cout << "Choose instrument by instrument number or enter 0 to cancel trade:" << endl;
    cout << "Choose: " << endl;
    int instrument_choice{-1};
    while (1)
    {
        cin >> instrument_choice;

        if (cin.fail() || instrument_choice > instruments.size() || instrument_choice < 0)
        {
            cout << "Invalid input, please try again." << endl;
            cout << "Choose: " << endl;
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else if (instrument_choice == 0)
        {
            print_position_view(portfolios, instruments, column_width);
            return;
        }
        else
        {
            break;
        }
    }

    ////Receive quantity input, with some error handling
    cout << "You have chosen to trade instrument \"" << instruments[instrument_choice - 1].get_name()
         << "\" in portfolio \"" << portfolios[portfolio_choice - 1].get_name() << "\"." << endl;
    cout << "Please enter the quantity you want to trade (negative number for sell). Enter 0 to cancel trade: ";

    int quantity{0};
    while (1)
    {
        cin >> quantity;

        if (cin.fail())
        {
            cout << "Invalid input, please try again: ";
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else if (quantity == 0)
        {
            print_position_view(portfolios, instruments, column_width);
            return;
        }
        else
        {
            break;
        }
    }

    //Receive price input, with some error handling
    cout << "Please enter the price of the trade (must be positive). Enter 0 to cancel trade: ";
    double price{0};
    while (1)
    {
        cin >> price;

        if (cin.fail() || price < 0)
        {
            cout << "Invalid input, please try again: ";
            cin.clear();
            cin.ignore(INT8_MAX, '\n');
        }
        else if (price == 0)
        {
            print_position_view(portfolios, instruments, column_width);
            return;
        }
        else
        {
            break;
        }
    }

    //Add the trade to portfolio
    portfolios[portfolio_choice - 1].add_trade(instruments[instrument_choice - 1], price, quantity);
    print_position_view(portfolios, instruments, column_width);
}