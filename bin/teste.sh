#! /bin/sh

comparacao=st
teste=$1

if echo ${teste} | grep -E "st"; then
    echo teste
else
    echo no teste
fi
