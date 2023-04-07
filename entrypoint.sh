#!/bin/bash

DO_CSS=true
DO_JS=true

prepend_files_with_path() {

	local ITEMS=("$@")
	local CSS_DIR=$1
	RESULT=$2

	for ITEM in "${ITEMS[@]}"
	do
		RESULT="$RESULT$ITEM "
	done

	echo "$RESULT"
}

bundle_by_dir() {
	ls -1 "$1"
	minify -r -b -o "$2/bundle.$3" "$1"
}

bundle_by_files() {
	minify -b -o "$2" "$1"
}

do_minify() {
	minify -o "$2" "$1"
}

if [ -z "$INPUT_CSS_DIR" ] || [ ! -d "$INPUT_CSS_DIR" ]; then
	DO_CSS=false
fi

if [ -z "$INPUT_JS_DIR" ] || [ ! -d "$INPUT_JS_DIR" ]; then
	DO_JS=false
fi

if [ "$DO_CSS" = false ] && [ "$DO_JS" = false ]; then
	echo "Neither css-dir nor js-dir are given ... "
	exit 1;
fi

if [ "$DO_CSS" != false ]; then

	if [ -z "$INPUT_OUTPUT_CSS" ] || [ ! -d "$INPUT_OUTPUT_CSS" ]; then
		echo "output directory is not given or does not exist"
		exit 1
	fi

	if [ "$INPUT_CSS_FILES" = "*" ]; then
		bundle_by_dir "$INPUT_CSS_DIR" "$INPUT_OUTPUT_CSS" "css"
	else
		readarray -t FILES <<< "$INPUT_CSS_FILES"
		FILESLIST=prepend_files_with_path "${FILES[@]}" "$INPUT_CSS_DIR"
		bundle_by_files "$FILESLIST" "$INPUT_OUTPUT_CSS/bundle.css"
	fi

	do_minify "$INPUT_CSS_DIR/bundle.css" "$INPUT_OUTPUT_CSS/style.min.css"
fi 

