# Swift Framework Template

[![Build Status](https://travis-ci.org/xmartlabs/Swift-Framework-Template.svg?branch=master)](https://travis-ci.org/xmartlabs/Swift-Framework-Template)

Swift script to easily create Swift frameworks! Speed up your iOS open source library creation time!

At Xmartlabs we've been doing Open Source since our beginning and we ❤️ it. Creating a successful open source project involves many tasks, obviously the most important is to have a well designed problem specific library that is worth using and helps the community to save a lot of development time.

Typically we began creating a well structured Xcode workspace, which means it should have a framework project along with its unit test target, an Example project, a Playground file to play with the library among other things. Also the schemas must be shared to be able to run tests on travis CI.

There are many many other tedious tasks to do before getting ready to start working on the core library code, which is what really matters.
* Set up travis (`.travis.yml`) to automatically build the project and run its tests.
* Create a `CHANGELOG.md` file. Probably we will not have much to add on it in the first library version but it's a good practice to have one from the beginning.
* `CONTRIBUTING.md` file to provide a contributing guideline.
* Add a MIT license file ;).
* Set up git environment by adding a `.gitignore`, setting up the git remote url and making the first commit.
* Provide cocoapods support by creating a podspec file.

Apart of saving a lot of time it's important for us to be consistent on how our team creates open source libraries regardless who does it.
