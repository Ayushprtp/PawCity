# CLAUDE.md — PawsCity Flutter App

> **Instructions for Claude Code:** Read this entire file before writing a single line of code.
> This is the single source of truth for architecture, folder structure, naming conventions,
> feature scope, and implementation order. Follow it exactly.

---

## 📱 Project Overview

**App Name:** PawsCity
**Tagline:** Discover. Explore. Wag.
**Type:** Flutter mobile app (Android + iOS)
**Backend:** Supabase (Auth + PostgreSQL + PostGIS + Realtime + Storage)
**Analytics:** PostHog
**State Management:** Riverpod (flutter_riverpod + riverpod_annotation)
**Navigation:** GoRouter
**Maps:** Google Maps Flutter + google_maps_flutter
**Theme:** Material 3

PawsCity is a community-powered platform for urban pet parents to:
1. Discover pet-friendly restaurants, parks, vets, grooming, and boarding
2. Submit and review pet-friendly spots
3. Manage pet profiles with health records and QR ID tags
4. Report animal misconduct, stray dog incidents, and pet abuse via **Paw Patrol**
5. Broadcast lost pet SOS alerts to nearby users

---

## 🗂️ Folder Structure

```
pawscity/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart                        # MaterialApp + GoRouter + ProviderScope
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_sizes.dart
│   │   │   └── supabase_keys.dart      # env-injected, never hardcode
│   │   ├── extensions/
│   │   │   ├── context_ext.dart
│   │   │   ├── string_ext.dart
│   │   │   └── datetime_ext.dart
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_colors.dart
│   │   └── utils/
│   │       ├── location_utils.dart
│   │       ├── image_utils.dart
│   │       └── qr_utils.dart
│   │
│   ├── services/
│   │   ├── supabase_service.dart       # singleton Supabase client wrapper
│   │   ├── auth_service.dart
│   │   ├── storage_service.dart        # Supabase Storage uploads
│   │   ├── location_service.dart       # geolocator wrapper
│   │   ├── notification_service.dart   # FCM + local notifications
│   │   ├── posthog_service.dart        # PostHog analytics wrapper
│   │   └── realtime_service.dart       # Supabase Realtime channels
│   │
│   ├── models/
│   │   ├── spot.dart
│   │   ├── review.dart
│   │   ├── pet.dart
│   │   ├── user_profile.dart
│   │   ├── paw_patrol_report.dart
│   │   ├── lost_pet_alert.dart
│   │   └── notification_model.dart
│   │
│   ├── repositories/
│   │   ├── spots_repository.dart
│   │   ├── reviews_repository.dart
│   │   ├── pets_repository.dart
│   │   ├── users_repository.dart
│   │   ├── paw_patrol_repository.dart
│   │   └── lost_pet_repository.dart
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── spots_provider.dart
│   │   ├── pets_provider.dart
│   │   ├── paw_patrol_provider.dart
│   │   ├── lost_pet_provider.dart
│   │   └── location_provider.dart
│   │
│   └── features/
│       ├── auth/
│       │   ├── screens/
│       │   │   ├── splash_screen.dart
│       │   │   ├── onboarding_screen.dart
│       │   │   ├── login_screen.dart
│       │   │   └── register_screen.dart
│       │   └── widgets/
│       │
│       ├── home/
│       │   ├── screens/
│       │   │   └── home_screen.dart    # Bottom nav shell
│       │   └── widgets/
│       │       └── bottom_nav_bar.dart
│       │
│       ├── map/
│       │   ├── screens/
│       │   │   └── map_screen.dart
│       │   └── widgets/
│       │       ├── spot_map_pin.dart
│       │       ├── spot_filter_sheet.dart
│       │       └── spot_preview_card.dart
│       │
│       ├── spots/
│       │   ├── screens/
│       │   │   ├── spots_list_screen.dart
│       │   │   ├── spot_detail_screen.dart
│       │   │   └── submit_spot_screen.dart
│       │   └── widgets/
│       │       ├── spot_card.dart
│       │       ├── spot_amenity_chip.dart
│       │       ├── spot_review_tile.dart
│       │       └── pet_policy_badge.dart
│       │
│       ├── pets/
│       │   ├── screens/
│       │   │   ├── pets_screen.dart
│       │   │   ├── pet_profile_screen.dart
│       │   │   ├── add_pet_screen.dart
│       │   │   └── pet_health_card_screen.dart
│       │   └── widgets/
│       │       ├── pet_avatar.dart
│       │       ├── qr_id_card.dart
│       │       └── health_record_tile.dart
│       │
│       ├── paw_patrol/
│       │   ├── screens/
│       │   │   ├── paw_patrol_screen.dart       # Feed of reports
│       │   │   ├── report_detail_screen.dart    # Full report view
│       │   │   ├── submit_report_screen.dart    # Submit new report
│       │   │   └── report_map_screen.dart       # Map of all reports
│       │   └── widgets/
│       │       ├── report_card.dart
│       │       ├── report_status_badge.dart
│       │       ├── media_upload_grid.dart       # photos + video upload
│       │       ├── report_category_selector.dart
│       │       ├── severity_indicator.dart
│       │       └── authority_tag_chip.dart
│       │
│       ├── lost_pet/
│       │   ├── screens/
│       │   │   ├── lost_pet_screen.dart
│       │   │   ├── lost_pet_detail_screen.dart
│       │   │   └── report_lost_pet_screen.dart
│       │   └── widgets/
│       │       └── lost_pet_alert_card.dart
│       │
│       ├── profile/
│       │   ├── screens/
│       │   │   ├── profile_screen.dart
│       │   │   └── edit_profile_screen.dart
│       │   └── widgets/
│       │       ├── paw_points_card.dart
│       │       └── badge_collection.dart
│       │
│       └── notifications/
│           ├── screens/
│           │   └── notifications_screen.dart
│           └── widgets/
│               └── notification_tile.dart
│
├── test/
├── pubspec.yaml
├── .env                                # NEVER commit — gitignored
└── CLAUDE.md
```

