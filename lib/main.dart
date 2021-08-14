import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/repository/user_repository.dart';
import 'package:movie_deck/ui/config.dart';
import 'package:movie_deck/ui/screens/home_screen.dart';
import 'package:movie_deck/ui/screens/login_screen.dart';
import 'package:movie_deck/ui/screens/onboarding_screen.dart';
import 'package:movie_deck/ui/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  App.secureStorage = FlutterSecureStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(FirebaseAuth.instance),
      child: MaterialApp(
        title: 'Movie Deck',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        home: LandingPage(),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<AuthProvider>();
    print(firebaseUser.user);
    if(firebaseUser.user != null)
      return HomeScreen();
    else
      return OnboardingScreen();
  }
}
