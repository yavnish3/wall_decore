import 'package:flutter/material.dart';
import 'package:wall_decore/model/photos_model.dart';

Widget wallpaper(PhotosModel data, Function onPress) {
  return InkWell(
    onTap: () {
      onPress();
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            data.src.portrait,
            height: 50,
            width: 100,
            fit: BoxFit.cover,
          )),
    ),
  );
}
