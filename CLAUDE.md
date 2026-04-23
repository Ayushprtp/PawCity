# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PawCity is a Flutter mobile app for finding pet-friendly urban spots. It uses Supabase for backend, Riverpod for state management, and Firebase for notifications.

## Commands

```bash
# Run app
flutter run

# Run tests
flutter test

# Run single test
flutter test test/widget_test.dart

# Code generation (riverpod, freezed, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter pub run build_runner watch

# Lint
flutter analyze

# Format
dart format .
```

## Architecture

**State Management:** Riverpod with code generation
- Providers in `lib/providers/` use `@riverpod` annotations
- Generated files (`.g.dart`) must be rebuilt after provider changes
- `ref.watch()` for reactive UI updates

**Navigation:** go_router with named routes
- Route names defined in `lib/core/router/route_names.dart`
- Routes configured in `lib/core/router/app_router.dart`
- Auth redirect logic handles onboarding flow

**Data Layer:** Repository pattern
```
UI (screens) → Providers → Repositories → Services → Supabase/Local
```

**Models:** Freezed for immutability + json_serializable
- Models use `@freezed` with generated `.freezed.dart` and `.g.dart` files
- Run `build_runner` after model changes

**Key Directories:**
- `lib/features/` — Feature modules (auth, pets, shop, spots, paw_patrol, etc.)
- `lib/core/` — Shared infrastructure (router, theme, constants)
- `lib/shared/` — Reusable widgets and utilities
- `lib/services/` — Business logic (AuthService, SupabaseService, etc.)
- `lib/repositories/` — Data access layer

**External Services:**
- Supabase: Authentication + database
- Firebase: Push notifications
- PostHog: Analytics
- flutter_map + OpenStreetMap: Map features
- FreeRoute: Routing
