import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wall_decore/const.dart';
import 'package:wall_decore/screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wall Decore',
      theme: ThemeData(
        primaryColor: Constant.primaryColor,
      ),
      home: HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
