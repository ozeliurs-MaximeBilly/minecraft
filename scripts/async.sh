#!/bin/bash
# Description : "async tool"

screen -S async -d -m
screen -R async -X stuff "$1  $(printf "\r")"
