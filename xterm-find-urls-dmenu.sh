#!/bin/bash
set -o pipefail

# Fantastically magic unreadable mess

# This script has a side-effect of generating files. This could probably be
# avoided with some clever use of pipes or variables, but this side-effect is
# actually useful sometimes.
TEMP_URLS='/tmp/urls'
TEMP_PRINT='/tmp/xtermprint'
DMENU='dmenu -b -fn monospace:size=8'

URL_REGEX='https?:(?:(//)|(\\\\))+[!\w\d:#@%/;$()~_?\+\-=\\\.,&]*'
MAXURL=45

cat > "$TEMP_PRINT"

grep --text -Poi "$URL_REGEX" "$TEMP_PRINT" | uniq | tail -n "$MAXURL" > "$TEMP_URLS" || exec bash -c "echo I got plenty of nuttin\\', and nuttin\\'s plenty for me | $DMENU"

URL="$(tac "$TEMP_URLS" | $DMENU -l "$(wc -l < "$TEMP_URLS")")"
[ $? -eq 0 ] || exit

# With the current regex there's no way we'll actually have any single
# quotes in $URL, so this is actually totally overkill.
escape()
{
    echo "$1" | sed s/\'/\'\\\\\'\'/g
}

command="$(for i in "${@/\%URL%/$(escape "$URL")}"; do echo "$i"; done | $DMENU -l "$#")"
sh -c "$command" &
