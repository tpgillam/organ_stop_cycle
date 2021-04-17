# organ_stop_cycle

Compute cycles through all motions of `n` organ stops.

## Problem statement

Consider `n` organ stops. 
Each can be in or out, and the vector of positions is denoted the "state".
There are `2^n` possible states.

A single stop can perform one of these three actions:
1. Go in
1. Come out
1. Stay where it is (which may be in or out).

Note that the *valid* actions depend on the state of the stop (e.g. you can't move a stop out that is already "out").
A "motion" is defined to be a vector of actions, one for each stop.
There are therefore `3^n` possible motions.  
A 'state' is is a configuration of where the stops are, and a transition between two states is a motion. 
A state can be represented as a unsigned int whose bits hold 1 for out and 0 for in for each stop.  
Form an algorithm which (given a value of `n`) generates an ordered list of states with the properties that 

* (a) traversal of the list of states generates every possible motion at least once, and 
* (b) the list is as short s possible, i.e. ideally contains no more than `3^n` states (though it may not be possible to make that bound tight). 

The list is presumed to be on a loop, i.e. there is also a motion between the last state and the first as well as between each neighbour.  

## Why?

If you are building an electric organ from scratch, and rigging up a set of real stops to solenoids, you may wish to ensure that all possible transitions are tested as quickly as possible.

## Solution

Run `organ_stops.jl`, which will populate the contents of the `output` directory.