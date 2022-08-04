import 'dart:developer';
import 'package:blood_bank/Models/weather_model.dart';
import 'package:blood_bank/business_logic/data_cubit/bloc.dart';
import 'package:blood_bank/business_logic/data_cubit/states.dart';
import 'package:blood_bank/presentations/components/app_bar.dart';
import 'package:blood_bank/services/api/weather_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentations/components/app_drawer.dart';
import '/presentations/functions/current_user_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static String id = 'Home_page';
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseDatabase.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static late Size myMedia;
  static late DataBloc dataBloc;
  WeatherApi weatherApi = WeatherApi();

  @override
  void initState() {
    super.initState();
    _fcm.requestPermission();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      dataBloc = DataBloc.get(context);
      dataBloc.getLocationData();
      setCurrentUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: cusomAppBar(title: 'Clouds app'),
      drawer: const AppDrawer(),
      body: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        dataBloc = DataBloc.get(context);
        if (dataBloc.isLoading) {
          return Center(
            child: SpinKitDoubleBounce(
              color: Colors.blueAccent,
              size: myMedia.width * 0.14,
            ),
          );
        } else if (state is ErrorLoading) {
          return Center(
            child: Text(dataBloc.loadingError),
          );
        } else if (dataBloc.weatherModel != null) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    const AssetImage('assets/images/location_background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
            constraints: const BoxConstraints.expand(),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${(dataBloc.weatherModel!.main!.temp)!.toInt() - 273}',
                            style: kTempTextStyle,
                          ),
                          Text(
                            weatherApi.getWeatherIcon(
                                dataBloc.weatherModel!.weather![0].id!),
                            style: kConditionTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        '${weatherApi.getMessage((dataBloc.weatherModel!.main!.temp)!.toInt() - 273)} \n in ${dataBloc.weatherModel!.name}',
                        textAlign: TextAlign.center,
                        style: kMessageTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(dataBloc.error),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          child: const Icon(Icons.location_searching),
          onPressed: () {
            dataBloc.getLocationData();
          }),
    );
  }
}
