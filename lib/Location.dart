import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'Model.dart';

class Location extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Location> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Images"),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.check),
            backgroundColor: new Color(0xFFE57373),
            onPressed: () {}),
        body: MediaGrid());
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  Model model;
  List<Widget> _mediaList = [];
  List<String> path = [];
  List<bool> selected = [];
  int currentPage = 0;
  int lastPage;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];
      for (var asset in media) {
        if (asset.type == AssetType.image) {
          path.add(asset.relativePath + asset.title);
          temp.add(
            FutureBuilder(
              future: asset.thumbDataWithSize(200, 200),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                return Container();
              },
            ),
          );
        }
      }
      setState(() {
        // model.mediaList.addAll(temp);
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return;
      },
      child: GridView.builder(
          itemCount: _mediaList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return imageview(_mediaList[index], path[index], index);
          }),
    );
  }

  imageview(media, path, index) {
    selected.add(false);
    return GestureDetector(
      onLongPress: () {
        setState(() {
          selected[index] = !selected[index];
        });
        print(index);
      },
      child: selected[index]
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellowAccent, width: 2)),
              child: Stack(
                children: [
                  media,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ))
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2)),
              child: media,
            ),
    );
  }
}
