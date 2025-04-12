#!/bin/bash

# parameters
hostname=$1
date=$2
user=$3
connection=$4

# Change this to your email addresses
sender="example@something.com"
recipient="example@something.com"
subject="SSH Login Alert"
message="SSH login detected on $hostname at $date by user $user from $(echo $connection | awk '{print $1}')"

echo "$message" | mail -s "$subject" -a "From: $sender" "$recipient"