---

## 📦 pubspec.yaml Dependencies

```yaml
name: pawscity
description: Pet-Friendly Urban Spots Finder
publish_to: none
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.5.0

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.0.0

  # Analytics
  posthog_flutter: ^4.0.0

  # Maps
  google_maps_flutter: ^2.6.1
  geolocator: ^12.0.0
  geocoding: ^3.0.0

  # Media
  image_picker: ^1.1.2
  video_player: ^2.8.6
  chewie: ^1.8.3
  cached_network_image: ^3.3.1
  photo_view: ^0.14.0
  flutter_image_compress: ^2.2.0

  # QR Code
  qr_flutter: ^4.1.0
  mobile_scanner: ^5.1.0

  # Notifications
  firebase_core: ^3.1.0
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.1.2

  # UI Utilities
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  lottie: ^3.1.0
  badges: ^3.1.2
  dotted_border: ^2.1.0
  fl_chart: ^0.68.0

  # Forms & Validation
  reactive_forms: ^17.0.1

  # Utilities
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  uuid: ^4.4.0
  intl: ^0.19.0
  timeago: ^3.7.0
  url_launcher: ^6.3.0
  share_plus: ^9.0.0
  permission_handler: ^11.3.1
  connectivity_plus: ^6.0.3
  flutter_dotenv: ^5.1.0
  hive_flutter: ^1.1.0            # local cache
  path_provider: ^2.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  flutter_lints: ^4.0.0
  mocktail: ^1.0.4
```

---

## 🗄️ Supabase Schema (Run in SQL Editor)

