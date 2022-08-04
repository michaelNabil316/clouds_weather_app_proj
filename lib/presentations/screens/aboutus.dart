import 'package:flutter/material.dart';
//translation
import 'package:get/get.dart';

import '../constants.dart';

class AboutUsScreen extends StatelessWidget {
  static String id = 'AboutUsScreen';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: getAboutUs(height: height),
    );
  }
}

Widget getAboutUs({height}) {
  return Scaffold(
    //backgroundColor: kMainColor,
    body: SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(top: 30),
                  height: height * .2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      /* Image(
                          image: AssetImage('assets/icons/image.jpg'),
                          width: 120,   
                      ), */
                      CircleAvatar(
                        radius: height * 0.07,
                        backgroundImage:
                            const AssetImage('assets/images/cloudsimage.PNG'),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  'clouds Software solutions',
                  style: TextStyle(
                    fontSize: 24,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.pinkAccent,
                  ),
                ),
              ),
              Text('Developed By Michael Nabil'.tr,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  textAlign: TextAlign.center),
              SizedBox(height: height * 0.005),
              Text('+201284823321'.tr,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  textAlign: TextAlign.center),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(aboutCompany.tr),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
