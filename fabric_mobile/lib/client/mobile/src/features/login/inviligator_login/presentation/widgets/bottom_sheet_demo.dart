import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheetWidget> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersistantBottomSheetCallBack;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: IconButton(
            onPressed: () {
              print('Hello Dear');
            },
            icon: Icon(Icons.account_box),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showPersistantBottomSheetCallBack = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _showPersistantBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState.showBottomSheet((context) {
      build:
      Builder();
    });
  }
}
