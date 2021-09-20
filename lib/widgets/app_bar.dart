import 'package:flutter/material.dart';
import 'package:wall_decore/const.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: true,
    title: RichText(
      text: const TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.w800, color: Colors.black, fontSize: 24),
        children: <TextSpan>[
          TextSpan(
            text: 'Wall',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Decor',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Constant.primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}
