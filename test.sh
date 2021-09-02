#!/bin/env bash

expect="Hello, World !"

for file in bin/hello-*
do
  printf "%s\t: " "$file"
  output=$($file)
  if [ "$output" = "$expect" ]; then
    printf "OK\n"
  else  
    printf "FAILED : '%s' != '%s' \n" "$output" "$expect"
  fi
done  
