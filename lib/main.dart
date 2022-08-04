import './presentations/constants.dart';
import './presentations/screens/aboutus.dart';
import 'business_logic/data_cubit/bloc.dart';
import 'business_logic/signing_bloc/bloc.dart';
import 'presentations/screens/login_screen.dart';
import 'presentations/screens/home_page.dart';
import './presentations/screens/profile.dart';
import './presentations/screens/sign_up.dart';
import './presentations/screens/welcome_screen.dart';
import './presentations/translation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();
  bool savedData() {
    if (pref.containsKey('key') == false) {
      return false;
    }
    return true;
  }

  runApp(MyApp(savedData: savedData()));
}

class MyApp extends StatelessWidget {
  final bool savedData;
  const MyApp({Key? key, this.savedData = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc()..changeUserUIDFromDataBase(),
        ),
        BlocProvider<DataBloc>(
          create: (context) => DataBloc(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Translation(),
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        theme: ThemeData(
            primaryColor: mainColor,
            canvasColor: Colors.transparent,
            appBarTheme: const AppBarTheme(titleSpacing: 0.0)),
        //for make app not open welcome screen again after login
        initialRoute: (savedData == true) ? HomePage.id : WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          HomePage.id: (context) => const HomePage(), //posts page
          AboutUsScreen.id: (context) => AboutUsScreen(),
          ProfileScreen.id: (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
