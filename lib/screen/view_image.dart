import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewImage extends StatefulWidget {
  final String image;
  final int id;

  // ignore: use_key_in_widget_constructors
  const ViewImage(this.image, this.id);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  _save() async {
    EasyLoading.show(status: 'Downloading...', dismissOnTap: false);
    var r = await Permission.storage.request();
    if (r.isGranted) {
      var response = await Dio().get(widget.image,
          options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 60, name: "${widget.id}");
      EasyLoading.dismiss();
      EasyLoading.showToast('Image Saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .1,
            left: MediaQuery.of(context).size.width * .25,
            right: MediaQuery.of(context).size.width * .25,
            child: InkWell(
              onTap: () async {
                _save();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xff1C1B1B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Set Wallpaper",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "[ Image Saved in the Gallery ]",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .06,
            left: MediaQuery.of(context).size.width * .4,
            right: MediaQuery.of(context).size.width * .4,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff1C1B1B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
