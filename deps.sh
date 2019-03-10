#!/bin/bash

function __run_dep {
    (
    for i in "$@" $(LANG= apt-cache depends "$@"|grep Depend|cut -d ':' -f 2)
    do
        echo "$i"
    done
    ) | sort | uniq
}

OLD=""
NEW="$(__run_dep "$@")"

while [[ "$NEW" != "$OLD" ]]
do
    OLD="$NEW"
    NEW="$(__run_dep $OLD)"
done

echo "$NEW" | grep -v '<'
