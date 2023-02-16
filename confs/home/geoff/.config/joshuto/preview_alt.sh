#!/usr/bin/env bash

# https://gist.github.com/is0n/f49599a56303a9583f9eb20e4c077917

shift
file="$1"

case $(file -b --mime-type "${file}") in
	text/* | application/json)
		cat "${file}"
		exit 0
		;;
	application/x-mach-binary | application/zip)
		ls -lha "${file}"
		exit 0
		;;
	*)
		exit 0
		;;
esac

exit 0
