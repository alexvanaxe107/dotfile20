#!/bin/bash
# A basic summary of my sales report

teste="news from olavo de carvalho as audio"

echo $teste | sed 's/news from //g' | sed 's/as audio//g'
