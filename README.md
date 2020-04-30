# CKEditor 4 for Hippo CMS

## Hippo-specific modifications

This repository contains Hippo-specific modifications of CKEditor 4.
The build includes only the plugins used in Hippo CMS (see dev/builder/build-config.js).
The code for the hippopicker plugin resides in the hippo-cms project.

### External plugins

The following external plugins are included:

  - [codemirror](https://github.com/w8tcha/CKEditor-CodeMirror-Plugin)
  - [textselection](https://github.com/w8tcha/CKEditor-TextSelection-Plugin)
  - [wordcount](https://github.com/w8tcha/CKEditor-WordCount-Plugin)
  - [youtube](https://code.onehippo.org/cms-community-dev/ckeditor-youtube-plugin)

## Versions

### Script and version

The script `/dev/builder/build.sh` needs a 'build version' parameter, which is burned into the generated code.
Hippo CMS uses the same version number as in the tag name (e.g. '4.9.2-h1').

A Hippo-specific CKEditor build adds a version number to the CKEditor version it extends, prefixed with `-h`.
For example, version `4.9.2-h1` extends CKEditor `4.9.2`. The patch number
(`1` in this example) is used to version the Hippo-specific CKEditor changes in that branch.

Each branch `hippo/<version>` contains all commits in the CKEditor branch `release/<version>` plus all Hippo-specific
modifications.

### Get upstream changes

To get upstream changes, first add a remote for the upstream CKEditor repository:

    git remote add -f upstream https://github.com/ckeditor/ckeditor4.git

When a new patch version is released upstream, its tag can be merged into the matching hippo-specific branch.
For example, to merge upstream tag 4.9.3:

    git fetch upstream
    git checkout hippo/4.9.x
    git merge 4.9.3

When a new minor version is released upstream, a new hippo-specific branch should be created based on the current latest
hippo branch. The new upstream tag can then be merged into the new hippo branch. The new branch must be pushed to
origin, so other people can fetch it too. For example, to upgrade from 4.9.x to 4.10.0:

    git fetch upstream
    git checkout hippo/4.9.x
    git checkout -b hippo/4.10.x
    git merge 4.10.0
    git push origin -u hippo/4.10.x

Update the version number of the project if necessary (e.g when moving from 4.9.2 to 4.9.3). Also update the
ckeditor version in:
 - pom.xml
 - package-lock.json
 - the hippo-cms pom (located in a different git repository)

Add new branch to:
 - Jenkinsfile

### How to check CKEditor version in the browser

Open the devtools / console and type on the console command line:

    CKEDITOR.version

### Deployment to Nexus

Prerequisites:

  - [NodeJS](https://nodejs.org/)
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
# CKEditor 4 - Smart WYSIWYG HTML editor [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Check%20out%20CKEditor%204%20on%20GitHub&url=https%3A%2F%2Fgithub.com%2Fckeditor%2Fckeditor4)

[![npm version](https://badge.fury.io/js/ckeditor4.svg)](https://www.npmjs.com/package/ckeditor4)
[![GitHub tag](https://img.shields.io/github/tag/ckeditor/ckeditor4.svg)](https://github.com/ckeditor/ckeditor4)

[![Build Status](https://travis-ci.org/ckeditor/ckeditor4.svg?branch=major)](https://travis-ci.org/ckeditor/ckeditor4)
[![Dependencies](https://img.shields.io/david/ckeditor/ckeditor4.svg)](https://david-dm.org/ckeditor/ckeditor4)
[![Dev dependencies](https://img.shields.io/david/dev/ckeditor/ckeditor4.svg)](https://david-dm.org/ckeditor/ckeditor4?type=dev)

[![Join newsletter](https://img.shields.io/badge/join-newsletter-00cc99.svg)](http://eepurl.com/c3zRPr)
[![Follow Twitter](https://img.shields.io/badge/follow-twitter-00cc99.svg)](https://twitter.com/ckeditor)

A highly configurable WYSIWYG HTML editor with hundreds of features, from creating rich text content with captioned images, videos, tables, media embeds, emoji or mentions to pasting from Word and Google Docs and drag&drop image upload.

Supports a broad range of browsers, including legacy ones.

![CKEditor 4 screenshot](https://c.cksource.com/a/1/img/npm/ckeditor4.png)

## Getting started

### Using [npm package](https://www.npmjs.com/package/ckeditor)

```bash
npm install --save ckeditor
```

Use it on your website:

```html
<div id="editor">
    <p>This is the editor content.</p>
</div>
<script src="./node_modules/ckeditor/ckeditor.js"></script>
<script>
    CKEDITOR.replace( 'editor' );
</script>
```

### Using [CDN](https://cdn.ckeditor.com/#ckeditor4)

Load the CKEditor 4 script from CDN:

```html
<div id="editor">
    <p>This is the editor content.</p>
</div>
<script src="https://cdn.ckeditor.com/4.13.0/standard/ckeditor.js"></script>
<script>
    CKEDITOR.replace( 'editor' );
</script>
```

### Integrating with Angular and React

Refer to official usage guides for the [`ckeditor4-angular`](https://www.npmjs.com/package/ckeditor4-angular#usage) and [`ckeditor4-react`](https://www.npmjs.com/package/ckeditor4-react#usage) packages.

### Manual download

Visit the [CKEditor 4 download section](https://ckeditor.com/ckeditor-4/download/) on the [CKEditor website](https://ckeditor.com/ckeditor-4/) to download ready-to-use CKEditor 4 packages or to create a customized CKEditor 4 build.

## Features

* Over 500 plugins in the [Add-ons Repository](https://ckeditor.com/cke4/addons).
* Pasting from Microsoft Word, Excel and Google Docs.
* Drag&drop image uploads.
* Media embeds to insert videos, tweets, maps, slideshows.
* Powerful clipboard integration.
* Content quality control with Advanced Content Filter.
* Extensible widget system.
* Custom table selection.
* Accessibility conforming to WCAG and Section 508.
* Over 70 localizations available with full RTL support.

## Browser support

| [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/edge/edge_48x48.png" alt="IE / Edge" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>IE / Edge | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/firefox/firefox_48x48.png" alt="Firefox" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>Firefox | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/chrome/chrome_48x48.png" alt="Chrome" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>Chrome | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/chrome/chrome_48x48.png" alt="Chrome" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>Chrome (Android) | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/safari/safari_48x48.png" alt="Safari" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>Safari | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/safari-ios/safari-ios_48x48.png" alt="iOS Safari" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>iOS Safari | [<img src="https://raw.githubusercontent.com/alrra/browser-logos/master/src/opera/opera_48x48.png" alt="Opera" width="24px" height="24px" />](http://godban.github.io/browsers-support-badges/)</br>Opera |
| --------- | --------- | --------- | --------- | --------- | --------- | --------- |
| IE8, IE9, IE10, IE11, Edge| latest version| latest version| latest version| latest version| latest version| latest version

Find out more in the [Browser Compatibility guide](https://ckeditor.com/docs/ckeditor4/latest/guide/dev_browsers.html#officially-supported-browsers).

---

## Working with the `ckeditor4` repostiory

**Attention**: The code in this repository should be used locally and for development purposes only. We do not recommend using it in a production environment because the user experience will be very limited.

### Code installation

There is no special installation procedure to install the development code.
Simply clone it to any local directory and you are set.

### Available branches

This repository contains the following branches:

  - **`master`** &ndash; Development of the upcoming minor release.
  - **`major`** &ndash; Development of the upcoming major release.
  - **`stable`** &ndash; Latest stable release tag point (non-beta).
  - **`latest`** &ndash; Latest release tag point (including betas).
  - **`release/A.B.x`** (e.g. `4.0.x`, `4.1.x`) &ndash; Release freeze, tests and tagging. Hotfixing.

Note that both `master` and `major` are under heavy development. Their code did not pass the release testing phase, though, so it may be unstable.

Additionally, all releases have their respective tags in the following form: `4.4.0`, `4.4.1`, etc.

### Samples

The `samples/` folder contains some examples that can be used to test your installation. Visit [CKEditor 4 Examples](https://ckeditor.com/docs/ckeditor4/latest/examples/index.html) for plenty of samples showcasing numerous editor features, with source code readily available to view, copy and use in your own solution.

### Code structure

The development code contains the following main elements:

  - Main coding folders:
    - `core/` &ndash; The core API of CKEditor 4. Alone, it does nothing, but it provides the entire JavaScript API that makes the magic happen.
    - `plugins/` &ndash; Contains most of the plugins maintained by the CKEditor 4 core team.
    - `skin/` &ndash; Contains the official default skin of CKEditor 4.
    - `dev/` &ndash; Contains some developer tools.
    - `tests/` &ndash; Contains the CKEditor 4 tests suite.

### Building a release

A release-optimized version of the development code can be easily created locally. The `dev/builder/build.sh` script can be used for that purpose:

	> ./dev/builder/build.sh

A "release-ready" working copy of your development code will be built in the new `dev/builder/release/` folder. An Internet connection is necessary to run the builder, for the first time at least.

### Testing environment

Read more on how to set up the environment and execute tests in the [CKEditor 4 Testing Environment](https://ckeditor.com/docs/ckeditor4/latest/guide/dev_tests.html) guide.

### Reporting issues

Use the [CKEditor 4 GitHub issue page](https://github.com/ckeditor/ckeditor4/issues) to report bugs and feature requests.

### License

Copyright (c) 2003-2020, CKSource - Frederico Knabben. All rights reserved.

For licensing, see LICENSE.md or [https://ckeditor.com/legal/ckeditor-oss-license](https://ckeditor.com/legal/ckeditor-oss-license)
