import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wall_decore/const.dart';
import 'package:wall_decore/model/photos_model.dart';
import 'package:wall_decore/screen/view_image.dart';
import 'package:wall_decore/widgets/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:wall_decore/widgets/wallpaper.dart';

class CategoryScreen extends StatefulWidget {
  final String name;

  // ignore: use_key_in_widget_constructors
  const CategoryScreen(this.name);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<PhotosModel> photos = [];
  int pageNo = 1 + Random().nextInt(25 - 1);

  @override
  void initState() {
    super.initState();
    getCategoryWallpaper(pageNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${widget.name} Wallpapers',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                children: photos.map((PhotosModel data) {
                  return GridTile(
                    child: wallpaper(
                      data,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewImage(data.src.portrait, data.id)));
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  pageNo += 1;
                  getCategoryWallpaper(pageNo);
                },
                child: const Text('Load Wallpaper'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constant.primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getCategoryWallpaper(int page) async {
    EasyLoading.show(status: 'loading...', dismissOnTap: false);
    var url = Uri.parse(
        "https://api.pexels.com/v1/search?query=${widget.name}&per_page=30&page=$page");
    await http.get(url, headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);

      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = PhotosModel.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString() + "  " + photosModel.src.portrait);
      });
      EasyLoading.dismiss();
      setState(() {});
    });
  }
}