```sql
-- ============================================================
-- EXTENSIONS
-- ============================================================
create extension if not exists postgis;
create extension if not exists "uuid-ossp";

-- ============================================================
-- ENUMS
-- ============================================================
create type spot_category as enum (
  'restaurant', 'cafe', 'park', 'vet', 'grooming',
  'boarding', 'pet_store', 'hotel', 'beach', 'trail'
);

create type pet_policy as enum (
  'inside_allowed', 'outside_only', 'all_areas', 'leash_required'
);

create type pet_type as enum (
  'dog', 'cat', 'bird', 'rabbit', 'fish', 'reptile', 'other'
);

create type report_category as enum (
  'stray_dog_aggressive',
  'stray_dog_injured',
  'stray_dog_pack',
  'animal_abuse',
  'animal_abandonment',
  'pet_cruelty',
  'illegal_breeding',
  'poisoning_attempt',
  'road_accident_animal',
  'other_misconduct'
);

create type report_severity as enum ('low', 'medium', 'high', 'critical');

create type report_status as enum (
  'submitted', 'under_review', 'assigned', 'in_progress',
  'resolved', 'closed', 'rejected'
);

create type authority_type as enum (
  'municipal_corporation', 'animal_welfare_board',
  'ngo', 'police', 'forest_dept', 'veterinary_dept'
);

-- ============================================================
-- USERS / PROFILES
-- ============================================================
create table public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  username      text unique not null,
  display_name  text,
  avatar_url    text,
  city          text,
  bio           text,
  paw_points    integer default 0,
  is_ngo        boolean default false,
  is_authority  boolean default false,
  org_name      text,                      -- for NGO/authority accounts
  org_verified  boolean default false,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

alter table public.profiles enable row level security;
create policy "Profiles are viewable by everyone" on public.profiles for select using (true);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- ============================================================
-- SPOTS
-- ============================================================
create table public.spots (
  id              uuid primary key default uuid_generate_v4(),
  name            text not null,
  description     text,
  category        spot_category not null,
  address         text,
  city            text not null,
  lat             double precision not null,
  lng             double precision not null,
  location        geography(Point, 4326) generated always as (
                    st_point(lng, lat)::geography
                  ) stored,
  pet_policy      pet_policy,
  pet_types_allowed  pet_type[],
  amenities       text[],                  -- ['water_bowl','off_leash','pet_menu','waste_bin']
  phone           text,
  website         text,
  opening_hours   jsonb,                   -- {mon: "9:00-22:00", ...}
  cover_image_url text,
  photo_urls      text[],
  rating          numeric(3,2) default 0,
  review_count    integer default 0,
  is_verified     boolean default false,
  verified_at     timestamptz,
  submitted_by    uuid references public.profiles(id),
  is_active       boolean default true,
  created_at      timestamptz default now(),
  updated_at      timestamptz default now()
);

create index spots_location_idx on public.spots using gist(location);
create index spots_city_idx on public.spots(city);
create index spots_category_idx on public.spots(category);

alter table public.spots enable row level security;
create policy "Spots viewable by all" on public.spots for select using (is_active = true);
create policy "Authenticated users can submit spots" on public.spots for insert
  with check (auth.uid() = submitted_by);

-- ============================================================
-- REVIEWS
-- ============================================================
create table public.reviews (
  id            uuid primary key default uuid_generate_v4(),
  spot_id       uuid not null references public.spots(id) on delete cascade,
  user_id       uuid not null references public.profiles(id) on delete cascade,
  pet_id        uuid,                      -- which pet they visited with
  pet_type      pet_type,
  rating        integer not null check (rating between 1 and 5),
  comment       text,
  photo_urls    text[],
  helpful_count integer default 0,
  visited_at    date,
  created_at    timestamptz default now(),
  unique(spot_id, user_id)
);

alter table public.reviews enable row level security;
create policy "Reviews viewable by all" on public.reviews for select using (true);
create policy "Users can create reviews" on public.reviews for insert with check (auth.uid() = user_id);
create policy "Users can update own reviews" on public.reviews for update using (auth.uid() = user_id);

-- Auto-update spot rating on review insert/update
create or replace function update_spot_rating()
returns trigger language plpgsql as $$
begin
  update public.spots set
    rating = (select avg(rating) from public.reviews where spot_id = NEW.spot_id),
    review_count = (select count(*) from public.reviews where spot_id = NEW.spot_id),
    updated_at = now()
  where id = NEW.spot_id;
  return NEW;
end;
$$;

create trigger on_review_change
  after insert or update on public.reviews
  for each row execute function update_spot_rating();

-- ============================================================
-- PETS
-- ============================================================
create table public.pets (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references public.profiles(id) on delete cascade,
  name            text not null,
  type            pet_type not null,
  breed           text,
  date_of_birth   date,
  gender          text,
  weight_kg       numeric(5,2),
  color           text,
  photo_url       text,
  microchip_id    text,
  qr_code_id      text unique default uuid_generate_v4()::text,
  is_active       boolean default true,
  created_at      timestamptz default now()
);

alter table public.pets enable row level security;
create policy "Users can view own pets" on public.pets for select using (auth.uid() = user_id);
create policy "Public QR lookup" on public.pets for select using (true);  -- needed for QR scan
create policy "Users can manage own pets" on public.pets for all using (auth.uid() = user_id);

-- ============================================================
-- PET HEALTH RECORDS
-- ============================================================
create table public.health_records (
  id            uuid primary key default uuid_generate_v4(),
  pet_id        uuid not null references public.pets(id) on delete cascade,
  record_type   text not null,             -- 'vaccine', 'checkup', 'medication', 'surgery', 'allergy'
  title         text not null,
  description   text,
  vet_name      text,
  date          date not null,
  next_due_date date,
  document_url  text,
  created_at    timestamptz default now()
);

alter table public.health_records enable row level security;
create policy "Users can manage pet health records" on public.health_records
  for all using (
    auth.uid() = (select user_id from public.pets where id = pet_id)
  );

-- ============================================================
-- PAW PATROL REPORTS
-- ============================================================
create table public.paw_patrol_reports (
  id                uuid primary key default uuid_generate_v4(),
  reporter_id       uuid not null references public.profiles(id),
  category          report_category not null,
  severity          report_severity not null default 'medium',
  title             text not null,
  description       text not null,
  lat               double precision not null,
  lng               double precision not null,
  location          geography(Point, 4326) generated always as (
                      st_point(lng, lat)::geography
                    ) stored,
  address           text,
  city              text not null,
  photo_urls        text[],
  video_urls        text[],
  animal_count      integer default 1,
  animal_description text,
  status            report_status default 'submitted',
  assigned_to       uuid references public.profiles(id),   -- NGO/authority profile
  assigned_org      text,
  authority_notified authority_type[],
  resolution_note   text,
  resolved_at       timestamptz,
  upvotes           integer default 0,
  is_anonymous      boolean default false,
  created_at        timestamptz default now(),
  updated_at        timestamptz default now()
);

create index paw_patrol_location_idx on public.paw_patrol_reports using gist(location);
create index paw_patrol_status_idx on public.paw_patrol_reports(status);
create index paw_patrol_city_idx on public.paw_patrol_reports(city);
create index paw_patrol_category_idx on public.paw_patrol_reports(category);

alter table public.paw_patrol_reports enable row level security;
create policy "Reports viewable by all" on public.paw_patrol_reports for select using (true);
create policy "Authenticated users can submit reports" on public.paw_patrol_reports
  for insert with check (auth.uid() = reporter_id);
create policy "Reporter can update own report" on public.paw_patrol_reports
  for update using (auth.uid() = reporter_id);
create policy "Authority/NGO can update assigned reports" on public.paw_patrol_reports
  for update using (
    auth.uid() = assigned_to or
    exists (select 1 from public.profiles where id = auth.uid() and (is_authority or is_ngo))
  );

-- ============================================================
-- PAW PATROL REPORT UPDATES (status timeline)
-- ============================================================
create table public.report_updates (
  id            uuid primary key default uuid_generate_v4(),
  report_id     uuid not null references public.paw_patrol_reports(id) on delete cascade,
  updated_by    uuid not null references public.profiles(id),
  old_status    report_status,
  new_status    report_status not null,
  note          text,
  photo_urls    text[],
  created_at    timestamptz default now()
);

alter table public.report_updates enable row level security;
create policy "Updates viewable by all" on public.report_updates for select using (true);
create policy "Authenticated users can add updates" on public.report_updates
  for insert with check (auth.uid() = updated_by);

-- ============================================================
-- LOST PET ALERTS
-- ============================================================
create table public.lost_pet_alerts (
  id              uuid primary key default uuid_generate_v4(),
  user_id         uuid not null references public.profiles(id),
  pet_id          uuid references public.pets(id),
  pet_name        text not null,
  pet_type        pet_type not null,
  pet_breed       text,
  pet_description text not null,
  pet_photo_url   text,
  last_seen_lat   double precision not null,
  last_seen_lng   double precision not null,
  last_seen_location geography(Point, 4326) generated always as (
                    st_point(last_seen_lng, last_seen_lat)::geography
                  ) stored,
  last_seen_address text,
  last_seen_at    timestamptz,
  contact_phone   text,
  reward_amount   numeric(10,2),
  is_found        boolean default false,
  found_at        timestamptz,
  created_at      timestamptz default now()
);

create index lost_pet_location_idx on public.lost_pet_alerts using gist(last_seen_location);

alter table public.lost_pet_alerts enable row level security;
create policy "Lost pet alerts viewable by all" on public.lost_pet_alerts for select using (true);
create policy "Users can manage own lost pet alerts" on public.lost_pet_alerts
  for all using (auth.uid() = user_id);

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
create table public.notifications (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  type          text not null,           -- 'lost_pet_nearby', 'report_update', 'new_spot', 'paw_patrol_update'
  title         text not null,
  body          text not null,
  data          jsonb,
  is_read       boolean default false,
  created_at    timestamptz default now()
);

alter table public.notifications enable row level security;
create policy "Users see own notifications" on public.notifications
  for all using (auth.uid() = user_id);

-- ============================================================
-- FAVORITES
-- ============================================================
create table public.favorites (
  user_id   uuid references public.profiles(id) on delete cascade,
  spot_id   uuid references public.spots(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, spot_id)
);

alter table public.favorites enable row level security;
create policy "Users manage own favorites" on public.favorites
  for all using (auth.uid() = user_id);

-- ============================================================
-- STORAGE BUCKETS (run via Supabase Dashboard or API)
-- ============================================================
-- Buckets needed:
--   spot-photos      (public, max 5MB, image/*)
--   review-photos    (public, max 5MB, image/*)
--   pet-photos       (public, max 3MB, image/*)
--   health-docs      (private, max 10MB, image/* + application/pdf)
--   paw-patrol-media (public, max 50MB, image/* + video/*)
--   avatars          (public, max 2MB, image/*)

-- ============================================================
-- REALTIME (enable via Dashboard > Database > Replication)
-- ============================================================
-- Enable Realtime on:
--   public.paw_patrol_reports
--   public.report_updates
--   public.lost_pet_alerts
--   public.notifications

-- ============================================================
-- USEFUL FUNCTIONS
-- ============================================================

-- Get spots within radius (meters)
create or replace function spots_within_radius(
  user_lat double precision,
  user_lng double precision,
  radius_meters integer default 5000,
  category_filter spot_category default null
)
returns table (
  id uuid, name text, category spot_category,
  lat double precision, lng double precision,
  rating numeric, review_count integer,
  pet_policy pet_policy, amenities text[],
  cover_image_url text, is_verified boolean,
  distance_meters double precision
) language sql as $$
  select
    s.id, s.name, s.category, s.lat, s.lng,
    s.rating, s.review_count, s.pet_policy, s.amenities,
    s.cover_image_url, s.is_verified,
    st_distance(s.location, st_point(user_lng, user_lat)::geography) as distance_meters
  from public.spots s
  where
    s.is_active = true
    and st_dwithin(s.location, st_point(user_lng, user_lat)::geography, radius_meters)
    and (category_filter is null or s.category = category_filter)
  order by distance_meters asc;
$$;

-- Get paw patrol reports within radius
create or replace function reports_within_radius(
  user_lat double precision,
  user_lng double precision,
  radius_meters integer default 10000
)
returns table (
  id uuid, category report_category, severity report_severity,
  title text, lat double precision, lng double precision,
  status report_status, photo_urls text[],
  animal_count integer, created_at timestamptz,
  distance_meters double precision
) language sql as $$
  select
    r.id, r.category, r.severity, r.title,
    r.lat, r.lng, r.status, r.photo_urls,
    r.animal_count, r.created_at,
    st_distance(r.location, st_point(user_lng, user_lat)::geography) as distance_meters
  from public.paw_patrol_reports r
  where
    st_dwithin(r.location, st_point(user_lng, user_lat)::geography, radius_meters)
    and r.status != 'closed'
  order by r.severity desc, distance_meters asc;
$$;
```

