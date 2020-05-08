import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'component/directory_tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File image;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              image = await ImagePicker.pickImage(
                source: ImageSource.gallery,
              );
            },
            child: Text('Select Image'),
          ),
          Center(child: Text('Error: $_error')),
          RaisedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          Expanded(
            child: buildGridView(),
          )
        ],
      )),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            DirectoryTile(
              directoryName: 'Temporary Directory',
              getDirectoryFunction: getTemporaryDirectory,
              type: null,
            ),
            DirectoryTile(
                directoryName: 'Application Documents Directory',
                type: null,
                getDirectoryFunction: getApplicationDocumentsDirectory),
            DirectoryTile(
              directoryName: 'Application Support Directory',
              getDirectoryFunction: getApplicationSupportDirectory,
              type: null,
            ),
            DirectoryTile(
              directoryName:
                  '${Platform.isAndroid ? "Application Library Directory are unavailable " "on Android" : "Application Library Directory"}',
              getDirectoryFunction:
                  Platform.isAndroid ? null : getLibraryDirectory,
              type: null,
            ),
            DirectoryTile(
              directoryName:
                  '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directory"}',
              getDirectoryFunction:
                  Platform.isIOS ? null : getExternalStorageDirectory,
              type: null,
            ),
            DirectoryTile(
              directoryName:
                  '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directories"}',
              getDirectoryFunction:
                  Platform.isIOS ? null : getExternalStorageDirectories,
              type: StorageDirectory.pictures,
            ),
            DirectoryTile(
              directoryName:
                  '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Cache Directories"}',
              getDirectoryFunction:
                  Platform.isIOS ? null : getExternalCacheDirectories,
              type: null,
            ),
          ],
        ),
      ),
    );
  }
}
