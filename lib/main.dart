import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/app.dart';
import 'package:pawcity/core/constants/supabase_keys.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  if (SupabaseKeys.url.isNotEmpty && SupabaseKeys.anonKey.isNotEmpty) {
    await Supabase.initialize(
      url: SupabaseKeys.url,
      anonKey: SupabaseKeys.anonKey,
    );
  }

  try {
    await Firebase.initializeApp();
  } catch (_) {}

  final posthogKey = dotenv.env['POSTHOG_API_KEY'];
  final posthogHost = dotenv.env['POSTHOG_HOST'];
  if (posthogKey != null &&
      posthogKey.isNotEmpty &&
      posthogHost != null &&
      posthogHost.isNotEmpty) {
    final config = PostHogConfig(posthogKey)..host = posthogHost;
    await Posthog().setup(config);
  }

  runApp(const ProviderScope(child: PawCityApp()));
}