---

## 🔐 Environment Variables

Create a `.env` file at root (gitignored):

```env
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key
POSTHOG_API_KEY=your_posthog_key
POSTHOG_HOST=https://app.posthog.com
FCM_SENDER_ID=your_fcm_sender_id
```

Add to `.gitignore`:
```
.env
*.env
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

---

## 🎨 Design System

### Colors (`lib/core/theme/app_colors.dart`)

```dart
class AppColors {
  // Primary Palette
  static const primaryDark   = Color(0xFF111C24);  // Deep dark — title bg
  static const primaryGreen  = Color(0xFF1E6B45);  // Forest green
  static const amber         = Color(0xFFF4A031);  // Paw amber accent
  static const white         = Color(0xFFFFFFFF);
  static const lightBg       = Color(0xFFF7FAF8);  // Off-white content bg

  // Spot Categories
  static const restaurant    = Color(0xFFE74C3C);
  static const park          = Color(0xFF1E6B45);
  static const vet           = Color(0xFF3498DB);
  static const grooming      = Color(0xFF9B59B6);
  static const boarding      = Color(0xFF1ABC9C);
  static const petStore      = Color(0xFFF39C12);

  // Paw Patrol Severity
  static const severityLow      = Color(0xFF27AE60);
  static const severityMedium   = Color(0xFFF39C12);
  static const severityHigh     = Color(0xFFE67E22);
  static const severityCritical = Color(0xFFE74C3C);

