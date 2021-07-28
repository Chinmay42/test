// Flutter code sample for ExpansionPanelList

// Here is a simple example of how to implement ExpansionPanelList.

import 'dart:ui';


import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/artifect_capture_detail/MyFile.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/Util.dart';
import 'package:flutter/material.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'ArtifectChildWidget.dart';
import 'NoArtifectWidget.dart';

class ArtifectDetail extends StatefulWidget {
  ArtifectDetail({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<ArtifectDetail> {
  List<MyFile> list = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Captured Artifact',
          style: TextStyle(color: LightColors.grey, fontSize: MediaQuery.of(context).size.height/50),
        ),
        backgroundColor: LightColors.kGrey,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            color: LightColors.white,
            child: list.length > 0 ? _buildPanel(list) : NoArtifectWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(List<MyFile> list) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.grey,width: 1),),
              height:MediaQuery.of(context).size.height/20,
              child: TextField(
                  cursorColor: Colors.grey,
                  decoration: new InputDecoration(
                    hintText: 'Enter User Name',
                    counterText: "",
                    contentPadding: EdgeInsets.only(left: 15,right: 15),
                    hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/55,color:LightColors.grey),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,

                  ),
                  onChanged: (text) {

                  }
              )),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              list[index].isExpanded = !isExpanded;
            });
          },
          children: list.map<ExpansionPanel>((MyFile item) {
            return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('Candidate ${item.userId}',style: TextStyle(fontSize: MediaQuery.of(context).size.height/50,color: LightColors.grey)),
                  );
                },
                body: ArtifectChild(
                  myFile: item,
                ),
                isExpanded: item.isExpanded);
          }).toList(),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Util.getArtifectFileDetails().then((value) {
      setState(() {
        print('setState ${value.length}');
        list = value;
      });
    });
  }
}
