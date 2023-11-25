import 'package:ada_bonus_customer/pages/auth.dart';
import 'package:ada_bonus_customer/pages/bonus.dart';
import 'package:ada_bonus_customer/pages/registration.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
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
        //Provider<ProviderAuth>(create: (_)=> ProviderAuth())
        ChangeNotifierProvider(create: (_)=> ProviderAuth())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ADA',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          fontFamily: "Montserrat",
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 16),
          )
        ),
        initialRoute: '/',
        routes: {
          '/' : (context) => const PageAuth(),
          '/reg' : (context) => const PageRegistration(),
          '/bonus' : (context) => const PageBonus(),
          //'/pageSignIn' : (context) => const,
        },
      ),
    );
  }
}