#!/bin/bash
mkdir root
cd root
for (( c=1; c<=5; c++ ))
do
mkdir dir$c
done


for (( c=1; c<=4; c++ ))
do
cd dir$c
for (( x=1; x<=4; x++ ))
do
for (( n=1; n<=$x; n++ ))
do
echo $x >> file$x
done
done
cd ..
done
