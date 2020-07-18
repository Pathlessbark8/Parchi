import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewerPage extends StatelessWidget {
  String imageURL;
  int imageNo;
  PhotoViewerPage(this.imageURL, this.imageNo);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Image$imageNo',
      child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.black,
          child: PhotoView(
            imageProvider: NetworkImage(imageURL),
          )),
    );
  }
}
