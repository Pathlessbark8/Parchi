import 'dart:io';

class videosUpload {
  List tags;
  String title;
  String description;
  String fileURL;
  File file;

  videosUpload(String this.title, String this.description, List this.tags,
      String this.fileURL, File this.file);
}
