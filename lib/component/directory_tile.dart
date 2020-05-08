import 'dart:io';

import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryTile extends StatelessWidget {
  final String directoryName;
  final Function getDirectoryFunction;
  final StorageDirectory type;

  DirectoryTile(
      {@required this.directoryName,
      @required this.getDirectoryFunction,
      @required this.type});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(directoryName),
      onTap: () async {
        Directory directory;

        if (type == null) {
          directory = await getDirectoryFunction();
        } else {
          directory = await getDirectoryFunction(type: type);
        }
        String tempPath = directory.path;

        Navigator.of(context).push<FolderPickerPage>(
            MaterialPageRoute(builder: (BuildContext context) {
          return FolderPickerPage(
              rootDirectory: directory,

              /// a [Directory] object
              action: (BuildContext context, Directory folder) async {
                print("Picked folder $folder");
              });
        }));
      },
    );
  }
}
