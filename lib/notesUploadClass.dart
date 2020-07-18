import 'dart:io';

class notesUpload {
  List tags;
  String title;
  String description;
  String fileURL;
  File file;

  notesUpload(String this.title, String this.description, List this.tags,
      String this.fileURL, File this.file);
}
