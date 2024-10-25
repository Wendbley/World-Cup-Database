#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty data (rows) from tables teams and games
echo "$($PSQL "TRUNCATE teams, games")"


# POPULATE teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 
  # skip the first line (titles)
  if [[ $YEAR != 'year' ]]
  then
  
    # check that oppoent team exists
      OPPONENT_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
      # if not found
      if [[ -z $OPPONENT_ID ]]
      then
        # insert new team into table
        INSERT_TEAM_RESULT=$($PSQL"INSERT INTO teams(name) VALUES('$OPPONENT')")

        # check if insertion was successful
        if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
        then
          echo $OPPONENT inserted into table teams
        fi
      fi 

       # check that winner team exists
      WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
      
      # if not found
      if [[ -z $WINNER_ID ]]
      then
        # insert new team into table
        INSERT_TEAM_RESULT=$($PSQL"INSERT INTO teams(name) VALUES('$WINNER')")

        # check if insertion was successful
        if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
        then
          echo $WINNER inserted into table teams
        fi
      fi 
  fi
done


# POPULATE games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 
  # skip the first line (titles)
  if [[ $YEAR != 'year' ]]
  then
  
        # get opponent id
        OPPONENT_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
        # get winner id
        WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
       
       # Insert new game into games table
        INSERT_GAME_RESULT=$($PSQL"INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID);")

        # check if insertion was successful
        if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
        then
          echo $WINNER_ID, $OPPONENT_ID  details inserted into table games
        fi
        
  fi
done
