import 'package:flutter/material.dart';
import 'package:wall_decore/model/category_model.dart';

Widget catItem(CategoriesModel data, Function onPress) {
  return InkWell(
    onTap: () {
      onPress();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      height: 60,
      width: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                data.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              data.catName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
