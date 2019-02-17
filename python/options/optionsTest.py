import numpy as np
from scipy.stats import norm
import random as rnd
import matplotlib as plt
import matplotlib.pyplot as plt
import xlrd as xlr

S = 100
K = 100
T = 3/12
r = 0.01
q = 0
sigma = 0.2
eps = 10**(-6)

def BlackScholesMerton(S, K, T, r, q, sigma):

    d1 = (np.log(S/K) + (r - q + 0.5*sigma**2)*T)/(sigma*np.sqrt(T))
    d2 = d1 - sigma * np.sqrt( T )
    C = S*norm.cdf(d1) - K*np.exp(-r*T)*norm.cdf(d2)

    return C

C = BlackScholesMerton(S, K, T, r, q, sigma)

delta_num = (BlackScholesMerton(S + eps, K, T, r, q, sigma)\
            - BlackScholesMerton(S, K, T, r, q, sigma))/eps

delta_analytic = norm.cdf((np.log(S/K) + (r - q + 0.5*sigma**2)*T)/(sigma*np.sqrt(T)))

# MC-simulation

N = 10**7
u = np.random.uniform(0,1,N)
xi = norm.ppf(u)
lnST = np.log(S) + (r - q - 0.5*sigma**2)*T + sigma*np.sqrt(T)*xi
ST = np.exp(lnST)

payoffs = ST - K
payoffs[payoffs < 0] = 0
C_MC = np.exp(-r*T)*np.mean(payoffs)

print(C, C_MC, 100*(C_MC/C - 1))

# Plot test

np.cumsum(xi)