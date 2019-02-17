problem CVaR;

param nSamples;			               # The number of scenarios

set Assets;			                   # The set containing all assets

param interestRateGrowth;		       # The interest rate during the period
param alpha;			                 # Level of CVaR
param mu;			                     # Expected return of the portfolio

param initHolding{Assets};	       # Initial position in assets
param initCash;			               # Initial holding of cash

param initPrice{Assets};           # Initial asset prices
param prices{1..nSamples, Assets}; # Asset prices in the scenarios
param probability{1..nSamples};    # Scenario probabilities

var x{Assets};                     # Buy and sell decisions
var y{1..nSamples} >= 0;
var zeta;                          # VaR

minimize z: 
