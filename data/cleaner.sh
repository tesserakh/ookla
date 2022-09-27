#!/usr/bin/env bash

for FILE in $(ls | grep zip); do; rm $FILE; done
