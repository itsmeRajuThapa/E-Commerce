import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: "test_public_key_fe469c21bb494f89ab3c5a90aa7e035f",
        enabledDebugging: true,
        builder: (context, navKey) {
          return GetMaterialApp(
            title: appname,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: const Color.fromARGB(0, 97, 37, 37),
                appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(color: darkFontGrey),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
                fontFamily: regular),
            home: const SplashScreen(),
            navigatorKey: navKey,
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
          );
        });
  }
}
