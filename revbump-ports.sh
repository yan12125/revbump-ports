#!/usr/bin/env bash

noversion=()

if [ $# -lt 1 ]; then
	echo >&2 "Usage: $0 <port-expression>..."
	exit 1
fi

if ! which gsed >/dev/null; then
	echo >&2 "ERROR: This script needs gsed, please install the gsed port"
	exit 2
fi
for portfile in "$@"; do
	if grep -Eq $'^[ \t]*revision[ \t]+[0-9]+' "$portfile"; then
		contents=$(gsed -i -rf increase-revision.sed "$portfile")
	else
		if grep -Eq $'^[ \t]*version[ \t]+.*$' "$portfile"; then
			contents=$(gsed -i -rf add-revision.sed "$portfile")
		elif grep -Eq $'^[ \t]*github.setup[ \t]+.*$' "$portfile"; then
			contents=$(gsed -i -rf add-revision-github.sed "$portfile")
		elif grep -Eq $'^[ \t]*perl5.setup[ \t]+.*$' "$portfile"; then
			contents=$(gsed -i -rf add-revision-perl5.sed "$portfile")
		else
			noversion+=("$portfile")
			continue
		fi
	fi
done

if [ ${#noversion[@]} -gt 0 ]; then
	echo >&2 "No version line was found in the following Portfiles, could not add revision automatically:"
	for portfile in "${noversion[@]}"; do
		echo >&2 "- $portfile"
	done
	exit 4
fi
