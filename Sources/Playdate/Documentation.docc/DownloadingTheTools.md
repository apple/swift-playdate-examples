# Downloading the Tools

Get the software needed to build games for the Playdate in Swift. 

## Overview

To build games for the Playdate, you will need to download a Swift toolchain and the Playdate SDK, and then clone and update the configuration of this package.  

## Download and install a Swift nightly toolchain

1. Navigate to the Swift.org > Downloads > Snapshots > Trunk Development (main) subsection of the [Swift.org downloads page](https://www.swift.org/download/#snapshots) using your preferred browser.
2. Select the Xcode "Universal" link to download the latest Swift nightly toolchain.
@Image(source: "swift-org-downloads-page", alt: "A screenshot of the swift.org downloads page in Safari focused on the \"Snapshots\" subheading.")

3. Open and install the Swift nightly toolchain package. This file should have a name in the format "swift-DEVELOPMENT-SNAPSHOT-202X-XX-XX-a-osx.pkg". Installing this package requires administrative privileges and may open a password or Touch ID prompt.
@Image(source: "swift-toolchain-package", alt: "A screenshot of the downloaded Swift nightly toolchain package in Finder.")

4. You should see the following window if the Swift nightly toolchain was installed successfully: 
@Image(source: "swift-installation-successful", alt: "A screenshot of the Swift nightly toolchain package installer success screen.")

5. The installed Swift Toolchain can be found under `/Library/Developer/Toolchains` if **Install for all users on this computer** was selected, or under `$HOME/Library/Developer/Toolchains` if **Install for me only** was selected.
    
    You can find all installed toolchains in both directories with the following command:

  ```console
  $ find /Library/Developer/Toolchains ~/Library/Developer/Toolchains -depth 1 -print 2>/dev/null
  ```

See <doc:BuildingTheExamples#Selecting-a-Toolchain> for details on how to obtain a Swift toolchain's identifier. 

## Download and install the Playdate SDK
 
1. Navigate to the Play.date > Dev [page](https://play.date/dev/) using your preferred browser.

2. Read and agree to the License then check the the "I agree to the Playdate SDK License." checkmark box. Select "Download Playdate SDK 2.1.1" to download the SDK.
@Image(source: "playdate-downloads-page", alt: "A screenshot of the play.date/dev downloads page in Safari.")

3. Open and install the Playdate SDK package. Installing this package requires administrative privileges and may open a password or Touch ID prompt.
@Image(source: "playdate-toolchain-package", alt: "A screenshot of the downloaded SDK package in Finder.")

> Note: Installing the Playdate SDK will also install an ARM GCC Toolchain under `/usr/local/bin`, as well as the Xcode Command Line Tools if they are not already present on your host machine.

4. You should see the following window if the Playdate SDK was installed successfully: 
@Image(source: "playdate-installation-successful", alt: "A screenshot of the Playdate SDK package installer success screen.")

5. The installed Playdate SDK can be found under `$HOME/Developer/PlaydateSDK`.
```console
$ ls $HOME/Developer/PlaydateSDK
C_API                       Designing for Playdate.html Inside Playdate             PlaydateSDK.docset          SDK_LICENSE.md
CoreLibs                    Disk                        Inside Playdate with C.html README.md                   VERSION.txt
Designing for Playdate      Examples                    Inside Playdate.html        Resources                   bin
```
@Image(source: "playdate-sdk-content", alt: "A screenshot of a Terminal application showing the result of the ls command.")

## Clone the Swift Playdate package

Clone this repository from GitHub to your local machine, using a Git client or the `git` command-line tool.

```console
$ git clone https://github.com/apple/swift-playdate-examples.git
Cloning into 'swift-playdate-examples'...
remote: Enumerating objects: 654, done.
remote: Counting objects: 100% (312/312), done.
remote: Compressing objects: 100% (146/146), done.
remote: Total 654 (delta 188), reused 214 (delta 128), pack-reused 342
Receiving objects: 100% (654/654), 7.71 MiB | 400.00 KiB/s, done.
Resolving deltas: 100% (269/269), done.
```
