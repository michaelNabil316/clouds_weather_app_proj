import 'dart:convert';
import 'dart:developer';
import 'package:blood_bank/business_logic/signing_bloc/states.dart';
import 'package:blood_bank/presentations/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc() : super(AppInitialState());
  static AppBloc get(context) => BlocProvider.of(context);
  String uid = '5555';
  String email = 'email';
  String firstName = 'name';
  String lastName = 'name';
  String location = 'cairo';

  bool newNotification = false;
  String imgURL =
      'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg';
  String errorLogin = "";
  String errorSignUp = "";
  bool showSpinner = false;
  bool signUpshowSpinner = false;

  void changeErrorLogin(String value) {
    errorLogin = value;
    emit(ErrorLogin());
  }

  void changeErrorSignUp(String value) {
    errorLogin = value;
    emit(ErrorLogin());
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    changeLoginLoadingSpinner(true);
    changeErrorLogin("");
    final _auth = FirebaseAuth.instance;
    try {
      UserCredential response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      changeUserUID(response.user!.uid);
      changeLoginLoadingSpinner(false);
      return {"error": false, "value": response};
    } on FirebaseAuthException catch (e) {
      log("login error:$e");
      changeLoginLoadingSpinner(false);
      changeErrorLogin(e.toString().contains(notValidAcc)
          ? "Not Valid Account".tr
          : e.toString());
      return {"error": true, "message": e.toString()};
    } catch (err) {
      changeLoginLoadingSpinner(false);
      changeErrorLogin(err.toString().contains(notValidAcc)
          ? "Not Valid Account".tr
          : err.toString());
      return {"error": true, "message": err.toString()};
    }
  }

  void changeLoginLoadingSpinner(bool value) {
    showSpinner = value;
    emit(LoadingLogin());
  }

  void changeSignUpLoadingSpinner(bool value) {
    signUpshowSpinner = value;
    emit(LoadingLogin());
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    changeSignUpLoadingSpinner(true);
    changeErrorLogin("");
    final _auth = FirebaseAuth.instance;
    try {
      UserCredential response = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      changeUserUID(response.user!.uid);
      changeSignUpLoadingSpinner(false);
      return {"error": false, "value": response};
    } on FirebaseAuthException catch (e) {
      log("login response:$e");
      changeSignUpLoadingSpinner(false);
      changeErrorLogin(e.toString().contains(alerdayExist)
          ? "The email address is already in use by another account".tr
          : e.toString());
      return {"error": true, "message": e.toString()};
    } catch (err) {
      changeSignUpLoadingSpinner(false);
      changeErrorLogin(err.toString().contains(alerdayExist)
          ? "The email address is already in use by another account".tr
          : err.toString());
      return {"error": true, "message": err.toString()};
    }
  }

  //******************************************

  void changeNewNotification(bool value) {
    newNotification = value;
    emit(UpdateNotificationState());
  }

  void changeimgUrl(String value) {
    imgURL = value;
    emit(UpdateUrlState());
  }

  void changefirstName(String value) {
    firstName = value;
    emit(UpdateUserState());
  }

  void changelastName(String value) {
    lastName = value;
    emit(UpdateUserState());
  }

  void changeUserEmail(String value) {
    email = value;
    emit(UpdateUserState());
  }

  void changeUserLocation(String value) {
    location = value;
    emit(UpdateUserState());
  }

  void changeUserUID(String value) {
    uid = value;
    emit(UpdateUserState());
  }

  void changeUserUIDFromDataBase() async {
    final pref = await SharedPreferences.getInstance();
    uid = pref.getString('key') ?? "5555";
    emit(UpdateUserState());
  }

  void changeProfileImage() {
    emit(ChangeProfileImageState());
  }
}
