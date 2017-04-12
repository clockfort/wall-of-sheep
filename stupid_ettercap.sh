#!/bin/bash

while true; do
	ettercap -i $1 -Tzqu | ./wall_of_sheep.pl $1
done