  // Report Status
  static const statusSubmitted   = Color(0xFF95A5A6);
  static const statusReview      = Color(0xFF3498DB);
  static const statusAssigned    = Color(0xFF9B59B6);
  static const statusInProgress  = Color(0xFFF39C12);
  static const statusResolved    = Color(0xFF27AE60);
}
```

### Typography
- **Header Font:** Georgia or system serif for display titles
- **Body Font:** System sans-serif (San Francisco / Roboto)
- **Code/Mono:** Courier / system monospace

---

## 🧠 Core Architecture Rules

### 1. Riverpod Providers
- Use `@riverpod` annotation with code generation
- All async data: use `AsyncNotifier` or `FutureProvider`
- Never call Supabase directly from widgets — always through providers
- Always handle loading, error, and data states

### 2. Repository Pattern
- All DB calls go in `repositories/`
- Repositories return either `T` or throw typed exceptions
- Providers hold repositories via `ref.watch(repositoryProvider)`

### 3. Models
- All models use `@freezed` for immutability and copyWith
- All models have `fromJson` / `toJson` via `json_serializable`
- Enums match Supabase enum names exactly

### 4. Error Handling
- Create `AppException` sealed class with subtypes
- Show user-friendly `SnackBar` on errors — never raw exception messages
- Log all errors to PostHog as error events

### 5. Navigation
- All routes defined in `AppRouter` using GoRouter
- Named routes only — no anonymous pushes
- Auth guard on all protected routes

---

## 📊 PostHog Analytics (`lib/services/posthog_service.dart`)

```dart
// Track these events — implement all of them:

