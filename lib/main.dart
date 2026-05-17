import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/screens/main_navigation.dart';
import 'package:project001/providers/auth_provider.dart';
import 'package:project001/services/notification_service.dart';
import 'package:project001/services/deep_link_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Step 8: Initialize FCM push notifications
  await NotificationService().initialize();

  // Step 7: Initialize deep link / QR check-in handler
  await DeepLinkService().initialize();

  runApp(const AppDa());
}

class AppDa extends StatelessWidget {
  const AppDa({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'App-da',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
