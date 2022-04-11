#!/bin/bash

function parse_inputs {
  tomllint_files=""
  if [ "${INPUT_TOMLLINT_FILES}" != "" ]; then
    tomllint_files="${INPUT_TOMLLINT_FILES}"
  fi

  tomllint_comment=0
  if [[ "${INPUT_TOMLLINT_COMMENT}" == "0" || "${INPUT_TOMLLINT_COMMENT}" == "false" ]]; then
    tomllint_comment="0"
  fi
  if [[ "${INPUT_TOMLLINT_COMMENT}" == "1" || "${INPUT_TOMLLINT_COMMENT}" == "true" ]]; then
    tomllint_comment="1"
  fi

  tomllint_ruleset="${INPUT_TOMLLINT_RULESET}"
  if [[ "${INPUT_TOMLLINT_RULESET}" != "base" &&
  "${INPUT_TOMLLINT_RULESET}" != "recommended" &&
  "${INPUT_TOMLLINT_RULESET}" != "standard" ]]; then
    tomllint_ruleset="standard"
  fi
}

function main {
  scriptDir=$(dirname ${0})
  source ${scriptDir}/tomllint.sh
  parse_inputs

  toml_lint
}

main "${*}"
