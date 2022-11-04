#!/bin/bash 
x=$1
if ! [[ $x =~ '^[0-9]+$' ]]; 
   then echo "error: Not a number" >&2; exit 1 
fi