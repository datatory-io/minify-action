#!/bin/bash

DO_CSS=true
DO_JS=true

prepend_files_with_path() {

	RESULT=$2

	for ITEM in "${$1[@]}"
	do
		RESULT="$RESULT$ITEM "
	done

	echo "$RESULT"
}

bundle_by_dir() {
	minify -r -b -o "$2/bundle.$3" "$1"
}

bundle_by_files() {
	FILESLIST=$(prepend_files_with_path $1 $2)
	minify -b -o "$3/bundle.$4" "$FILESLIST"
}

do_minify() {
	minify -o "$2" "$1"
}

if [ -z "$INPUT_CSS_DIR" ] || [ ! -d "$INPUT_CSS_DIR" ]; then
	$DO_CSS = false
fi

if [ -z "$INPUT_JS_DIR" ] || [ ! -d "$INPUT_JS_DIR" ]; then
	$DO_JS = false
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
		bundle_by_files "$FILES" "$INPUT_CSS_DIR" "$INPUT_OUTPUT_CSS" "css"
	fi

	do_minify "$INPUT_CSS_DIR/bundle.css" "$INPUT_OUTPUT_CSS/style.min.css"
fi 

if [ "$DO_JS" != false ]; then

	if [ -z "$INPUT_OUTPUT_JS" ] || [ ! -d "$INPUT_OUTPUT_JS" ]; then
		echo "output dis is not given or does not exist"
		exit 1
	fi

	if [ "$INPUT_JS_FILES" = "*" ]; then
		bundle_by_dir "$INPUT_JS_DIR" "$INPUT_OUTPUT_JS" "js"
	else
		readarray -t FILES <<< "$INPUT_JS_FILES"
		bundle_by_files "$FILES" "$INPUT_JS_DIR" "$INPUT_OUTPUT_JS" "js"
	fi

	do_minify "$INPUT_JS_DIR/bundle.js" "$INPUT_OUTPUT_JS/script.min.js"
fi 