class PostHogEvents {
  // Auth
  static const userSignedUp        = 'user_signed_up';
  static const userLoggedIn        = 'user_logged_in';

  // Spots
  static const spotViewed          = 'spot_viewed';         // {spot_id, category, city}
  static const spotSearched        = 'spot_searched';       // {query, filters, city}
  static const spotSubmitted       = 'spot_submitted';      // {category, city}
  static const spotFilterApplied   = 'spot_filter_applied'; // {filter_type, value}
  static const spotFavorited       = 'spot_favorited';      // {spot_id, category}
  static const routePlanned        = 'route_planned';       // {spot_count, city}

  // Reviews
  static const reviewSubmitted     = 'review_submitted';    // {spot_id, rating}
  static const reviewPhotoAdded    = 'review_photo_added';

  // Pets
  static const petProfileCreated   = 'pet_profile_created'; // {pet_type, breed}
  static const petQrGenerated      = 'pet_qr_generated';
  static const healthRecordAdded   = 'health_record_added'; // {record_type}
  static const qrScanned           = 'qr_scanned';

  // Paw Patrol
  static const reportSubmitted     = 'paw_patrol_report_submitted'; // {category, severity, city}
  static const reportViewed        = 'paw_patrol_report_viewed';
  static const reportUpvoted       = 'paw_patrol_report_upvoted';
  static const reportShared        = 'paw_patrol_report_shared';
  static const authorityTagged     = 'authority_tagged';    // {authority_type}
  static const mediaUploadedToReport = 'media_uploaded';   // {type: photo/video, count}

  // Lost Pets
  static const lostPetAlertPosted  = 'lost_pet_alert_posted';
  static const lostPetAlertViewed  = 'lost_pet_alert_viewed';
  static const lostPetFoundMarked  = 'lost_pet_found_marked';

