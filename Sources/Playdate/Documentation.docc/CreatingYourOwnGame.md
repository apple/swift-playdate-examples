# Creating Your Own Game

Bring your ideas to life

## Overview

This repository includes a "Template" example which provides an a great starting point for creating your own game.

1. Duplicate the Template example folder and rename it to the name of your game. This guide will use the name "MyGame".

```console
$ cp -r Examples/Template Examples/MyGame
```

2. Update the pdxinfo file with the name of your game, your name, a short description, and a reverse dns style bundle ID. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/Source/pdxinfo b/Examples/MyGame/Source/pdxinfo
index d58d20a..1fe58e6 100644
--- a/Examples/MyGame/Source/pdxinfo
+++ b/Examples/MyGame/Source/pdxinfo
@@ -1,5 +1,5 @@
-name={{Game's name}}
-author={{Your name}}
-description={{A short description of the game}}
-bundleID={{A reverse dns-style id, e.g. com.<your-name>.<game-name>}}
+name=MyGame
+author=Jane Appleseed
+description=My first game for Playdate in Swift
+bundleID=com.jane-appleseed.mygame
 imagePath=
```

3. Update the Makefile with the name of your game. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/Makefile b/Examples/MyGame/Makefile
index 9254c46..19eb205 100755
--- a/Examples/MyGame/Makefile
+++ b/Examples/MyGame/Makefile
@@ -1,5 +1,5 @@
 REPO_ROOT := $(shell git rev-parse --show-toplevel)
-PRODUCT := {{Game name}}.pdx
+PRODUCT := MyGame.pdx
 SRC += $(REPO_ROOT)/Sources/CPlaydate/posix_memalign.c
 include $(REPO_ROOT)/Examples/swift.mk
```

4. Update the Nova Playdate Simulator extension configuration with the name of your game. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/.nova/Tasks/Playdate Simulator.json b/Examples/MyGame/.nova/Tasks/Playdate Simulator.json
index 51f6383..1e3fd6b 100644
--- a/Examples/MyGame/.nova/Tasks/Playdate Simulator.json  
+++ b/Examples/MyGame/.nova/Tasks/Playdate Simulator.json  
@@ -7,6 +7,6 @@
   "extensionValues" : {
     "playdate.build-type" : "make",
     "playdate.debugRequest" : "launch",
-    "playdate.product-name" : "{{Game Name}}"
+    "playdate.product-name" : "MyGame"
   }
 }
```

5. Update the VSCode tasks configuration with the name of your game. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/.vscode/tasks.json b/Examples/MyGame/.vscode/tasks.json
index 902dae5..a4dfb53 100644
--- a/Examples/MyGame/.vscode/tasks.json
+++ b/Examples/MyGame/.vscode/tasks.json
@@ -6,7 +6,7 @@
         {
             "label": "build",
             "type": "shell",
-            "command": "make && $HOME/Developer/PlaydateSDK/bin/Playdate\\ Simulator.app/Contents/MacOS/Playdate\\ Simulator {{Game Name}}.pdx",
+            "command": "make && $HOME/Developer/PlaydateSDK/bin/Playdate\\ Simulator.app/Contents/MacOS/Playdate\\ Simulator MyGame.pdx",
         }
     ]
 }
```

6. Update the Package.swift file with the name of your game. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/Package.swift b/Examples/MyGame/Package.swift
index 5cc2b02..6b9275c 100644
--- a/Examples/MyGame/Package.swift
+++ b/Examples/MyGame/Package.swift
@@ -24,16 +24,16 @@ let swiftSettingsSimulator: [SwiftSetting] = [
 ]
 
 let package = Package(
-  name: "{{Game Name}}",
+  name: "MyGame",
   products: [
-    .library(name: "{{Game Name}}", targets: ["{{Game Name}}"]),
+    .library(name: "MyGame", targets: ["MyGame"]),
   ],
   dependencies: [
     .package(path: "../.."),
   ],
   targets: [
     .target(
-      name: "{{Game Name}}",
+      name: "MyGame",
       dependencies: [
         .product(name: "Playdate", package: "swift-playdate-examples")
       ],
```

7. Update the xcscheme file name and content with the name of your game. The resulting diff should look similar to the following snippet.

```diff
diff --git a/Examples/MyGame/.swiftpm/xcode/xcshareddata/xcschemes/Template.xcscheme b/Examples/MyGame/.swiftpm/xcode/xcshareddata/xcschemes/MyGame.xcscheme
index 867fae9..f8814ab 100644
--- a/Examples/MyGame/.swiftpm/xcode/xcshareddata/xcschemes/Template.xcscheme
+++ b/Examples/MyGame/.swiftpm/xcode/xcshareddata/xcschemes/MyGame.xcscheme
@@ -15,9 +15,9 @@
             buildForAnalyzing = "YES">
             <BuildableReference
                BuildableIdentifier = "primary"
-               BlueprintIdentifier = "{{Game Name}}"
-               BuildableName = "{{Game Name}}"
-               BlueprintName = "{{Game Name}}"
+               BlueprintIdentifier = "MyGame"
+               BuildableName = "MyGame"
+               BlueprintName = "MyGame"
                ReferencedContainer = "container:">
             </BuildableReference>
          </BuildActionEntry>
```

8. Open your game directory in your favorite editor and start building your game. `Game.swift` contains a simple skeleton serves a starting point.
