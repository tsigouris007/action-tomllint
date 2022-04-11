# tomllint-github-action

Tomllint GitHub Actions allow you to execute `eslint` command within GitHub Actions using the `eslint-plugin-toml`.

The output of the actions can be viewed from the Actions tab in the main repository view. If the actions are executed on a pull request event, a comment may be posted on the pull request.

Tomllint GitHub Actions is a single GitHub Action that can be executed on different directories depending on the content of the GitHub Actions TOML file.

## About ESLint
Official ESLint: https://www.npmjs.com/package/eslint \
Official TOML Plugin: https://www.npmjs.com/package/eslint-plugin-toml \
TOML Rules: https://ota-meshi.github.io/eslint-plugin-toml/rules/

## Success Criteria

An exit code of `0` is considered a successful execution.

## Usage

The most common usage is to run `eslint` on a file. A comment will be posted to the pull request depending on the output of the Tomllint command being executed. This workflow can be configured by adding the following content to the GitHub Actions workflow YAML file.

```yaml
name: 'Tomllint GitHub Actions'
on:
  - pull_request
jobs:
  tomllint:
    name: 'Tomllint'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Tomllint'
        uses: tsigouris007/action-tomllint@master # Or the proper version/tag
        with:
          tomllint_files: '<toml_file(s)>'
          tomllint_comment: true
          tomllint_ruleset: base|recommended|standard # Default standard
        env:
          GITHUB_ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This was a simplified example showing the basic features of this Tomllint GitHub Actions.

## Inputs

Inputs configure Tomllint GitHub Actions to perform lint action.

| Parameter                    | Default    | Description                                                                                                               |
|------------------------------|------------|--------------------------------------------------------------|
| `tomllint_files`             | .          | (Optional) The files to run `tomllint`                       |
| `tomllint_comment`           | `false`    | (Optional) Allow Tomllint to comment on PR.                  |
| `tomllint_ruleset`           | `standard` | (Optional) The TOML ruleset to be applied. Default: standard |

## Outputs

Outputs are used to pass information to subsequent GitHub Actions steps.

* `tomllint_output` - The Tomllint build outputs.

## Secrets

Secrets are similar to inputs except that they are encrypted and only used by GitHub Actions. It's a convenient way to keep sensitive data out of the GitHub Actions workflow YAML file.

* `GITHUB_ACCESS_TOKEN` - (Optional) The GitHub API token used to post comments to pull requests. Not required if the `tomllint_comment` input is set to `false`.
