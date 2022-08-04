import 'package:blood_bank/business_logic/signing_bloc/bloc.dart';
import 'package:blood_bank/business_logic/signing_bloc/states.dart';
import 'package:blood_bank/presentations/components/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/presentations/components/app_bar.dart';
import '/presentations/components/button_widget.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static late double w;
  static late double h;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  String imageName = 'assets/images/logo.png';
  String error = "";
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: cusomAppBar(title: "Sign in"),
      body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        final appBloc = AppBloc.get(context);
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(imageName),
                  ),
                ),
                const SizedBox(height: 50.0),
                CustomTextField(
                  ctrl: emailCtrl,
                  hintTitle: "Enter your email".tr,
                  havePerfixIcon: false,
                  validFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email'.tr;
                    }
                    if (!emailRegExp.hasMatch(emailCtrl.text)) {
                      return 'email expression is not valid'.tr;
                    }
                    return null;
                  },
                  onChange: (v) {
                    if (v.length > 1) {
                      appBloc.changeErrorLogin("");
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  ctrl: passCtrl,
                  hintTitle: "Enter your password".tr,
                  havePerfixIcon: true,
                  validFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password'.tr;
                    }
                    if (value.length < 8) {
                      return 'password must be at least 8 digits'.tr;
                    }
                    return null;
                  },
                  onChange: (v) {
                    if (v.length > 1) {
                      appBloc.changeErrorLogin("");
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: Text(
                    appBloc.errorLogin,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 24.0),
                appBloc.showSpinner
                    ? const Center(child: CircularProgressIndicator())
                    : ButtonWidget(mainColor, 'Log In'.tr, Colors.white,
                        () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (formKey.currentState!.validate()) {
                          final response = await appBloc.login(
                              emailCtrl.text, passCtrl.text);
                          if (!response['error']) {
                            final pref = await SharedPreferences.getInstance();
                            UserCredential userData = response['value'];
                            pref.setString('key', userData.user!.uid);
                            Navigator.pushReplacementNamed(
                                context, HomePage.id);
                          }
                        }
                      }, h * 0.08, w * 0.5),
              ],
            ),
          ),
        );
      }),
    );
  }
}
