#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c";

#create database
resp=$($PSQL "CREATE DATABASE number_guess");
echo $resp;

#connect to number_guess db
resp=$($PSQL "\c number_guess");
echo $resp;

#modify PSQL variable
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c";

#create tables
# user VARCHAR(22) games_played INT best_game INT
resp=$($PSQL "CREATE TABLE ranking(username VARCHAR(22), games_played INT, best_game INT)");
echo $resp;

echo DATABASE SETUP -- DONE