import numpy as np
from scipy.stats import norm
import ipopt

def BlackScholesMerton(S, K, T, r, q, sigma):

    d1 = (np.log(S/K) + (r - q + 0.5*sigma**2)*T)/(sigma*np.sqrt(T))
    d2 = d1 - sigma * np.sqrt( T )
    C = S*norm.cdf(d1) - K*np.exp(-r*T)*norm.cdf(d2)

    return C

def funcname(S, K, T, r, q, C_obs):
    
    
    return sigma 