import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/routes.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:photo_view/photo_view.dart';

class ImageList extends StatelessWidget {
  final List<String> imageList;
  final String dir;

  const ImageList(this.imageList, {super.key, required this.dir});

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imageList.map((item) {
      var file = File(CustomCheck.getFlashCardImage(item, dir));

      return GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(Routes.fullScreen, arguments: {
            'imageList': imageList,
            'init': imageList.indexOf(item),
            'type': "download",
            'dir': dir
          });
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.all(Resizable.padding(context, 5)),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.file(file,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/icons/ic_not_found.png')).image,
                  fit: BoxFit.fill,
                ),
                border: Border.all(
                    width: Resizable.size(context, 2), color: primaryColor),
                borderRadius: BorderRadius.all(
                    Radius.circular(Resizable.size(context, 20))),
              ),
            ),
            Container(
                height: Resizable.size(context, 40),
                width: Resizable.size(context, 40),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Resizable.size(context, 80)),
                      bottomRight:
                          Radius.circular(Resizable.size(context, 50))),
                ),
                child: Center(
                    child: Icon(
                  Icons.zoom_in_rounded,
                  size: Resizable.size(context, 20),
                  color: Colors.white,
                )))
          ],
        ),
      );
    }).toList();
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 0,
      ),
      items: imageSliders,
    );
  }
}

class ImageFullScreenList extends StatelessWidget {
  final List<String> imageList;
  final int init;
  final String type;
  final String dir;

  const ImageFullScreenList(
      {super.key,
      required this.imageList,
      required this.init,
      required this.type,
      required this.dir});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        padding: EdgeInsets.all(Resizable.size(context, 10)),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1,
                initialPage: init,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: imageList.map((imageUrl) {
                return Container(
                    child: type == 'network'
                        ? PhotoView(
                            imageProvider: NetworkImage(imageUrl),
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: 4.0,
                          )
                        : PhotoView(
                            imageProvider: FileImage(File(type == "download"
                                ? "$dir$imageUrl"
                                : imageUrl)),
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: 4.0,
                          ));
              }).toList(),
            ),
            Positioned(
              top: 20,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.clear_outlined,
                      color: Colors.white, size: Resizable.size(context, 30))),
            )
          ],
        ),
      ),
    );
  }
}
