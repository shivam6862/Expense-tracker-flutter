// flutter pub get, flutter run -d chrome
import 'package:expense_tracker_flutter/providers/user_provider.dart';
import 'package:expense_tracker_flutter/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expense_tracker_flutter/responsive/responsive_layout.dart';
import 'package:expense_tracker_flutter/responsive/desktop_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/mobile_screen_layout.dart';
import 'package:expense_tracker_flutter/responsive/tablet_screen_layout.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await dotenv.load(fileName: ".env");
    String apiKey = dotenv.get('API_KEY');
    String appId = dotenv.get('APP_ID');
    String messagingSenderId = dotenv.get('MESSAGING_SENDER_ID');
    String projectId = dotenv.get('PROJECT_ID');
    String storageBucket = dotenv.get('STORAGE_BUCKET');

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: true,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobile: MobileScreenLayout(),
                    tablet: TabletScreenLayout(),
                    desktop: DesktopScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return const SignInScreen();
            },
          ),
        ));
  }
}
