#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c";

#define secret number and number of guesses
sec_num=$((1 + $RANDOM % 1000));
num_guess=0;

#enter username
echo "Enter your username:";
read username;

#get user info if existing
user_info=($($PSQL "SELECT * FROM ranking WHERE username='$username'" | tr '|' ' '));
games_played_inclusive=$(( ${user_info[1]} + 1));
best_game=${user_info[2]};
if [[ -z $user_info ]]
    then
        #new user: display welcome message and make db entry
        echo Welcome, $username! It looks like this is your first time here.
        resp=$($PSQL "INSERT INTO ranking(username) VALUES('$username')");
    else
        #existing user: display welcome message
        echo Welcome back, ${user_info[0]}! You have played ${user_info[1]} games, and your best game took $best_game guesses.
fi

#function: check guess
check() {
    if [[ ! $guess =~ ^[0-9]+$ ]]
        #invalid user input: ask again
        then
            guess=invalid;
            ask;
    elif (( $guess == $sec_num ))
        then
            #guess correct: update tally, display success message, update ranking.games_played and ranking.best_game
            num_guess=$(( $num_guess + 1 ));
            echo "You guessed it in $num_guess tries. The secret number was $sec_num. Nice job!";
            if [[ -z $best_game ]] || (( $best_game > $num_guess ))
                then
                    best_game=$num_guess;
            fi
            resp=$($PSQL "UPDATE ranking SET games_played=$games_played_inclusive,best_game=$best_game WHERE username='$username'");
    else
        #guess incorrect: update tally and ask again
        num_guess=$(( $num_guess + 1 ));
        ask;
    fi
}

#function: ask guess
ask() {
    if [[ -z $guess ]]
        then
            #first guess: collect input and check
            echo "Guess the secret number between 1 and 1000:";
            read guess;
            check;
    elif (( $guess == "invalid" ))
        then
            #input invalid: collect input and check
            echo "That is not an integer, guess again:";
            read guess;
            check;    
    elif (( $guess > $sec_num ))
        then
            #guess too high: collect input and check
            echo "It's lower than that, guess again:";
            read guess;
            check;
    else
            #guess too low: repeat collect input and check
            echo "It's higher than that, guess again:";
            read guess;
            check;
    fi
}

#program trigger
ask;