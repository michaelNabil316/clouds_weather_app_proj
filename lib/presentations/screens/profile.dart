import 'dart:developer';

import 'package:blood_bank/business_logic/signing_bloc/bloc.dart';
import 'package:blood_bank/business_logic/signing_bloc/states.dart';
import '/presentations/components/edit_user_inf.dart';
import '/presentations/components/profile_img_loader.dart';
import '/presentations/functions/current_user_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appbloc = AppBloc.get(context);
    appbloc.changeUserUIDFromDataBase();
    setCurrentUserData(context);
    final myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: myMedia.height * 0.18,
                    ),
                    Positioned(
                      bottom: myMedia.height * -0.12,
                      child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                        if (state is ChangeProfileImageState) {
                          return CircleImgLoader(width: myMedia.width * 0.25);
                        } else {
                          return CircleAvatar(
                            radius: myMedia.width * 0.25,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              appbloc.imgURL,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: myMedia.height * 0.13,
              ),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(appbloc.uid)
                      .onValue,
                  builder: (context, snapshot) {
                    bool isLoaded = false;
                    var response;
                    if (snapshot.hasData) {
                      response = snapshot.data;
                      response = response.snapshot.value;
                    }
                    if (snapshot.hasData && response != null) {
                      appbloc.changefirstName(response['firstName']);
                      appbloc.changelastName(response['secondName']);
                      appbloc.changeUserEmail(response['email']);
                      appbloc
                          .changeUserLocation(response['location'] ?? "cairo");
                      isLoaded = true;
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                isLoaded
                                    ? '         ${response['firstName']} ${response['secondName']}  '
                                    : '         ${appbloc.firstName} ${appbloc.lastName}  ',
                                style: const TextStyle(fontSize: 25)),
                            IconButton(
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 19.0,
                                  ),
                                  radius: 15.0,
                                  backgroundColor: mainColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const EditUserData());
                                }),
                          ],
                        ),
                        Text(isLoaded ? response['email'] : appbloc.email),
                        Text(
                            isLoaded ? response['location'] : appbloc.location),
                        // Text(isLoaded
                        //     ? '${'phone:'.tr} 0${response['phone']}'
                        //     : '${'phone:'.tr} 0${appbloc.phone}'),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
