import 'dart:convert';

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/qr_scanner/presentation/widgets/qr_details.dart';
import 'package:fabric_mobile/client/mobile/src/features/upload_status/presentation/widgets/userqr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UploadStatsListScreen extends StatefulWidget {
  const UploadStatsListScreen(
      {Key key, this.animationController, this.userList})
      : super(key: key);
  final AnimationController animationController;
  final List<String> userList;

  @override
  _UploadStatsListScreenState createState() =>
      _UploadStatsListScreenState(userList);
}

class _UploadStatsListScreenState extends State<UploadStatsListScreen> {
  TextEditingController _textController = TextEditingController();
  AnimationController animationController;
  _UploadStatsListScreenState(List<String> userList) {
    this.listString = userList;
    if (this.listString == null) {
      this.listString = [];
    }
  }

  List<String> listString;

  List<String> newDataList;
  onItemChanged(String value) {
    setState(() {
      newDataList = listString
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
      print(' new : $newDataList');
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: LightColors.grey,
        ),
        title: Text(
          "Scanned Candidate List",
          style: TextStyle(
              color: LightColors.grey,
              fontSize: MediaQuery.of(context).size.height / 45),
        ),
        backgroundColor: LightColors.kGrey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 10,
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  onItemChanged(value);
                  print('$value');
                },
                controller: _textController,
                decoration: InputDecoration(
                    // labelText: "Search",
                    hintText: "   Search",
                    hintStyle: TextStyle(
                        color: LightColors.grey,
                        fontSize: MediaQuery.of(context).size.height / 55),
                    suffixIcon: Icon(
                      Icons.search,
                      size: MediaQuery.of(context).size.height / 35,
                      color: LightColors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: listString.length,
                  itemBuilder: (context, index) {
                    return createChildView(listString[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  createChildView(String listString) {
    //print('list value : $listString');
    UserQR user = UserQR.fromJson(jsonDecode(listString));
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      direction: Axis.horizontal,
      actionExtentRatio: 0.25,
      closeOnScroll: true,
      child: itemWidget(user),
      actions: <Widget>[
        IconSlideAction(
          icon: Icons.delete_forever,
          caption: 'Delete',
          color: LightColors.kRed,
          onTap: () {
            print('Delete');
          },
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          icon: Icons.add_circle_outline,
          caption: 'Capture',
          color: LightColors.kBlue,
          onTap: () {
            Map<String, dynamic> map = jsonDecode(listString);
            // Future.delayed(const Duration(seconds: 3), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QRDetailsPage(
                          str1: map,
                          title: listString,
                        )));
          },
        ),
      ],
    );
  }

  itemWidget(UserQR user) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.height / 30,
              backgroundColor: LightColors.kGrey,
              child: Image.asset('assets/avatar.jpg', fit: BoxFit.fitWidth),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2),
                  child: Text(user.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: LightColors.grey,
                        fontSize: MediaQuery.of(context).size.height / 55,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(
                  user.contactNumber ?? '',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 60),
                ),
                Text(
                  user.registrationNumber ?? '',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 60),
                ),
                Text(
                  user.labNo ?? '',
                  style: TextStyle(
                      color: LightColors.grey,
                      fontSize: MediaQuery.of(context).size.height / 60),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(user.batchTiming ?? '',
                    style: TextStyle(
                        color: LightColors.kGreen,
                        fontSize: MediaQuery.of(context).size.height / 60)),
              ],
            )
          ],
        ));
  }
}
