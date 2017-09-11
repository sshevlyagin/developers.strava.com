# Contributing

## Prerequisites

Any contribution and work taking place in this repository is expected to follow the rules defined by our [code of conduct](https://github.com/strava/developers.strava.com/blob/master/CODE_OF_CONDUCT.md). Please make sure to read and understand it.

## Reporting an issue

To report an issue, please [open a GitHub issue](https://github.com/strava/developers.strava.com/issues/new) in this repository. We accept issues pertaining to the following aspects:

- The OpenAPI specification defined here – missing fields or endpoints, incorrect types, etc…
- The documentation generator (anything under the `codegen/` repository)
- The various parts of the API documentation: structure, typos, etc…
- The setup of the website
- The tooling used throughout the repository
- Requesting for endpoints to be made public or for payloads to be augmented with certain fields

Specifically, please avoid opening issues pertaining to the Strava API agreement or the brand guidelines, or to report bugs or issues pertaining to the Swagger/OpenAPI tooling itself.

Please do not comment on an issue with a simple '+1' or 'me too' — use GitHub reactions on the original report to show your support.

## Submitting a fix

Before doing any work that you seek to contribute back, please make sure to open a GitHub issue in this repository so that the work can be better tracked and possibly assigned. If you plan on working on an issue, leave a comment to that effect.

To propose a change:

- Fork this repository into your own workspace
- Make the changes needed and commit them to your fork. Make reference to the issue you worked on in your commit message. We don't enforce strict guidelines for title and commit messages but consider:
  - Presenting the context of your change
  - Explaining the caveats of your implementation, if any
- Open a GitHub Pull Request targeting the `master` branch.
- Wait for a review from an administrator of the repository.
- If any further change is requested, please submit them as fixup commits in Git, e.g. `git commit --fixup HEAD`. Read more about fixup commits [here](https://robots.thoughtbot.com/autosquashing-git-commits). Unless required, avoid rebasing your branch onto `master` during the review.

If you've made changes to the API specification, we have a small test suite that validates that the changes are not breaking — namely by generating a Java client and compiling this client. You can (and should) run the test locally:

    $ docker-compose build --no-cache && docker-compose run specs /usr/share/blog/specs/java_compile.sh
