# Predicting the Trajectory of Atlantic Hurricanes using Neural Networks

This is the repository for our course project for ECE 228 (Spring 2022) at UC San Diego. 


## Table of contents
* [Introduction](#Introduction)
* [Technologies](#technologies)
* [How to run the code](#how_to_run_the_code)
* [Repository structure](#repository_structure)

## Introduction

The aim of the project is to predict the trajectory of Atlantic hurricanes using Recurrent Neural Networks. A Markov Transition Model-based M2M LSTM framework is developed for this which predicts the next 5 trajectory points of a hurricane, given it's first 5 points at 6 hour intervals.

## Technologies

1. Windows/Unix system 
2. MATLAB 2018a or newer
3. MATLAB Mapping Toolbox
4. Python 
5. Keras
6. Numpy

## How to run the code

The model training code is in final_ece228_project_code.ipynb notebook. The notebook can be run cell by cell, the notebook also has blocks of texts to guide with the execution and to understand the flow of the program.
The code is written in python and matlab. Extra features are calculated in matlab and stored in a file lstm_m.csv which is used in our python notebook.

## Repository structure

The follwing are the main components in the repository:

1. dataset

The dataset is in the follwing repository: https://github.com/Sang555/ece228/tree/main

atlantic.csv - It is the main dataset for our problem statement
lstm_m.csv - It is data generated from matlab which contains the generated features.
projection_constants.json - It is the file containing the data required for transformation for the coordinates.


lambert.py - This file contains the functions required for transformation of the latitude and longitude coordinates.

2. Data analysis

This folder contains the notebooks for the exploratory data analysis of our project.

3. Markov Transition Model

This folder contains the code for the generation of the displacment probabilities using markov transition model.