  // Engagement
  static const pawPointsEarned     = 'paw_points_earned';  // {action, points}
  static const badgeUnlocked       = 'badge_unlocked';     // {badge_id}
  static const checkInRecorded     = 'check_in_recorded';  // {spot_id}
}
```

Initialize PostHog in `main.dart`:
```dart
await Posthog().setup(
  apiKey: dotenv.env['POSTHOG_API_KEY']!,
  host: dotenv.env['POSTHOG_HOST']!,
);
```

---

## 🐾 PAW PATROL — Full Feature Spec

This is a critical feature. Implement it completely and carefully.

### Purpose
Paw Patrol allows any user to **report animal misconduct, stray dog incidents, abuse, abandonment**, and other animal welfare concerns. Reports include GPS coordinates, photos, and videos. Verified NGO and authority accounts can receive, claim, and update reports. The system creates a transparent accountability chain.

### Report Submission Flow (`submit_report_screen.dart`)

**Step 1 — Category & Severity**
- Show category grid with icons:
  - 🐕 Stray Dog (Aggressive)
  - 🤕 Stray Dog (Injured / Sick)
  - 🐶 Stray Dog Pack (Large group)
  - 😡 Animal Abuse / Cruelty
  - 🚫 Animal Abandonment
  - 🐾 Pet Cruelty by Owner
  - 🧪 Poisoning Attempt
  - 🚗 Road Accident (Animal)
  - 🏭 Illegal Breeding
  - ❓ Other Misconduct
- Severity selector: Low / Medium / High / Critical
- Auto-suggest severity based on category (e.g., Abuse → High default)

**Step 2 — Location**
- Auto-capture GPS on screen open
- Show map with draggable pin for precise location
- Reverse geocode to get address string
- "Use Current Location" button
- Manual address entry fallback

**Step 3 — Description & Animal Details**
- Title text field (required, max 100 chars)
- Description text area (required, min 20 chars)
- Animal count selector (1 / 2-5 / 6-10 / 10+)
- Animal description (color, size, condition)

**Step 4 — Media Upload**
- Upload up to **10 photos** (compress before upload)
- Upload up to **3 videos** (max 50MB each)
- Show upload progress indicators
- Preview grid with remove option
- Upload to Supabase Storage bucket: `paw-patrol-media`
- Store public URLs in `paw_patrol_reports.photo_urls` and `video_urls`

**Step 5 — Tag Authorities**
- Multi-select which authorities to notify:
  - Municipal Corporation
  - Animal Welfare Board of India (AWBI)
  - Local NGOs (fetched from verified NGO profiles)
  - Police (for cruelty cases)
  - Forest Department (for wildlife)
  - Veterinary Department
- Anonymous report toggle (hides reporter identity from public)

**Step 6 — Submit**
- Confirm summary screen
- On submit:
  - Insert to `paw_patrol_reports`
  - Send push notification to all NGO/authority accounts in same city
  - Send push notification to users within 5km radius
  - Track PostHog `paw_patrol_report_submitted` event

### Report Feed (`paw_patrol_screen.dart`)

**Two tabs:**
1. **Nearby** — Reports within 10km radius, sorted by severity then distance
2. **My City** — All reports in user's city, sorted by date

**Report Card** shows:
- First photo thumbnail (or placeholder icon)
- Category icon + color-coded severity badge
- Title + truncated description
- Distance + time ago
- Status badge (Submitted / In Progress / Resolved)
- Upvote count + upvote button
- Tap → Report Detail Screen

**Filter Bar:**
- Filter by: Category, Severity, Status, Date range
- Show count of active filters

### Report Detail Screen (`report_detail_screen.dart`)

- **Hero** — Swipeable photo/video gallery (full screen on tap)
  - Videos play inline using Chewie player
  - Photos support pinch-to-zoom via photo_view
- **Location section** — Static Google Maps showing report pin
  - "Get Directions" button → opens Google Maps
- **Status Timeline** — Vertical stepper showing all status updates with timestamp, note, and who updated
- **Animal Details** — Count, description, category icon
- **Tagged Authorities** — Chips showing which authorities were notified
- **Upvote Button** — Increment upvotes (one per user)
- **Share Button** — Deep link to report
- **Report Actions (NGO/Authority only):**
  - "Claim This Report" → sets `assigned_to` to current user
  - "Update Status" → opens status update bottom sheet
  - Upload resolution photos

### Status Update Flow (NGO/Authority accounts)
- Bottom sheet with:
  - New status selector (dropdown)
  - Note text field (required)
  - Photo upload (optional resolution proof)
- Creates entry in `report_updates` table
- Updates `paw_patrol_reports.status` and `updated_at`
- Sends push notification to reporter (if not anonymous)

### Paw Patrol Map (`report_map_screen.dart`)
- Full-screen Google Map
- Color-coded markers by severity:
  - 🟢 Green = Low
  - 🟡 Yellow = Medium
  - 🟠 Orange = High
  - 🔴 Red = Critical
- Marker tap → mini report preview card
- Heatmap overlay (optional, for density view)
- Filter panel overlay (category, status filters)

---

## 🗺️ Map Screen Spec (`map_screen.dart`)

- Full screen Google Map, dark style for night mode
- Clustered markers for spots (use `google_maps_cluster_manager` or custom)
- Bottom sheet opens on marker tap showing SpotPreviewCard
- Filter FAB → opens filter bottom sheet
- Category selector (horizontal scroll): All / 🍽️ Food / 🌳 Parks / 🏥 Vet / ✂️ Grooming / 🏠 Boarding
- "Near Me" button → animates camera to user location
- Spot pins colored by category (match `AppColors`)
- Toggle: Spots Map ↔ Paw Patrol Map (FAB or tab)

---

## 🏅 Gamification

**Paw Points** awarded for:
| Action | Points |
|--------|--------|
| Submit a spot | 50 |
| Write a review | 25 |
| Upload review photo | 10 |
| Check-in at a spot | 15 |
| Submit Paw Patrol report | 40 |
| Upload media to report | 20 |
| Report gets resolved | 30 (bonus) |
| Pet profile created | 20 |
| Health record added | 10 |
| Lost pet alert posted | 0 (civic duty) |

**Badges** (stored as JSON array in profiles or separate table):
- 🐾 First Steps — First spot visited
- 🗺️ Explorer — Visited 10 unique spots
- 📸 Shutterbug — Uploaded 20 review photos
- 🦸 Guardian — Submitted 5 Paw Patrol reports
- 🏥 Caretaker — Added 10 health records
- 🌟 Top Contributor — 500+ Paw Points
- 🏙️ City Expert — Reviewed spots in 3+ categories

---

## 🔔 Push Notifications (FCM)

Notification types to implement:

```dart
// 1. Lost pet nearby (within 5km)
title: "🚨 Lost Pet Alert Nearby"
body: "{pet_name} ({breed}) was last seen near you"

// 2. Paw Patrol report nearby (high/critical severity)
title: "⚠️ Animal Alert Near You"
body: "A {category} was reported {distance}m from you"

// 3. New pet-friendly spot in your city
title: "🐾 New Spot in {city}!"
body: "{spot_name} just joined PawsCity"

// 4. Report status update (to reporter)
title: "✅ Report Update"
body: "Your Paw Patrol report has been {status}"

