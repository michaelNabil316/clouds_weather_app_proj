import 'package:blood_bank/business_logic/signing_bloc/bloc.dart';
import 'package:blood_bank/business_logic/signing_bloc/states.dart';
import 'package:firebase_database/firebase_database.dart';

import '/presentations/components/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentations/components/button_widget.dart';
import '/presentations/components/edit_user_inf.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static String id = 'sign_up_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController secondNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static late Size myMedia;
  static late AppBloc appbloc;

  @override
  Widget build(BuildContext context) {
    myMedia = MediaQuery.of(context).size;
    appbloc = AppBloc.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('sign up'.tr),
        backgroundColor: mainColor,
      ),
      body: SafeArea(
        child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          final appBloc = AppBloc.get(context);
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 25.0),
                        CustomTextField(
                          ctrl: firstNameCtrl,
                          hintTitle: "first name".tr,
                          havePerfixIcon: false,
                          validFun: (value) {
                            if (value == null || value.isEmpty) {
                              return 'first name filed is require'.tr;
                            }
                            if (value.length < 3) {
                              return 'can\'t be less than 3 digits'.tr;
                            }
                            return null;
                          },
                          onChange: (v) {
                            if (v.length > 1) {
                              appBloc.changeErrorSignUp("");
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        CustomTextField(
                          ctrl: secondNameCtrl,
                          hintTitle: "last name".tr,
                          havePerfixIcon: false,
                          validFun: (value) {
                            if (value == null || value.isEmpty) {
                              return 'last name filed is require'.tr;
                            }
                            if (value.length < 3) {
                              return 'can\'t be less than 3 digits'.tr;
                            }
                            return null;
                          },
                          onChange: (v) {
                            if (v.length > 1) {
                              appBloc.changeErrorSignUp("");
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        CustomTextField(
                          ctrl: emailCtrl,
                          hintTitle: "Enter your email".tr,
                          havePerfixIcon: false,
                          validFun: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your email'.tr;
                            }
                            if (!emailRegExp.hasMatch(emailCtrl.text)) {
                              return 'Not valid email form'.tr;
                            }
                            return null;
                          },
                          onChange: (v) {
                            if (v.length > 1) {
                              appBloc.changeErrorSignUp("");
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                        CustomTextField(
                          ctrl: passCtrl,
                          hintTitle: 'Enter your password'.tr,
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
                        const SizedBox(height: 10.0),
                        CustomTextField(
                          ctrl: confirmPassCtrl,
                          hintTitle: 'Confirm password'.tr,
                          havePerfixIcon: true,
                          validFun: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm password'.tr;
                            }
                            if (value.length < 8) {
                              return 'password must be at least 8 digits'.tr;
                            }
                            if (value != passCtrl.text) {
                              return 'Not the same as password'.tr;
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
                        Center(
                          child: Text(
                            appBloc.errorLogin,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        if (!appBloc.signUpshowSpinner)
                          ButtonWidget(mainColor, 'Sign Up'.tr, Colors.white,
                              () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (formKey.currentState!.validate()) {
                              final response = await appBloc.signUp(
                                  emailCtrl.text, passCtrl.text);
                              if (!response['error']) {
                                final pref =
                                    await SharedPreferences.getInstance();
                                UserCredential userData = response['value'];
                                pref.setString('key', userData.user!.uid);
                                var newUserData = {
                                  'email': emailCtrl.text,
                                  'firstName': firstNameCtrl.text,
                                  'secondName': secondNameCtrl.text,
                                  'user_imgURL':
                                      'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg'
                                };
                                FirebaseDatabase.instance
                                    .reference()
                                    .child('Users')
                                    .child(userData.user!.uid)
                                    .set(newUserData);
                                Navigator.pushReplacementNamed(
                                    context, HomePage.id);
                              }
                            }
                          }, myMedia.height * 0.08, myMedia.width * 0.5),
                      ],
                    ),
                  ),
                  if (appBloc.signUpshowSpinner)
                    Padding(
                      padding: EdgeInsets.only(top: myMedia.height * 0.5),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
