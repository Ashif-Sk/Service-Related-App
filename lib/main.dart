import 'package:contrador/firebase_options.dart';
import 'package:contrador/provider/favourite_provider.dart';
import 'package:contrador/provider/user_provider.dart';
import 'package:contrador/view/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FavouriteProvider()..loadWishListState()),
        ChangeNotifierProvider(create: (_) => UserProvider()..getUserDetails())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Flexify(
        designWidth: deviceHeight,
        designHeight: deviceWidth,
        app: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Contrador',
            theme: ThemeData(
                colorScheme: ColorScheme.light(
              brightness: Brightness.light,
              surface: Colors.grey.shade300,
              primary: const Color.fromRGBO(224, 79, 13, 1),
              secondary: Colors.black,
              tertiary: Colors.white,
              primaryContainer: Colors.white,
              secondaryContainer: const Color.fromRGBO(224, 79, 13, 0.1),
            )),
            home: const SplashPage()));
  }
}