// 5. Review helpful (to reviewer)
title: "👍 Your Review Was Helpful!"
body: "Someone found your review of {spot_name} helpful"
```

Store FCM token in `profiles` table (add `fcm_token text` column).

---

## 📐 Screen-by-Screen Implementation Order

Build in this exact order:

### Phase 1 — Foundation
1. `main.dart` — init Supabase, PostHog, Firebase, dotenv
2. `app.dart` — MaterialApp.router + GoRouter + ProviderScope
3. `app_theme.dart` — full Material 3 theme with AppColors
4. `supabase_service.dart` — singleton client
5. `auth_service.dart` — signIn, signUp, signOut, currentUser
6. `auth_provider.dart` — StreamProvider on auth state changes
7. `splash_screen.dart` — logo animation + auth redirect
8. `onboarding_screen.dart` — 3-page intro (Lottie animations)
9. `login_screen.dart` + `register_screen.dart`

### Phase 2 — Core Spot Discovery
10. `spot.dart` model + `spots_repository.dart`
11. `spots_provider.dart`
12. `home_screen.dart` — bottom nav shell (Map / Spots / PawPatrol / Pets / Profile)
13. `map_screen.dart` — basic Google Maps + spot pins
14. `spots_list_screen.dart` — list with search + filter
15. `spot_detail_screen.dart` — full detail + reviews
16. `submit_spot_screen.dart`
17. `spot_filter_sheet.dart`
18. `review_submission` — form + photo upload

### Phase 3 — Pet Profiles
19. `pet.dart` model + `pets_repository.dart`
20. `pets_screen.dart` — list of user's pets
21. `add_pet_screen.dart`
22. `pet_profile_screen.dart`
23. `health_record` models + screens
24. `qr_id_card.dart` — QR generation + display
25. `mobile_scanner` integration for QR scanning

### Phase 4 — Paw Patrol (Priority Feature)
26. `paw_patrol_report.dart` model + `paw_patrol_repository.dart`
27. `paw_patrol_provider.dart`
28. `paw_patrol_screen.dart` — feed with tabs
29. `submit_report_screen.dart` — full multi-step form
30. `media_upload_grid.dart` — photo + video upload widget
31. `report_detail_screen.dart` — gallery, map, timeline
32. `report_map_screen.dart` — severity-colored markers
33. Authority notification system (push + Supabase functions)
34. NGO/Authority status update flow

### Phase 5 — Lost Pet + Notifications
35. `lost_pet_alert.dart` model + repository
36. `lost_pet_screen.dart` + `report_lost_pet_screen.dart`
37. `notification_service.dart` — FCM setup
38. `notifications_screen.dart`
39. Realtime subscription for nearby alerts

### Phase 6 — Profile + Gamification
40. `profile_screen.dart` — paw points, badges, stats
41. `paw_points_card.dart`
42. `badge_collection.dart`
43. Paw Points calculation on actions
44. PostHog event tracking on all actions

---

## ✅ Code Quality Rules

1. **No hardcoded strings** — all UI strings in `app_strings.dart`
2. **No hardcoded colors** — always use `AppColors.*`
3. **No `setState` in complex screens** — use Riverpod
4. **Always dispose controllers** — use `ref.onDispose` in providers
5. **Never store API keys in code** — only from `.env`
6. **Compress images before upload** — use `flutter_image_compress`
7. **Handle internet connectivity** — show offline banner via `connectivity_plus`
8. **Loading states on every async operation** — no bare `FutureBuilder`
9. **All Supabase errors caught and shown** — never silent failures
10. **PostHog event on every meaningful user action**
11. **Media uploads show progress** — never silent background upload
12. **Videos in reports must show duration and thumbnail before play**
13. **Location permissions requested gracefully** — explain why before requesting
14. **Anonymous reports hide reporter name/avatar** from public view
15. **Paw Patrol reports with Critical severity** get an in-app banner notification for all users in same city

---

## 🚀 Supabase Edge Functions (Optional but Recommended)

Create these Edge Functions for server-side logic:

```
supabase/functions/
  notify-nearby-users/     # triggered on new lost_pet or critical paw_patrol report
  assign-report/           # assigns report to nearest available NGO
  calculate-paw-points/    # called after user actions to add points
  weekly-digest/           # weekly email to NGOs with unresolved reports
```

---

## 📝 Final Notes for Claude Code

- **Start with Phase 1** — do not jump ahead
- **Run `flutter pub get`** after creating `pubspec.yaml`
- **Run `dart run build_runner build --delete-conflicting-outputs`** after creating all model files
- **Test on both Android and iOS emulators** after each phase
- **The Paw Patrol feature is the most important differentiator** — build it robustly
- **Media uploads to Supabase Storage must handle failures gracefully** — retry on network error
- **All user-generated content moderation** — add a `is_flagged` column to spots, reviews, and reports
- **Dark mode support** — implement both light and dark theme variants
- When in doubt about UX, **prioritize simplicity over features**

---

*Last updated: PawsCity v1.0 — *