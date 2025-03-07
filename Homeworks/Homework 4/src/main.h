/**
 * Name: Aaryan Potdar
 * GTID: 903795148
 * This file contains the main method and the generateMessage method.
 * You will submit this file to gradescope.
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include "arraylist.h"
#include "arraylist_tests.h"

/*
 * Dictionary and Dictionary length used in generating the pseudorandom message.
 */
int dictionary_length = 15; // ERROR: 15 words in dictionary and not 17
char *dictionary[] = {
    "this",
    "rocks",
    "tea",
    "juice",
    "is",
    "secret",
    "nothing",
    "correct",
    "more",
    "cs2200",
    "than",
    "tunnel",
    "hot",
    "momo",
    "leaf",
};

int main(int argc, char *argv[]);
char *generateMessage();
