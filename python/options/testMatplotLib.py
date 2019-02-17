import numpy as np
from scipy.stats import norm
import random as rnd
import matplotlib.pyplot as plt
import xlrd as xlr

N = 1000
u1 = np.random.uniform(0,1,N)
xi1 = np.cumsum(norm.ppf(u1))
u2 = np.random.uniform(0,1,N)
xi2 = np.cumsum(norm.ppf(u2))
u3 = np.random.uniform(0,1,N)
xi3 = np.cumsum(norm.ppf(u3))

x = np.linspace(1, N, N)

plt.plot(x, xi1, label='random walk 1')
plt.plot(x, xi2, label='random walk 2')
plt.plot(x, xi3, label='random walk 3')

plt.xlabel('x label')
plt.ylabel('y label')

plt.title("Some random walks")

plt.legend()

plt.show()