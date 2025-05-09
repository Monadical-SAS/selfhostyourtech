#!/bin/bash
# Shortcut to call fish functions from bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
FUNCTIONS_FILE="$1"
FUNCTION="$2"
ARG1="$3"
ARG2="$4"
ARG3="$5"
ARG4="$6"
ARG5="$7"
ARG6="$8"
ARG7="$9"
PYTHONPATH=$(which python)

function print_functions {
    while IFS= read -r line; do
        [[ "$line" == *"Helper Functions"* ]] && break

        if [[ "$line" =~ ^function[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+#description[[:space:]]+(.*)$ ]]; then
            name="${BASH_REMATCH[1]}"
            desc="${BASH_REMATCH[2]}"
            printf "   %-20s%s\n" "$name" "$desc"
        fi
    done < "$FUNCTIONS_FILE"
}

function print_help {
    echo "Usage:"
    echo "   -h | --help         See a list of all functions"
    echo "   function [args]     Run a function (funcs are defined in $FUNCTIONS_FILE)"
    echo -e "\nFunctions:"
    print_functions "$FUNCTIONS_FILE"
}

function is_valid_function {
    local valid=0

    while IFS= read -r line; do
        [[ "$line" == *"Helper Functions"* ]] && break
        if [[ "$line" =~ ^function[[:space:]]+([a-zA-Z0-9_]+)[[:space:]]+#description ]]; then
            func_name="${BASH_REMATCH[1]}"
            if [[ "$func_name" == "$FUNCTION" ]]; then
                valid=1
                break
            fi
        fi
    done < "$FUNCTIONS_FILE"

    if [[ $valid -eq 1 ]]; then
        echo "> $CMD $FUNCTION $ARG1 $ARG2 $ARG3"
    else
        echo "Not a valid function: $FUNCTION"
        echo
        print_help
        exit 1
    fi
}

### Main
# print help text and exit if $1 is empty, -h, --help, or help
if test "$FUNCTION" = "" || test "$FUNCTION" = '-h' || test "$FUNCTION" = '--help' || test "$FUNCTION" = 'help'; then
    print_help
    exit
fi

is_valid_function "$FUNCTION"

export PATH=$PATH;
export PYTHONPATH=$PYTHONPATH;
export VIRTUAL_ENV=$VIRTUAL_ENV;
source $FUNCTIONS_FILE;
$FUNCTION $ARG1 $ARG2 $ARG3 $ARG4 $ARG5 $ARG6 $ARG7
