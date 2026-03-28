import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/views/screens/authentication/login_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51QNDjeFCHOE81U8omXbQC7Ny2bzsKtBQvvQ1hB48xur0LfXmVMePc3f4BDVMmf5nWFdmFXSljnqmdJChQ45iIG5L00EeWRNkAZ";

  await Stripe.instance.applySettings();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Method to check the token and set the user data if available
  Future<void> _checkTokenAndSetUser(WidgetRef ref, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final userJson = prefs.getString('user');

  if (token != null && userJson != null) {
    // Restore user from stored JSON
    ref.read(userProvider.notifier).setUser(userJson);

    // Validate the token and refresh user data if needed
    await AuthController().getUserData(context, ref);
  }
}


  // This widget is the root of your application.
  @override
 Widget build(BuildContext context, WidgetRef ref) {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    title: 'Flutter Demo',
    home: FutureBuilder(
      future: _checkTokenAndSetUser(ref, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

final user = ref.watch(userProvider);

if (user == null || user.token.isEmpty) {
  return const LoginScreen();
} else {
  return MainScreen();
}
      },
    ),
  );
}}