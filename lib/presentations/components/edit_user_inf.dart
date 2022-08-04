import 'dart:developer';

import 'package:blood_bank/business_logic/signing_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//translation
import 'package:get/get.dart';
import '../constants.dart';
import 'button_widget.dart';
import 'custom_text_field.dart';

String imgUrl =
    'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg';

class EditUserData extends StatefulWidget {
  static String id = 'EditUserData';
  const EditUserData({Key? key}) : super(key: key);

  @override
  _EditUserDataState createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  static late AppBloc appbloc;
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController secondNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  Map newUserData = {};
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      appbloc = AppBloc.get(context);
      setState(() {
        firstNameCtrl.text = appbloc.firstName;
        secondNameCtrl.text = appbloc.lastName;
        emailCtrl.text = appbloc.email;
        locationCtrl.text = appbloc.location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    appbloc = AppBloc.get(context);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SingleChildScrollView(
        child: SizedBox(
          height: myMedia.height * 0.6,
          width: myMedia.width * 0.9,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 34),
                    child: CustomTextField(
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
                          appbloc.changeErrorSignUp("");
                        }
                      },
                    ),
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
                        appbloc.changeErrorSignUp("");
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    ctrl: emailCtrl,
                    hintTitle: "email".tr,
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
                        appbloc.changeErrorSignUp("");
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    ctrl: locationCtrl,
                    hintTitle: "location".tr,
                    havePerfixIcon: false,
                    validFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'location filed is require'.tr;
                      }
                      if (value.length < 3) {
                        return 'can\'t be less than 3 digits'.tr;
                      }
                      return null;
                    },
                    onChange: (v) {
                      if (v.length > 1) {
                        appbloc.changeErrorSignUp("");
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      appbloc.errorLogin,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ButtonWidget(mainColor, 'Update'.tr, Colors.white, () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        showSpinner = true;
                        newUserData = {
                          'email': emailCtrl.text,
                          'firstName': firstNameCtrl.text,
                          'secondName': secondNameCtrl.text,
                          'location': locationCtrl.text
                        };
                      });
                      log("newUserData:$newUserData");
                      await FirebaseDatabase.instance
                          .reference()
                          .child('Users')
                          .child(appbloc.uid)
                          .set(newUserData);
                      Navigator.pop(context);
                      setState(() {
                        showSpinner = false;
                      });
                      //    } else {
                      //      setState(() {
                      //       showSpinner = false;
                      //    });
                      //   }
                    }
                  }, myMedia.height * 0.08, myMedia.width * 0.5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
