import 'dart:io';

class doubtsUpload {
  List tags;
  String doubt;
  String imgFileURL1;
  String imgFileURL2;
  File imgFile1;
  File imgFile2;

  doubtsUpload(this.doubt, this.tags, this.imgFileURL1, this.imgFile1,
      this.imgFileURL2, this.imgFile2);
}
