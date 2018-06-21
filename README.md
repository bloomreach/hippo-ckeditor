# CKEditor 4 for Hippo CMS

## Hippo-specific modifications

This repository contains Hippo-specific modifications of CKEditor 4.
The build includes only the plugins used in Hippo CMS (see dev/builder/build-config.js).

### External plugins

The following external plugins are included:

  - [codemirror](https://github.com/onehippo/CKEditor-CodeMirror-Plugin)
  - [textselection](https://github.com/onehippo/CKEditor-TextSelection-Plugin)
  - [wordcount](https://github.com/onehippo/CKEditor-WordCount-Plugin)
  - [youtube](https://github.com/onehippo/ckeditor-youtube-plugin)

## Versions

A Hippo-specific CKEditor build adds a semantic version to the CKEditor version it extends, prefixed with `-h`.
The major and minor number of this additional version match the Hippo release in which the CKEditor build is used. 
For example, version `4.7.1-h12.1.0` extends CKEditor `4.7.1` and is used in Hippo release `12.1`. The patch number 
(`0` in this example) is used to version the Hippo-specific CKEditor changes in that branch.  

Each branch `hippo/<version>` contains all commits in the CKEditor branch `release/<version>` plus all Hippo-specific 
modifications. 

There can be separate maintenance branches that contain Hippo-specific modifications limited to a specific Hippo 
release. For example, the branch `hippo/release/12.0` would contain the Hippo CKEditor version for Hippo 12.0. The 
`hippo/<version>` branch acts as the `master` branch for the next Hippo release.   

A release is available in a tag are named `hippo/<version>`, e.g. `hippo/4.7.1-h12.1.0`. 

The script `/dev/builder/build.sh` needs a 'build version' parameter, which is burned into the generated code.
Hippo CMS uses the same version number as in the tag name (e.g. '4.7.1-h12.1.0').

Note that the version scheme of Hippo CKEditor changed over time. Until Hippo 11.x, the CKEditor version was extended 
with a single nano patch version prefixed with `-h` (e.g. `4.3.0-h1`). Hippo 12.x introduced the semantic Hippo-specific
version and the maintenance branches.

### Upstream changes

To get upstream changes, first add a remote for the upstream CKEditor repository:

    git remote add -f upstream https://github.com/ckeditor/ckeditor-dev.git

Upstream changes can now be merged into the current hippo-specific branch. Make sure to merge the upstream branch
with the same version number. For example:

    git fetch upstream
    git checkout hippo/4.3.x
    git merge upstream/release/4.3.x

When a new patch version is released upstream, its tag can be merged into the matching hippo-specific branch.
For example, to merge upstream tag 4.4.5:

    git fetch upstream
    git checkout hippo/4.4.x
    git merge 4.4.5

When a new minor version is released upstream, a new hippo-specific branch should be created based on the upstream
branch. All hippo-specific customizations in the previous branch can then be merged into the new one. The new
branch must be pushed to origin, so other people can fetch it too. For example, to upgrade from 4.3.x to 4.4.x:

    git fetch upstream
    git checkout release/4.4.x
    git checkout -b hippo/4.4.x
    git merge hippo/4.3.x
    git push origin hippo/4.4.x

### Deployment to Nexus

Prerequisites:

  - [NodeJS (6.x.x)](https://nodejs.org/)
  - [npm](https://www.npmjs.com/)
  - [Maven](http://maven.apache.org/)

Deployment command:

    mvn clean deploy

## External plugin management

Only a part of each external plugin's code has to be included in the Hippo CKEditor build,
i.e. the part that should to into the CKEditor subdirectory `plugins/XXX`.

The Maven build makes sure the dependencies are pulled in via node package manager (npm) and then copied to
the plugins directory using npm and the `dev/builder/build.sh` script.

### Adding a new external plugin

Adding an external plugin can be done by including them in the `dependencies`
property of the `package.json.` If the external plugin does not contain a (valid)
`package.json` file then you need to fork the github repository under the onehippo
github group and add the `package.json` yourself.

Make sure to copy the plugin code from `node_modules/` to `plugins/` in `dev/builder/build.sh`.
Add the plugin to the configuration of the Maven clean plugin in `pom.xml` so the copied sources 
will be cleaned too.

### Updating an external plugin

Updating an external plugin can be done by publishing a new version of the
plugin (see that plugin's README) to the hippo npm registry and then bumping to that version in the
`package.json`.

## The remainder of this file contains the unmodified CKEditor README

[![devDependencies Status](https://david-dm.org/ckeditor/ckeditor-dev/dev-status.svg)](https://david-dm.org/ckeditor/ckeditor-dev?type=dev)

This repository contains the development version of CKEditor 4.

**Attention:** The code in this repository should be used locally and for
development purposes only. We do not recommend using it in production environment
because the user experience will be very limited. For that purpose, you should
either build the editor (see below) or use an official release available on the
[CKEditor website](https://ckeditor.com/ckeditor-4/).

## Code Installation

There is no special installation procedure to install the development code.
Simply clone it to any local directory and you are set.

## Available Branches

This repository contains the following branches:

  - **master** &ndash; Development of the upcoming minor release.
  - **major** &ndash; Development of the upcoming major release.
  - **stable** &ndash; Latest stable release tag point (non-beta).
  - **latest** &ndash; Latest release tag point (including betas).
  - **release/A.B.x** (e.g. 4.0.x, 4.1.x) &ndash; Release freeze, tests and tagging.
    Hotfixing.

Note that both **master** and **major** are under heavy development. Their
code did not pass the release testing phase, though, so it may be unstable.

Additionally, all releases have their respective tags in the following form: 4.4.0,
4.4.1, etc.

## Samples

The `samples/` folder contains some examples that can be used to test your
installation. Visit [CKEditor 4 SDK](https://sdk.ckeditor.com/) for plenty of samples
showcasing numerous editor features, with source code readily available to view, copy
and use in your own solution.

## Code Structure

The development code contains the following main elements:

  - Main coding folders:
    - `core/` &ndash; The core API of CKEditor 4. Alone, it does nothing, but
    it provides the entire JavaScript API that makes the magic happen.
    - `plugins/` &ndash; Contains most of the plugins maintained by the CKEditor 4 core team.
    - `skin/` &ndash; Contains the official default skin of CKEditor 4.
    - `dev/` &ndash; Contains some developer tools.
    - `tests/` &ndash; Contains the CKEditor 4 tests suite.

## Building a Release

A release-optimized version of the development code can be easily created
locally. The `dev/builder/build.sh` script can be used for that purpose:

	> ./dev/builder/build.sh

A "release ready" working copy of your development code will be built in the new
`dev/builder/release/` folder. An Internet connection is necessary to run the
builder, for its first time at least.

## Testing Environment

Read more on how to set up the environment and execute tests in the [CKEditor 4 Testing Environment](https://docs.ckeditor.com/ckeditor4/docs/#!/guide/dev_tests) guide.

## Reporting Issues

Please use the [CKEditor 4 GitHub issue page](https://github.com/ckeditor/ckeditor-dev/issues) to report bugs and feature requests.

## License

Copyright (c) 2003-2018, CKSource - Frederico Knabben. All rights reserved.

For licensing, see LICENSE.md or [https://ckeditor.com/legal/ckeditor-oss-license](https://ckeditor.com/legal/ckeditor-oss-license)
