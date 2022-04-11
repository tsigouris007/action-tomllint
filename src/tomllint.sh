#!/bin/bash

function toml_lint {

    # gather output
    echo "lint: info: tomllint on ${tomllint_files}."
    lint_cmd="eslint.js -c /app/config/.eslintrc.${tomllint_ruleset}.js -f /app/config/custom_formatter.js ${tomllint_files} --no-color"
    echo "Running: ${lint_cmd}"
    lint_output=$($lint_cmd)
    lint_exit_code=${?}

    echo "Lint Output:"
    echo "${lint_output}"
    echo "---"
    # exit code 0 - success
    if [ ${lint_exit_code} -eq 0 ];then
        lint_comment_status="Success"
        echo "lint: info: successful tomllint on ${tomllint_files}."
        echo
    fi

    # exit code !0 - failure
    if [ ${lint_exit_code} -ne 0 ]; then
        lint_comment_status="Failed"
        echo "lint: error: failed tomllint on ${tomllint_files}."
        echo
    fi

    # comment if lint failed
    if [ "${GITHUB_EVENT_NAME}" == "pull_request" ] && [ "${tomllint_comment}" == "1" ] && [ ${lint_exit_code} -ne 0 ]; then
        lint_comment_wrapper="#### \`tomllint\` ${lint_comment_status}
<details><summary>Show Output</summary>

\`\`\`
${lint_output}
 \`\`\`
</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, Lint: \`${tomllint_comment}\`*"
    
        echo "lint: info: creating json"
        lint_payload=$(echo "${lint_comment_wrapper}" | jq -R --slurp '{body: .}')
        lint_comment_url=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
        echo "lint: info: commenting on the pull request"
        echo "Posting comment: ${lint_payload}"
        echo "${lint_payload}" | curl -s -S -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" --header "Content-Type: application/json" --data @- "${lint_comment_url}" > /dev/null
    fi

    echo ::set-output name=tomllint_output::${lint_output}
    exit ${lint_exit_code}
}
