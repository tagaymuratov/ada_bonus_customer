import 'package:ada_bonus_customer/pages/auth.dart';
import 'package:ada_bonus_customer/pages/bonus.dart';
import 'package:ada_bonus_customer/pages/registration.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:ada_bonus_customer/providers/provider_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ProviderAuth()),
        ChangeNotifierProvider(create: (_)=> ProviderPages())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ADA',
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 95, 54)),
          useMaterial3: true,
          cardTheme: const CardTheme(clipBehavior: Clip.antiAlias),
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        initialRoute: '/',
        routes: {
          '/' : (context) => const PageAuth(),
          '/reg' : (context) => const PageRegistration(),
          '/bonus' : (context) => const PageBonus(),
        },
      ),
    );
  }
}