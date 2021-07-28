import 'dart:io';

import 'package:flutter/material.dart';

import 'ChildGridWidget.dart';
import 'MyFile.dart';
class ArtifectChild extends StatefulWidget
{
  MyFile myFile;
  ArtifectChild({this.myFile});
  @override
  _ArtifectChildState createState() => _ArtifectChildState(myFile: myFile);
}

class _ArtifectChildState extends State<ArtifectChild>
{
  MyFile myFile;
  _ArtifectChildState({this.myFile});
  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [

        myFile.takeFirst.length>0?ChildGridWidget(list: myFile.takeFirst,title: 'First Take',):Container(width: 0,height: 0,),
        myFile.takeSecond.length>0?ChildGridWidget(list: myFile.takeSecond,title: 'Second Take',):Container(width: 0,height: 0,),
        myFile.takeThird.length>0?ChildGridWidget(list: myFile.takeThird,title: 'Third Take',):Container(width: 0,height: 0,),
        myFile.takeFour.length>0?ChildGridWidget(list: myFile.takeFour,title: 'Fourth Take',):Container(width: 0,height: 0,),

      ],
    );
  }
}
