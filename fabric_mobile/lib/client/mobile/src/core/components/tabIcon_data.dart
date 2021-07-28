import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.icons,
    //this.imagePath = '',
    this.index = 0,
    //this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
       
  });

  IconData icons;
  //String imagePath;
  //String selectedImagePath;
  bool isSelected;
  int index;
  

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      icons: Icons.home,
      //imagePath: 'assets/home.png',
      //selectedImagePath: 'assets/home.png',
      index: 0,
      isSelected: true,
      animationController: null,
     
    ),
    TabIconData(
      icons: Icons.schedule,
      //imagePath: 'assets/calendar.png',
      //selectedImagePath: 'assets/calendar.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      icons: Icons.scanner,
      //imagePath: 'assets/scan.png',
      //selectedImagePath: 'assets/scan.png',
      index: 2,
      isSelected: false,
      animationController: null,
  
    ),
    TabIconData(
      icons: Icons.list,
      //imagePath: 'assets/upload.png',
      //selectedImagePath: 'assets/upload.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      icons: Icons.perm_identity,
      //imagePath: 'assets/user.png',
      //selectedImagePath: 'assets/user.png',
      index: 4,
      isSelected: false,
      animationController: null,
    ),
  ];
}