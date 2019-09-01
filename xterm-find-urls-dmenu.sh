#!/bin/sh

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

if ! URLS=$(grep --text -Poi "$URL_REGEX" "$TEMP_PRINT"); then
    echo "I got plenty of nuttin', and nuttin's plenty for me" | $DMENU
    exit 0
fi

echo "$URLS" | uniq | tail -n "$MAXURL" > "$TEMP_URLS"

URL="$(tac "$TEMP_URLS" | $DMENU -l "$(wc -l < "$TEMP_URLS")")"
[ $? -eq 0 ] || exit 0

# embrace the jank
escape()
{
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/#/\\#/g'  -e s/\'/\'\\\\\\\\\'\'/g
}

command="$(for i in "$@"; do echo "$i" | sed 's#%URL%#'"$(escape "$URL")"'#'; done | $DMENU -l "$#")"
[ $? -eq 0 ] || exit 0
sh -c "$command" &
