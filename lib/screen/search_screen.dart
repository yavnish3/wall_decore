import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wall_decore/const.dart';
import 'package:wall_decore/model/photos_model.dart';
import 'package:wall_decore/screen/view_image.dart';
import 'package:wall_decore/widgets/app_bar.dart';
import 'package:wall_decore/widgets/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wall_decore/widgets/wallpaper.dart';

class SearchScreen extends StatefulWidget {
  final String search;

  // ignore: use_key_in_widget_constructors
  const SearchScreen(this.search);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();

  List<PhotosModel> photos = [];

  @override
  void initState() {
    super.initState();
    _search.text = widget.search;
    if (_search.text.isNotEmpty) {
      getSearchingWallpaper();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            search(
              _search,
              () {
                if (_search.text.isNotEmpty) {
                  photos = [];
                  getSearchingWallpaper();
                } else {
                  EasyLoading.showToast('Enter Text');
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${_search.text} Wallpapers',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
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
          ],
        ),
      ),
    );
  }

  getSearchingWallpaper() async {
    EasyLoading.show(status: 'loading...', dismissOnTap: false);
    var url = Uri.parse(
        "https://api.pexels.com/v1/search?query=${_search.text}&per_page=100&page=1");
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
