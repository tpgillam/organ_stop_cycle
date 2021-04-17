# organ_stop_cycle

Compute cycles through all motions of `n` organ stops.

## Problem statement

Consider `n` organ stops. 
Each can be in (`0`) or out (`1`), and the vector of positions for all stops is denoted the "state".
There are therefore `2^n` possible states.

A single stop can perform one of these three actions:
1. `-`: Move in
1. `+`: Move out
1. `.`: Stay where it is (which may be "stay in" or "stay out" - we do not distinguish them).

Note that the *valid* actions depend on the state of the stop (e.g. you can't move a stop out that is already "out").
A "motion" is defined to be a vector of actions, one for each stop.
There are therefore `3^n` possible motions.  

Form an algorithm which (given a value of `n`) generates the shortest ordered list of states such that its traversal generates every possible motion at least once.
The final state should be the same as the initial state.

## Why?

You are building an electric organ from scratch, and rigging up a set of real stops to solenoids.
You may then wish to ensure that all possible transitions are tested as quickly as possible.

## Solution

Run `organ_stops.jl`, which will populate the contents of the `output` directory.
It seems likely that this algorithm meets the lower bound for any `n`; it will throw an exception if it does not.
This can *probably* be proved by appealing to a theorem which states that an Eulerian cycle exists iff all nodes in a graph are even.

The output by default shows the state and the subsequent transition in a hopefully intuitive notation, e.g. for `n = 2`:
```
00    ++
11    --
00    +.
10    -+
01    +-
10    -.
00    .+
01    .-
00    ..
00
```