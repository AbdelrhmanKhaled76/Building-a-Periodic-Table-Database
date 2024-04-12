#!/bin/bash
NUM=""
if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  ELEMENT=$($PSQL "select * from elements;")
  while IFS='|' read -r ATOM_NUM SYMBOL NAME
  do
    if [[ "$1" == "$ATOM_NUM" || "$1" == "$SYMBOL" || "$1" == "$NAME" ]] 
    then
      NUM="BOB"
      PROPERTIES=$($PSQL "select * from properties where atomic_number='$ATOM_NUM';")
      while IFS='|' read -r ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
      do
        TYPE=$($PSQL "select type from types where type_id='$TYPE_ID'")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done <<< "$PROPERTIES"
      break
    fi
  done <<< "$ELEMENT"
  if [[ -z "$NUM" ]]
  then 
    echo "I could not find that element in the database."
  fi
fi
