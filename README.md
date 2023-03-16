# DDD Design pattern

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)


Thanks to the Mason team for creating a great library.<br/>
The purpose of this library is to simplify the implementation of DDD architecture logic, making it easier to test and reuse.

This script is designed for [https://github.com/cogivn/flutter](https://github.com/cogivn/flutter/tree/develop) source code(branch=develop). You should use the above source code for full features and compatibility with the source code.

If you want to configure an existing project manually, consider adding the following libraries:
 - enum_generator: https://github.com/cogivn/enum-generator
 - injectable: https://pub.dev/packages/injectable
 - flutter_config_plus: https://pub.dev/packages/flutter_config_plus
 
and environment management file:

```dart
import 'package:flutter_config_plus/flutter_config_plus.dart';
import 'package:injectable/injectable.dart';

typedef FlutterConfig = FlutterConfigPlus;

class AppEnvironment {
  static setup() async {
    await FlutterConfig.loadEnvVariables();
  }

  static final flavor = FlutterConfig.get('FLAVOR');
  static final packageName = FlutterConfig.get('PACKAGE_NAME');
  static final bundleId = FlutterConfig.get('BUNDLE_ID');
  static final apiUrl = FlutterConfig.get('API_URL');
  static final appName = FlutterConfig.get('APP_NAME');

  static const alpha = 'ALPHA';
  static const dev = 'DEV';
  static const prg = 'PRG';
  static const uat = 'UAT';
  static const prd = 'PRD';

  static const environments = [dev, prg, uat, prd];
}
const alpha = Environment(AppEnvironment.alpha);
```

## Getting Started 🚀

### Installation 
```gradle
# 🎯 Activate from https://pub.dev
dart pub global activate mason_cli

# 🍺 Or install from https://brew.sh
brew tap felangel/mason
brew install mason
```
### Initializing 
Open the terminal and navigate to the directory where you want Mason to generate the files. Then, type:
```gradle
mason init
```
Running mason init will generate a `mason.yaml` so you can get started right away. <br/> You can copy the file content below and paste it in your file
```dart
# Register 
# From git
# bricks which can be consumed via the Mason CLI.
# https://github.com/felangel/mason
bricks:
  # Sample Brick
  # Run `mason make hello` to try it out.
  
  # Bricks can also be imported via git url.
  # Uncomment the following lines to import
  # a brick from a remote git url.
   ddd:
     git:
       url: https://github.com/cogivn/ddd.git
       path: bricks/ddd
# From brickhub.dev
```mason add ddd```
```
Next, get all bricks registered in mason.yaml via:
```dart
mason get
```
❗ Note: **DO NOT** commit the .mason directory. **DO** commit the mason-lock.json file when working with versioned bricks (git/hosted).

### Command Line Variables 
Any variables can be passed as command line args.
```dart
 mason make ddd
```
or 
```dart
mason make ddd --name [module_name] // example: mason make ddd --name newsfeed
```
### Custom Output Directory 
By default mason make will generate the template in the current working directory but a custom output directory can be specified via the -o option:
```dart
mason make ddd --name newsfeed -o ./path/to/directory
```

### File Conflict Resolution 
By default, mason make will prompt on each file conflict and will allow users to specify how the conflict should be resolved via Yyna:
```dart
y - yes, overwrite (default)
Y - yes, overwrite this and all others
n - no, do not overwrite
a - append to existing file
```
A custom file conflict resolution strategy can be specified via the --on-conflict option:
```dart
# Generate a new brick in the current directory.
mason new <BRICK_NAME>

# Generate a new brick with a custom description.
mason new <BRICK_NAME> --desc "My awesome, new brick!"

# Generate a new brick with hooks.
mason new <BRICK_NAME> --hooks

# Generate a new brick in custom path.
mason new <BRICK_NAME> --output-dir ./path/to/brick

# Generate a new brick in custom path shorthand syntax.
mason new <BRICK_NAME> -o ./path/to/brick
```

