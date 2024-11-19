import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/provider/onBoarding_provider.dart';
import 'package:news_app/screens/boarding/on_boarding.dart';
import 'package:news_app/screens/splash/splash.dart';
import 'package:news_app/screens/tabs/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:news_app/screens/auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstTime = ref.watch(OnBoardProvider);

    return MaterialApp(
      theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(243, 158, 58, 0)),
          textTheme: const TextTheme(
              titleLarge: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              bodyMedium: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              bodySmall: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Splash();
            }
            if (snapShot.hasData) {
              return FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, prefsSnapshot) {
                  if (prefsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  bool isFirstTimeUser =
                      prefsSnapshot.data?.getBool('isFirstTimeUser') ??
                          firstTime;

                  if (isFirstTimeUser) {
                    return const OnBoardingScreen();
                  }
                  return TabsScreen();
                },
              );
            } else {
              return const Auth();
            }
          }),
    );
  }
}
