"""
    Author: Leonardo Rossi Leao
    Date: February 1st, 2024
    Description: Algorithms to fit a gaussian curve.
    Based on https://www.geeksforgeeks.org/python-gaussian-fit/
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def gaussianModel(x: list, sigma: float, mu: float):

    """
    Implements the model of a Gaussian curve

    Args:
        x      (list): list with elements in x-axis
        sigma (float): standard deviation
        mu    (float): mean value

    Returns:
        y (list): list with elemetns in y-axis
    """

    return (1/(sigma*np.sqrt(2*np.pi)))*np.exp(-1/2*((x-mu)/sigma)**2)


def gaussianFit(x: list, y: list) -> list:

    """
    Fit a Gaussian curve

    Args:
        x (list): list with elements in x-axis
        y (list): list with elements in y-axis

    Return:
        sigma (float): Gaussian standard deviation
        mu (float): Gaussian mean value
    """

    popt, _ = curve_fit(gaussianModel, x, y, p0=(10, 10))
    return popt


if __name__ == "__main__":

    x = np.linspace(0, 100, 10000)
    y = gaussianModel(x, 5, 100)
    print(np.mean(y), np.std(y))

    sigma, mu = gaussianFit(x, y)
    print("Sigma:", sigma)
    print("Mu:", mu)
    print("Size:", 2*3*sigma)

    plt.scatter(x, y)
    plt.plot(x, gaussianModel(x, sigma, mu))
    plt.show()

