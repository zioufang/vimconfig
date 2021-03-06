#!/bin/bash
# launch fuzzy matched bookmark in browser

BOOKMARKS=${HOME}/.scripts/fzfcmds/bookmarks
FZF_ARGS="--reverse"

# Display the menu and get the selection
SELECTION=`sed '/^#/d;/^$/d;/^ /d' ${BOOKMARKS} | awk '{print $1}' | fzf ${FZF_ARGS}`

if [ "${SELECTION}" ]; then
	# Get the text associated with the selection.
	URL=`grep "${SELECTION}" ${BOOKMARKS} | sed "s/${SELECTION} //"`
fi

if [ "${URL}" ]; then
	lnch ${BROWSER} ${URL}
fi

exit
