#!/usr/bin/env bash

DISPLAY=:0
export DISPLAY
unity &> /dev/null & disown
