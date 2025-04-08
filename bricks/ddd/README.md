# Domain-Driven Design (DDD) Brick

A Mason brick for quickly scaffolding Domain-Driven Design modules in Flutter applications.

## Features

- Generates complete DDD folder structure with all required layers
- Supports three state management approaches:
  - BLoC/Cubit
  - RiverBLoC
  - Riverpod
- Creates entity classes, repository interfaces and implementations
- Sets up DTOs with freezed for JSON serialization
- Configures state management boilerplate based on your chosen approach
- Provides consistent error handling with API error responses

## Installation

To install this brick:

```bash
mason add ddd
```

Or add it directly to your `mason.yaml`:

```yaml
bricks:
  ddd:
    git:
      url: https://github.com/cogivn/ddd.git
      path: bricks/ddd
```

## Usage

Generate a new DDD module with:

```bash
mason make ddd --name yourModuleName --provider bloc
```

Available provider options:
- `bloc` - Uses traditional BLoC pattern with Cubit
- `riverbloc` - Uses RiverBLoC (BLoC with Riverpod integration)
- `riverpod` - Uses pure Riverpod with notifiers

## Generated Structure

```
your_module/
├── application/          # State management layer
│   └── your_module_cubit/ or your_module_notifier/
├── domain/               # Business logic & rules
│   ├── entities/
│   └── repositories/
├── infrastructure/        # Implementation details
│   ├── dtos/
│   └── repositories/
└── presentation/         # UI layer
    ├── pages/
    └── widgets/
```

## Requirements

For full functionality, your project should include:
- Injectable for dependency injection
- Freezed for immutable state
- Result_dart for functional error handling
- Appropriate state management libraries based on your choice

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
