### v4.0.9 (2021-03-26)

#### 🏡 Internal

* [#92](https://github.com/groupon/cson-parser/pull/92) chore: switch to main & update packages ([@aaarichter](https://github.com/aaarichter)) 


### v4.0.8 (2021-02-17)

#### 🔼 Dependencies

* [#91](https://github.com/groupon/cson-parser/pull/91) chore(deps): bump ini from 1.3.5 to 1.3.7 ([@dependabot[bot]](https://github.com/apps/dependabot)) 


### v4.0.7 (2020-11-23)

#### 🔼 Dependencies

* [#90](https://github.com/groupon/cson-parser/pull/90) chore: freeze coffeescript@1.12.7 ([@aaarichter](https://github.com/aaarichter)) 


### v4.0.6 (2020-11-19)

#### 🏡 Internal

* [#87](https://github.com/groupon/cson-parser/pull/87) chore(deps): update packages & drop node 8 support ([@aaarichter](https://github.com/aaarichter)) 


### 4.0.5

* chore(deps): bump lodash from 4.17.15 to 4.17.19 - **[@dependabot[bot]](https://github.com/apps/dependabot)** [#85](https://github.com/groupon/cson-parser/pull/85)
  - [`d67a0cc`](https://github.com/groupon/cson-parser/commit/d67a0cc7c47fe4d7baf55e83cd7bcd8cc9edc8cb) **chore:** bump lodash from 4.17.15 to 4.17.19 - see: [4](- [Commits](https://github.com/lodash/lodash/compare/4)
* chore(deps): bump acorn from 7.1.0 to 7.1.1 - **[@dependabot[bot]](https://github.com/apps/dependabot)** [#84](https://github.com/groupon/cson-parser/pull/84)
  - [`b834a15`](https://github.com/groupon/cson-parser/commit/b834a15a2a7233d8d314d4a2a782047e327b1d2b) **chore:** bump acorn from 7.1.0 to 7.1.1 - see: [7](- [Commits](https://github.com/acornjs/acorn/compare/7)


### 4.0.4

* fix: address ltgm.com & remove superfluous arguments - **[@aaarichter](https://github.com/aaarichter)** [#83](https://github.com/groupon/cson-parser/pull/83)
  - [`feb4690`](https://github.com/groupon/cson-parser/commit/feb4690ce9cde04392d51441b8c606689106d66e) **fix:** address ltgm.com & remove superfluous arguments


### 4.0.3

* add type declarations - **[@dbushong](https://github.com/dbushong)** [#82](https://github.com/groupon/cson-parser/pull/82)
  - [`7ec3754`](https://github.com/groupon/cson-parser/commit/7ec375418c15c23bfc4c291fdb0f3b05e34b85bb) **chore:** upgrade deps & syntax
  - [`4e337d2`](https://github.com/groupon/cson-parser/commit/4e337d29e5329daa105a57c601677194c8b2bc28) **chore:** npm audit fix
  - [`13884e5`](https://github.com/groupon/cson-parser/commit/13884e59fe98f71d0fe5647185b5b716a93d2252) **fix:** add type declarations
  - [`3288839`](https://github.com/groupon/cson-parser/commit/3288839413a06cfae03aea854c0969d444ef2b74) **chore:** upgrade assertive
  - [`e0bfc47`](https://github.com/groupon/cson-parser/commit/e0bfc47b10b9a0969ab5d8bc98c6a8d4579ab44b) **test:** fix tests on node 12
  - [`b7c596d`](https://github.com/groupon/cson-parser/commit/b7c596d5a841ec7aaf822a5e599e048b7b15339c) **chore:** remove travis npm6 install


### 4.0.2

* chore: Remove yarn check that breaks people - **[@jkrems](https://github.com/jkrems)** [#77](https://github.com/groupon/cson-parser/pull/77)
  - [`4938d26`](https://github.com/groupon/cson-parser/commit/4938d2602c739cc53e2581f090e99ace7167bf24) **chore:** Remove yarn check that breaks people - see: [groupon//github.com/groupon/cson-parser/issues/74#issuecomment-438339958](https://github.com/groupon//github.com/groupon/cson-parser/issues/74/issues/issuecomment-438339958)


### 4.0.1

* insert backslash to double quotes instead of triple quotes - **[@richardtks](https://github.com/richardtks)** [#76](https://github.com/groupon/cson-parser/pull/76)
  - [`b0229a6`](https://github.com/groupon/cson-parser/commit/b0229a6e6442fdc15e9af03ff520681f0332642d) **fix:** replace double quotes instead triple quotes


### 4.0.0

#### Breaking Changes

This removes support for Node 4 as well as for bundling the library for the browser without compilation.

*See: [`24a8ba8`](https://github.com/groupon/cson-parser/commit/24a8ba813a6d494a0a00d52e43deeb00c42d090b)*

#### Commits

* Fix audited packages, support Node 10, drop support for Node 4 - **[@markowsiak](https://github.com/markowsiak)** [#73](https://github.com/groupon/cson-parser/pull/73)
  - [`66756aa`](https://github.com/groupon/cson-parser/commit/66756aa129c8a63a2ed5fa8514f4d63de3675d3f) **chore:** update packages from audit
  - [`24a8ba8`](https://github.com/groupon/cson-parser/commit/24a8ba813a6d494a0a00d52e43deeb00c42d090b) **chore:** support node 10, drop support node 4
  - [`16800e3`](https://github.com/groupon/cson-parser/commit/16800e3517885a8d3c670bfbdb2206109e6f40f6) **chore:** use npm 6


### 3.0.0

#### Breaking Changes

Since coffeescript contains a conflicting `./bin`
symlink for the `coffee` command line tool, do *not* install this
version of `cson-parser` while you still have `coffee-script`
anywhere in your dependency tree.

*See: [`1d49f3b`](https://github.com/groupon/cson-parser/commit/1d49f3b648a4c475c44f2789d0b54b316d9c1cd8)*

#### Commits

* chore: Use coffeescript instead of coffee-script - **[@jkrems](https://github.com/jkrems)** [#70](https://github.com/groupon/cson-parser/pull/70)
  - [`1d49f3b`](https://github.com/groupon/cson-parser/commit/1d49f3b648a4c475c44f2789d0b54b316d9c1cd8) **chore:** Use coffeescript instead of coffee-script - see: [#67](https://github.com/groupon/cson-parser/issues/67)


### 2.0.1

* Apply latest nlm generator - **[@markowsiak](https://github.com/markowsiak)** [#69](https://github.com/groupon/cson-parser/pull/69)
  - [`42a70eb`](https://github.com/groupon/cson-parser/commit/42a70eb38e5e3475a89ad4b67ebad34b1c3a1dc6) **chore:** Apply latest nlm generator


### 2.0.0

#### Breaking Changes

The default used to be double quotes.

See the discussion here: https://github.com/groupon/cson-parser/issues/62

*See: [`0d1679f`](https://github.com/groupon/cson-parser/commit/0d1679fb5ada081c428e23b7fb3df2c7093b6c11)*

#### Commits

* Make single quotes the default in stringify - **[@samestep](https://github.com/samestep)** [#63](https://github.com/groupon/cson-parser/pull/63)
  - [`0d1679f`](https://github.com/groupon/cson-parser/commit/0d1679fb5ada081c428e23b7fb3df2c7093b6c11) **feat:** Make single quotes the default in stringify


### 1.3.5

* Modernize library - **[@jkrems](https://github.com/jkrems)** [#60](https://github.com/groupon/cson-parser/pull/60)
  - [`dea5fac`](https://github.com/groupon/cson-parser/commit/dea5facb26bb84dcab01c34909d9b59d6c70bd76) **chore:** Bump devDependencies
  - [`727c1f6`](https://github.com/groupon/cson-parser/commit/727c1f6c79954e3f54f786027e8da5b6f958ca02) **refactor:** Port to JavaScript
  - [`1c29287`](https://github.com/groupon/cson-parser/commit/1c29287034f3dbafed72f2e9b76655756574260f) **chore:** Fix license header filter


### 1.3.4

* Compatible with coffee-script 1.11.0 - **[@jkrems](https://github.com/jkrems)** [#57](https://github.com/groupon/cson-parser/pull/57)
  - [`ed54c9a`](https://github.com/groupon/cson-parser/commit/ed54c9a89b3afb933c2eee1281e17fd6d78e8dba) **fix:** Compatible with coffee-script 1.11.0 - see: [#56](https://github.com/groupon/cson-parser/issues/56)


### 1.3.3

* Apply latest nlm generator - **[@i-tier-bot](https://github.com/i-tier-bot)** [#55](https://github.com/groupon/cson-parser/pull/55)
  - [`9905e06`](https://github.com/groupon/cson-parser/commit/9905e064f85f2cad7c656821195ea4afcd37f11f) **chore:** Apply latest nlm generator


### 1.3.2

* Parser no longer requires support for constructor.name - **[@jkrems](https://github.com/jkrems)** [#52](https://github.com/groupon/cson-parser/pull/52)
  - [`c5591b3`](https://github.com/groupon/cson-parser/commit/c5591b3a8ce0ba88a3e7738f940263ef053e7145) **fix:** Handle missing fn.name


### 1.3.1

* chore: Move to nlm for publishing - **[@jkrems](https://github.com/jkrems)** [#50](https://github.com/groupon/cson-parser/pull/50)
  - [`3c704a4`](https://github.com/groupon/cson-parser/commit/3c704a4e796b6d997a4aea499ac7d85bfe9fffe6) **chore:** Move to nlm for publishing


1.3.0
-----
* Add support for regular expressions - @jkrems
  https://github.com/groupon/cson-parser/pull/49

1.2.0
-----
* Use flexible coffee-script version - @jkrems
  https://github.com/groupon/cson-parser/pull/47

1.1.1
-----
* Support key with empty object - @charlierudolph
  https://github.com/groupon/cson-parser/pull/42

1.1.0
-----
* Add fs-cson to readme - @charlierudolph
  https://github.com/groupon/cson-parser/pull/39
* Proper CSON single-line formatting - @charlierudolph
  https://github.com/groupon/cson-parser/pull/37

1.0.9
-----
* Escape backslash in multi-line string - @jkrems
  https://github.com/groupon/cson-parser/pull/35
* Pin coffee-script version to 1.9.0 - @jkrems
  https://github.com/groupon/cson-parser/pull/33

1.0.8
-----
* Run against iojs - @jkrems #27

1.0.7
-----
* Added CSON package which now uses cson-parser - @balupton
  https://github.com/groupon/cson-parser/pull/25

1.0.6
-----
* Rename to cson-parser - @jkrems
  https://github.com/groupon/cson-parser/pull/23

1.0.5
-----
* Be explicit about registry for publish - @jkrems
  https://github.com/groupon/cson-safe/pull/19
* Unify `''`/`""` handling, str.charAt(0) -> str[0] - @jkrems
  https://github.com/groupon/cson-safe/pull/22

1.0.4
-----
* Use `vm.runInThisContext` instead of eval - @jkrems
  https://github.com/groupon/cson-safe/pull/18

1.0.3
-----
* Add license SPDX ID to package.json - @jkrems
  https://github.com/groupon/cson-safe/pull/16

1.0.2
-----
* Upgrade npub - @abloom
  https://github.com/groupon/cson-safe/pull/14

v1.0.1
------
* Even nicer stringify with less noise - @jkrems
  https://github.com/groupon/cson-safe/pull/13

v1.0.0
------
* Switch to coffee-script for parsing - @jkrems
  https://github.com/groupon/cson-safe/pull/10

v0.2.0
------
* A nicer CSON.stringify - @johan
  https://github.com/groupon/cson-safe/pull/9

v0.1.1
------
* Fix package meta data

v0.1.0
------
* Initial public release
