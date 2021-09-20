import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:wall_decore/const.dart';
import 'package:wall_decore/data/category_data.dart';
import 'package:wall_decore/model/photos_model.dart';
import 'package:wall_decore/screen/search_screen.dart';
import 'package:wall_decore/screen/view_image.dart';
import 'package:wall_decore/widgets/app_bar.dart';

import 'package:wall_decore/widgets/cat_item.dart';
import 'package:wall_decore/screen/category_screen.dart';
import 'package:wall_decore/widgets/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:wall_decore/widgets/wallpaper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _search = TextEditingController();

  int total = 10;
  int noOfImageToLoad = 30;
  int pageNo = 1 + Random().nextInt(100 - 1);
  List<PhotosModel> photos = [];

  @override
  void initState() {
    super.initState();
    getTrendingWallpaper(noOfImageToLoad, pageNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            search(
              _search,
              () {
                if (_search.text.isNotEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(_search.text)));
                } else {
                  EasyLoading.showToast('Enter Text');
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 80,
              //color: Colors.red,
              child: ListView.builder(
                //padding: EdgeInsets.symmetric(horizontal: 5),
                shrinkWrap: true,

                scrollDirection: Axis.horizontal,
                itemCount: catList.length,
                itemBuilder: (context, index) {
                  return catItem(
                    catList[index],
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategoryScreen(catList[index].catName)));
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Wallpapers',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
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
                                    ViewImage(data.src.large, data.id)));
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
                  getTrendingWallpaper(noOfImageToLoad, pageNo);
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

  getTrendingWallpaper(int noImage, int noPage) async {
    EasyLoading.show(status: 'loading...', dismissOnTap: false);
    var url = Uri.parse(
        "https://api.pexels.com/v1/curated?per_page=$noImage&page=$noPage");
    await http.get(url, headers: {"Authorization": apiKEY}).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      total = jsonData["total_results"];
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
