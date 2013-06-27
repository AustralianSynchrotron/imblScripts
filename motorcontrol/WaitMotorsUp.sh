#!/bin/bash

while ! caget SR08ID01SLW01:OPENING &> /dev/null ; do
	sleep 1s
done
