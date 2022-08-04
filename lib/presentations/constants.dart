import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 50.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
);
final decorationStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white70,
  icon: const Icon(Icons.location_city, color: Colors.white),
  hintText: 'Type city\'s name',
  hintStyle: const TextStyle(color: Colors.blueGrey),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
);
const mainColor = Color.fromARGB(255, 73, 170, 255);
var emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const kSendButtonTextStyle = TextStyle(
  color: Color.fromARGB(255, 0, 157, 143),
  fontWeight: FontWeight.bold,
  fontSize: 24.0,
);
const kWelcomeTextStyle = TextStyle(
  color: mainColor,
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);

var kMessageTextFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
    hintText: 'Type your message here...'.tr,
    border: InputBorder.none,
    filled: true,
    fillColor: const Color.fromARGB(100, 255, 255, 255));

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: mainColor, width: 2.0),
  ),
);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const addPostStyle =
    TextStyle(color: mainColor, fontSize: 24, fontWeight: FontWeight.bold);
const bloodTypeStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const postTxtBodyStyle = TextStyle(
  fontSize: 20.0,
);
const notValidAcc = "There is no user record corresponding to this identifier.";
const alerdayExist = "The email address is already in use by another account";
const aboutCompany =
    "We are startup software solutions company offering non-regular market quality and up-normal IT solutions. We are not just another name added to software section of yellow pages, we are high level team of experienced confident determined designers, developers, testers and managers have been around in the field for many years, decided to come together and start our own show. '\n Please everyone, have a seat and watch, we are showing: the UNEXPECTED SOLUTION!";
