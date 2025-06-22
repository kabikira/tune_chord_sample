# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **guitar chord management Flutter application** called "tune_chord_sample" that allows users to manage custom guitar tunings and store chord fingerings (called CodeForms). The app is bilingual (English/Japanese) and uses modern Flutter architecture patterns.

## Development Commands

### Setup and Dependencies
```bash
make setup                    # Clean and get dependencies
flutter pub get              # Get dependencies only
```

### Code Generation
```bash
make flutter_generate        # Full code generation pipeline (recommended)
# Or individual steps:
flutter gen-l10n             # Generate localizations
dart run import_sorter:main  # Sort imports
dart run flutter_launcher_icons # Generate app icons
dart run build_runner build --delete-conflicting-outputs # Generate database code
```

### Building
```bash
flutter run                  # Run in debug mode
flutter build apk           # Build Android APK
make submit_android         # Build Android App Bundle
make submit_ios            # Prepare iOS build
```

### Testing and Quality
```bash
flutter test               # Run tests
flutter analyze           # Static analysis
```

## Architecture Overview

### State Management
- **Primary**: `hooks_riverpod` with `flutter_hooks`
- **Pattern**: StateNotifier (migrating to AsyncNotifier)
- **Database**: Accessed through `appDatabaseProvider`

### Database Layer (Drift ORM)
- **Main Database**: `AppDatabase` in `lib/src/db/app_database.dart`
- **Core Tables**: 
  - `Tunings`: Guitar tuning configurations
  - `CodeForms`: Chord fingerings linked to tunings
  - `Tags`: Categorization system
  - Junction tables for many-to-many relationships
- **Code Generation**: Required after schema changes via `build_runner`

### Navigation
- **Router**: `go_router` with declarative routing
- **Structure**: Bottom navigation with 3 tabs (Tuning, Search, Settings)
- **Configuration**: `lib/src/router/app_router.dart`

### Key Domain Models

**Tuning Entity**:
- Represents guitar tuning (e.g., "CGDGCD")
- Has many CodeForms
- Properties: name, strings, memo, isFavorite, timestamps

**CodeForm Entity**:
- Individual chord fingerings for specific tunings
- Belongs to one Tuning
- Properties: tuningId (FK), fretPositions, label, memo, isFavorite

## Project Structure

```
lib/src/
├── db/              # Drift database definitions and DAOs
├── pages/           # UI screens organized by feature
│   ├── codeForm/    # Chord form CRUD screens
│   ├── tuning/      # Tuning management screens
│   ├── search/      # Search functionality
│   └── settings/    # App settings
├── router/          # Go router configuration
└── config/          # App constants and validation rules
```

## Development Patterns

### State Management Pattern
```dart
// Typical notifier structure
@riverpod
class TuningNotifier extends _$TuningNotifier {
  @override
  Future<List<Tuning>> build() async {
    return ref.read(appDatabaseProvider).getAllTunings();
  }
}
```

### Database Access Pattern
```dart
// Access database through provider
final database = ref.read(appDatabaseProvider);
final tunings = await database.getAllTunings();
```

### Navigation Pattern
```dart
// Use context.go for navigation
context.go('/tuning/${tuning.id}/codeForm/create');
```

## Important Implementation Notes

### Code Generation Requirements
- Run `make flutter_generate` or `dart run build_runner build --delete-conflicting-outputs` after:
  - Database schema changes
  - Adding new localization strings
  - Modifying Riverpod providers with generators

### Color Theming
- Currently migrating from `withOpacity` to `withAlpha`/`withValues(alpha:)`
- Use `withValues(alpha: value)` for new color transparency implementations

### Architecture Migration in Progress
- StateNotifier → AsyncNotifier migration (check TODO comments)
- Complete this migration when working with state management code

### Localization
- Supports English and Japanese
- Localization files in `lib/l10n/`
- Generate after string changes with `flutter gen-l10n`

## Testing Notes

- Test coverage is minimal (only default widget test exists)
- When adding tests, follow Flutter testing patterns
- Database tests should use in-memory database instances