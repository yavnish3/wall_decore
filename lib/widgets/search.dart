import 'package:flutter/material.dart';

Widget search(var _cont, Function onPress) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xfff5f8fd),
      borderRadius: BorderRadius.circular(30),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cont,
            decoration: const InputDecoration(
                hintText: "search wallpapers", border: InputBorder.none),
          ),
        ),
        InkWell(
          onTap: () {
            onPress();
          },
          child: const Icon(Icons.search),
        ),
      ],
    ),
  );
}
