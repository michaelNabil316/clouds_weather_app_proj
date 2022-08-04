import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

AppBar cusomAppBar({required String title}) {
  return AppBar(
    title: Text(title.tr),
    backgroundColor: mainColor,
    elevation: 0,
    centerTitle: true,
  );
}
