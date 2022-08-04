import 'dart:developer';
import 'package:blood_bank/Models/weather_model.dart';
import 'package:blood_bank/services/api/weather_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'states.dart';

class DataBloc extends Cubit<DataState> {
  DataBloc() : super(DataInitialState());
  static DataBloc get(context) => BlocProvider.of(context);
  WeatherModel? weatherModel;
  String uid = "";

  String loadingError = "Error in Loading data";
  String error = "Something went Wrong";
  bool isLoading = true;

  void getLocationData() async {
    changeLoading(true);
    var weatherData = await WeatherApi().getLocationWeather();
    if (!weatherData['error']) {
      weatherModel = WeatherModel.fromJson(weatherData["value"]);
      changeUserLocation(weatherModel!.name ?? "cairo");
      emit(SuccessfulyLoaded());
      changeLoading(false);
      return;
    }
    changeLoading(false);
    emit(ErrorLoading());
    return;
  }

  void changeUserLocation(String loc) async {
    final pref = await SharedPreferences.getInstance();
    uid = pref.getString('key') ?? "5555";
    final response;
    try {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(uid)
          .once();
      log(">>>>>>>>snapshot.value:${snapshot.value}");
      if (snapshot.value != null) {
        Map<String, dynamic> newUserData = {
          'email': snapshot.value['email'],
          'firstName': snapshot.value['firstName'],
          'secondName': snapshot.value['secondName'],
          'location': loc
        };
        await FirebaseDatabase.instance
            .reference()
            .child('Users')
            .child(uid)
            .set(newUserData);
      }
    } catch (e) {
      log(">>>error>>>>>:$e");
    }
    emit(ChangeLoading());
  }

  void changeLoading(bool value) {
    isLoading = value;
    emit(ChangeLoading());
  }
}
