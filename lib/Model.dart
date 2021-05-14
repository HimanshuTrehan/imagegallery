import 'package:flutter/material.dart';

class Model {
  List<Widget> mediaList = [];
  List<String> path = [];

  Model({this.mediaList, this.path, this.selected});

  List<bool> selected = [];
}
