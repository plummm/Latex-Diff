#!/bin/bash

display_help() {
    echo "Usage: $0 old_latex_proj new_latex_proj " >&2
    echo
    echo "   -o                 Specify the output directory"
    echo
}

if [ $# -ne 2 ]; then
  display_help
  exit 1
fi

while true; do
    if [ $# -eq 0 ];then
	echo $#
	break
    fi
    case "$1" in
        -h | --help)
            display_help
            exit 0
            ;;
        *)  # No more options
            break
            ;;
    esac
done

OLD_PROJ=$1
NEW_PROJ=$2
DIFF_PORJ="Diff_${NEW_PROJ}"

cp -r "$NEW_PROJ" "$DIFF_PORJ"
find "${OLD_PROJ}" -name "*.tex" | \
    while read -r line; do \
        NEW_TEX_FILE="${NEW_PROJ}/${line#*${OLD_PROJ}}"; \
        DIFF_TEX_FILE="${DIFF_PORJ}/${line#*${OLD_PROJ}}"; \
        if [ -f "${NEW_TEX_FILE}" ]; then \
            echo "${line} ${NEW_TEX_FILE} ${DIFF_TEX_FILE}"; \
            latexdiff --ignore-warnings "${line}" "${NEW_TEX_FILE}" > "${DIFF_TEX_FILE}"; \
        fi; \
    done
