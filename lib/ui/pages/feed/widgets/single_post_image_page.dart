import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Singleimagepage extends StatefulWidget {
  final String photo;
  Singleimagepage({this.photo});


  @override
  _SingleimagepageState createState() => _SingleimagepageState();
}

class _SingleimagepageState extends State<Singleimagepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            child: CachedNetworkImage(
              imageUrl:  widget.photo,
                imageBuilder: (context, imageProvider) => PhotoView(
                  heroAttributes: PhotoViewHeroAttributes(
                      tag: "img_${widget.photo}"
                  ),
                  imageProvider: imageProvider,
                ),
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              child: Icon(
                      Icons.clear,
                color: Colors.white,
                  ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: GestureDetector(
              child: Icon(
                Icons.cloud_download,
                color: Colors.white,
              ),
              onTap: () {},
            ),

          ),
         ],
      ),

    );
  }
}
