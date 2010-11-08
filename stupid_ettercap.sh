#!/bin/bash

while true; do
	ettercap -i eth0 -Tzqu | ./wall_of_sheep.pl
done
