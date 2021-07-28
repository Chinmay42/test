

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:url_launcher/url_launcher.dart';
import 'ui/CollapsingAppBarWidget.dart';
import 'ui/MapWidget.dart';
import 'util/UtilClass.dart';

class CenterWidget extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CenterWidget> {
  LatLng latLng = LatLng(19.0760, 72.8777);
  String mobNumber = '0123-74546';
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
      
        //theme: ThemeData(primaryColor: Colors.grey[300]),
        home: Scaffold(
          backgroundColor: LightColors.white,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[CollapsingToolBar(_onBackPressed)];
            },
            body: ListView(
              children: [
                Padding(padding: EdgeInsets.only(left:5.0,right:5.0),
                child:Card(
                    color: LightColors.kGrey,
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lipsum.createWord(numWords: 4),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey)),
                          SizedBox(height: 5.0,),        
                          Text(
                            lipsum.createParagraph(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey),
                          )
                        ],
                      ),
                    )),),
                SizedBox(height: 5),
                Padding(padding: EdgeInsets.only(left:5.0,right:5.0),
                child:Card(
                    color: LightColors.kGrey,
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Open Time',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey)),
                          SizedBox(height: 5.0,),
                          Text(
                            '9 AM - 7 PM',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey),
                          )
                        ],
                      ),
                    )),),
                SizedBox(height: 5),
                Padding(padding: EdgeInsets.only(left:5.0,right:5.0),
                child:Card(
                    color: LightColors.kGrey,
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Number:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey)),
                                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mobNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey),
                              ),
                              IconButton(
                                  
                                  onPressed: () {
                                    launch('tel:+$mobNumber');
                                  },
                                  icon: Icon(Icons.call,color: LightColors.grey,size:MediaQuery.of(context).size.height/35))
                            ],
                          )
                        ],
                      ),
                    )),),
                SizedBox(height: 5),
                Padding(padding: EdgeInsets.only(left:5.0,right:5.0),
                child:Card(
                    color: LightColors.kGrey,
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Flexible(
                                child: Text(
                                  'Postmaster, Udaipur City S.O, Udaipur, Rajasthan, India (IN), Pin Code:-313001',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: MediaQuery.of(context).size.height/55,color: LightColors.grey),
                                ),
                                flex: 2,
                              ),
                              new Flexible(
                                child: IconButton(
                                    onPressed: () {
                                      moveToGoogleMap(mylatLng);
                                    },
                                    icon: Icon(Icons.directions,color: LightColors.grey,size:MediaQuery.of(context).size.height/35)),
                                flex: 1,
                              )

                              //
                            ],
                          )
                        ],
                      ),
                    )),),
                Padding(padding: EdgeInsets.only(left:5.0,right:5.0),    
                child:Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: MapWidget(latLng, lipsum.createText()),
                )
                ),
              ],
            ),
          ),
        ));
  }

  _onBackPressed()
  {
    print('onBackPressed');
    Navigator.of(context).pop();
  }
}