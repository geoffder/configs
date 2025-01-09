#!/bin/bash

updates=$(pamac checkupdates | wc -l | xargs printf "%i - 1\n" | bc)
printf "$updates \n"
