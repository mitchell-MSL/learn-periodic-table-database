#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table  -t --no-align -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    TRIMMED="${1// }"
    FIND_NUM
  else echo "Please provide an element as an argument."
  fi

}

FIND_NUM(){
  if [[ $TRIMMED =~ ^[0-9]+$ ]]
  then 
    NAME=$($PSQL"SELECT name FROM elements WHERE atomic_number='$TRIMMED'")
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
    else
      ATOMIC_NUM=$TRIMMED
      ELEM_DETES
    fi
  fi
  if [[ ! $TRIMMED =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUM=$($PSQL"SELECT atomic_number FROM elements WHERE symbol='$TRIMMED' OR name='$TRIMMED';")
    if [[ -z $ATOMIC_NUM ]]
    then
     echo "I could not find that element in the database."
    else
      ELEM_DETES
    fi
  fi     
}

ELEM_DETES(){
  NAME=$($PSQL"SELECT name from elements WHERE atomic_number=$ATOMIC_NUM")
  SYMBOL=$($PSQL"SELECT symbol from elements WHERE atomic_number=$ATOMIC_NUM")
  TYPE=$($PSQL"SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id WHERE atomic_number=$ATOMIC_NUM")
  ATOMIC_MASS=$($PSQL"SELECT atomic_mass from properties WHERE atomic_number=$ATOMIC_NUM")
  MELTING=$($PSQL"SELECT melting_point_celsius from properties WHERE atomic_number=$ATOMIC_NUM")
  BOILING=$($PSQL"SELECT boiling_point_celsius from properties WHERE atomic_number=$ATOMIC_NUM")
  echo The element with atomic number $ATOMIC_NUM is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
}


MAIN_MENU "$@"
