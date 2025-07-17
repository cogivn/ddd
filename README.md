# Domain Driven Design (DDD) Brick

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

## Overview

This Mason brick helps you quickly scaffold a complete Domain-Driven Design (DDD) module structure for Flutter applications. It generates all necessary layers and files following clean architecture principles, allowing you to focus on implementing business logic rather than setting up architecture boilerplate.

The generated structure follows best practices for separation of concerns with distinct layers for:
- Domain (entities, repositories interfaces)
- Application (state management)
- Infrastructure (repository implementations, DTOs)
- Presentation (UI components)

## Features

- Supports multiple state management solutions:
  - BLoC/Cubit
  - RiverBLoC
  - Riverpod
- Generates complete DDD folder structure
- Creates entity classes, repository interfaces, and implementations
- Sets up DTOs with freezed for JSON serialization
- Configures state management boilerplate based on your preferred solution
- Implements mock repositories for testing
- Provides consistent error handling with API error responses
- **Supports fast generation of common modules:** `auth`, `reset`, `otp`, `register`, ...

## Prerequisites

This brick is optimized for the [cogivn/flutter](https://github.com/cogivn/flutter/tree/develop) source code. For full compatibility, it's recommended to use the develop branch of that repository.

If configuring an existing project manually, add these dependencies:
- [enum_generator](https://github.com/cogivn/enum-generator)
- [injectable](https://pub.dev/packages/injectable)
- [flutter_config_plus](https://pub.dev/packages/flutter_config_plus)
- [result_dart](https://pub.dev/packages/result_dart)

You'll also need an environment management file:

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

## Installation

### Installing the Mason CLI

```bash
# Via Dart pub
dart pub global activate mason_cli

# Or via Homebrew on macOS
brew tap felangel/mason
brew install mason
```

### Setting Up Mason in Your Project

Initialize Mason in your Flutter project:

```bash
mason init
```

### Adding the DDD Brick

You can add the DDD brick to your project in several ways:

#### From GitHub

Add the following to your `mason.yaml`:

```yaml
bricks:
  ddd:
    git:
      url: https://github.com/cogivn/ddd.git
      path: bricks/ddd
```

#### From BrickHub

```bash
mason add ddd
# Or add globally
mason add -g ddd
```

After adding the brick, fetch all registered bricks:

```bash
mason get
```

> **Note**: When working with versioned bricks, commit the `mason-lock.json` file but not the `.mason` directory.

## Usage

### Basic Usage

Generate a new DDD module with:

```bash
mason make ddd
```

This will prompt you for:
- The module name
- The state management provider to use (bloc, riverbloc, or riverpod)

### Command Line Arguments

You can also specify parameters directly:

```bash
mason make ddd --name newsfeed --provider riverpod
```

Available arguments:
- `--name`: The name of your module (required)
- `--provider`: The state management approach to use (`bloc`, `riverbloc`, or `riverpod`)

### Custom Output Directory

Specify a custom output directory with the `-o` option:

```bash
mason make ddd --name newsfeed --provider bloc -o lib/features
```

## Generating Common Modules (auth, reset, otp, register, ...)

To speed up development, we provide ready-to-use bricks for common modules such as `auth`, `reset`, `otp`, `register`, etc. These bricks follow the same DDD structure and best practices, but are pre-configured for their specific use cases.

### Supported Modules

| Module           | Description                | Localization Support | Notes                         |
|------------------|----------------------------|---------------------|-------------------------------|
| auth             | Authentication flow        | Yes                 | Includes merge_l10n_keys.dart |
| reset            | Password reset flow        | Yes                 | Includes merge_l10n_keys.dart |
| otp              | OTP verification           | Yes                 | Includes merge_l10n_keys.dart |
| register         | User registration          | No                  |                               |
| change_email     | Change email address       | No                  |                               |
| change_password  | Change password            | No                  |                               |
| delete_account   | Delete user account        | No                  |                               |

### How to Use

1. Add the desired brick to your `mason.yaml` (if not already present):

```yaml
bricks:
  auth:
    path: bricks/auth
  reset:
    path: bricks/reset
  otp:
    path: bricks/otp
  register:
    path: bricks/register
  change_email:
    path: bricks/change_email
  change_password:
    path: bricks/change_password
  delete_account:
    path: bricks/delete_account
```

2. Run `mason get` to fetch the bricks:

```bash
mason get
```

3. Generate the module using the corresponding brick. For example, to generate the `auth` module:

```bash
mason make auth
```

You may be prompted for additional options depending on the brick (e.g., module name, localization, etc.).

> **Tip:** For bricks with localization (auth, otp, reset), after generation, run the provided script to merge localization keys if needed. Example:
>
> ```bash
> dart bricks/auth/merge_l10n_keys.dart
> ```

Repeat the process for other modules (`reset`, `otp`, `register`, ...), replacing `auth` with the desired module name.

## Generated Structure

For a module named `post`, the brick will generate:

```
post/
├── application/          # State management layer
│   └── post_cubit/       # Or post_notifier for Riverpod
│       ├── post_cubit.dart
│       └── post_state.dart
├── domain/               # Business logic & rules
│   ├── entities/
│   │   └── post.dart
│   └── repositories/
│       └── post_repository.dart
├── infrastructure/        # Implementation details
│   ├── dtos/
│   │   └── post_dto.dart
│   └── repositories/
│       ├── post_repository_impl.dart
│       └── post_repository_mock.dart
└── presentation/         # UI layer
    ├── pages/
    │   └── post_page.dart
    └── widgets/
        └── post_body.dart
```

## File Conflict Resolution

When generating files, Mason will prompt for conflict resolution:

```
y - yes, overwrite (default)
Y - yes, overwrite this and all others
n - no, do not overwrite
a - append to existing file
```

You can specify a default behavior using the `--on-conflict` option.

## Contributing

We welcome contributions! If you find bugs or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
