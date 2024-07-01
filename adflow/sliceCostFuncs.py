"""
@File    :   sliceCostFuncs.py
@Time    :   2024/06/28
@Desc    :   Use this class to define the cost functions for the inverse design of slices. 
             These get called by the addActiveSlice routine in pyADflow
"""

# ==============================================================================
# Standard Python modules
# ==============================================================================
import os
import json
import argparse
from pathlib import Path

# ==============================================================================
# External Python modules
# ==============================================================================
import numpy as np
from slicesPost import SliceInterface

# from tabulate import tabulate
# import matplotlib.pyplot as plt


class SliceCostFuncs:

    def __init__(self):
        pass

    def _compute_lift():
        pass

    def _compute_drag():
        pass

    def _compute_moment():
        pass

    def _compute_pressureGradient():
        pass

    # ************************************************
    #     Public functions
    # ************************************************
    def addSectionLiftConstraint(sliceData: dict):
        """
        Integrate the pressures on the slice to get the lift force.

        """

        pass

    def addSectionMomentConstraint(sliceData: dict, xRef):
        pass

    def addSectionPressureGradientConstraint(sliceData: dict):
        pass

if __name__ == "__main__":
    # Test slice integration
    SliceCostFuncs()
