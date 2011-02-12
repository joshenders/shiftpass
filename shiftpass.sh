#!/bin/bash
# This script uses BSD mv and is not portable; deal with it..
# copy key3.db and signons.sqlite to profile and adjust variables below

profile='/Users/CHANGEME/Library/Application Support/Firefox/Profiles/CHANGEME.default'
user1=CHANGEME
user2=CHANGEME

if [[ "$#" -gt '0' ]]; then
    echo "Usage: $0" >&2
    exit 1
fi

if [[ "$(ps ax | grep -i -c [f]irefox)" -ne "0" ]]; then
    echo "It appears that Firefox is running. Please close Firefox before running this script." >&2
    exit 1
fi

# it'd be wise to backup the password files, do some error handling on the mv and trap early termination but meh.

if [[ -e "${profile}/key3.db.${user1}" && -e "${profile}/signons.sqlite.${user1}" ]]; then # user2 is active
    
    echo -e "${user2} appears active. Switching to ${user1}\n" >&2

    if [[ -w "${profile}" ]]; then # profile dir is writable
        # move current user out
        mv -nv "${profile}/key3.db" "${profile}/key3.db.${user2}" >&2
        mv -nv "${profile}/signons.sqlite" "${profile}/signons.sqlite.${user2}" >&2

        # move user1 in
        mv -nv "${profile}/key3.db.${user1}" "${profile}/key3.db" >&2
        mv -nv "${profile}/signons.sqlite.${user1}" "${profile}/signons.sqlite" >&2
    else
        echo "$0: ${profile} is not writable" >&2
        exit 1
    fi
elif [[ -e "${profile}/key3.db.${user2}" && -e "${profile}/signons.sqlite.${user2}" ]]; then # user1 is active
   
    echo -e "${user1} appears active. Switching to ${user2}\n" >&2 
   
    if [[ -w "${profile}" ]]; then # profile dir is writable
        # move current user out
        mv -nv "${profile}/key3.db" "${profile}/key3.db.${user1}" >&2
        mv -nv "${profile}/signons.sqlite" "${profile}/signons.sqlite.${user1}" >&2

        # move user2 in
        mv -nv "${profile}/key3.db.${user2}" "${profile}/key3.db" >&2
        mv -nv "${profile}/signons.sqlite.${user2}" "${profile}/signons.sqlite" >&2
    else
        echo "$0: ${profile} is not writable" >&2
        exit 1
    fi
else
    echo "Signon files for ${user1} and ${user2} not found. This profile appears to only have a single user's signon files." >&2
fi
