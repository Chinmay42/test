

import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/profile/data/models/sharepref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imei_plugin/imei_plugin.dart';

class UserInfo extends StatefulWidget {
//  static final String path = "lib/src/pages/profile/profile8.dart";


  @override
  UserInfoState createState() => new UserInfoState();
  final bool androidFusedLocation=false;
}

class UserInfoState  extends State<UserInfo> {

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
    initPlatformState();


  }


  Future<void> initPlatformState() async {
    String platformImei;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );

      var data = await ImeiPlugin.getImeiMulti();

      data.forEach((element) {print('Get Multi Imei $element');});
      var idunique = await ImeiPlugin.getId();

      print("Device id $idunique");

      setState(() {
        Imei = platformImei;
        print('shared_pref'+ platformImei );
      });
     

    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }

 


  _initCurrentLocation() {
    Geolocator().isLocationServiceEnabled().then((value) {
      print('isLocationServiceEnabled $value');
      Geolocator()
        ..forceAndroidLocationManager = !widget.androidFusedLocation
        ..getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ).then((position) {
          if (mounted) {
            // setState(() => _currentPosition = position);

            print("latitude " + position?.toString());

            setState(() {
              latitude =  position?.latitude?.toString();
              longitude = position?.longitude?.toString();
            });

          }


        }).catchError((e) {

        });
    });


  }


  String Imei;
  String latitude;
  String longitude;

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.only(top:10.0,left: 10.0,right: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text("User Information",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/25,),
              textAlign: TextAlign.left,
            ),
          ),

          SizedBox(height: 5.0),

          Card(
            
            color: LightColors.kGrey,
            elevation: 1,
            child: Container(
              //height: MediaQuery.of(context).size.height/1.99,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[


                  ListTile(
                     contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, ),
                    leading: Icon(Icons.business,color: LightColors.grey,size:MediaQuery.of(context).size.width/15,),
                    title: Text("IP",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/30)),
                    subtitle: Padding(padding: EdgeInsets.only(top:5.0),
                    child:Text("1.1.1.1",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.width/30),),
                    ),
                  ),

                  //SizedBox(height: 5.0,),

                  Divider(color: LightColors.grey,),

                  //SizedBox(height: 5.0,),

                  ListTile(
                      contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, ),
                    leading: Icon(Icons.phone,color: LightColors.grey,size:MediaQuery.of(context).size.width/15),
                    title: Text("Mobile No.",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/30 )),
                    subtitle:  Padding(padding: EdgeInsets.only(top:10.0), 
                    child:Text("+91-9888777777",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.width/30)),
                    ),
                  ),
                  //SizedBox(height: 5.0,),
                  Divider(color: LightColors.grey,),
                  //SizedBox(height: 5.0,),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, ),
                    leading: Icon(Icons.phone,color: LightColors.grey,size:MediaQuery.of(context).size.width/15),
                    title: Text("IMEI",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/30)),
                    subtitle:  Padding(padding: EdgeInsets.only(top:10.0), 
                    child:Text(Imei != null
                       ? Imei
                       : "Unavailable",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.width/30)),
                    ),
                  ),
                  //SizedBox(height: 5.0,),
                  Divider(color: LightColors.grey,),
                  //SizedBox(height: 5.0,),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, ),
                    leading: Icon(Icons.gps_fixed,color: LightColors.grey,size:MediaQuery.of(context).size.width/15),
                    title: Text("Latitude",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/30)),
                    subtitle:  Padding(padding: EdgeInsets.only(top:10.0),
                    child:Text(latitude != null
                    ? latitude
                    : "Unavailable",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.width/30)),
                    ),
                  ),
                  //SizedBox(height: 5.0,),
                  Divider(color: LightColors.grey,),
                  //SizedBox(height: 5.0,),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, ),
                    leading: Icon(Icons.gps_fixed,color: LightColors.grey,size:MediaQuery.of(context).size.width/15),
                    title: Text("Longitude",style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width/30)),
                    subtitle:  Padding(padding: EdgeInsets.only(top:10.0), 
                    child:Text(longitude !=null
                    ? longitude
                    : "Unavailable",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.width/30)),
                    ),
                  ),
                  //SizedBox(height: 15.0),

                  //],
                  // )
                ],
              ),
            ),
          ),

          // SizedBox(height: 30.0,),



        ],
      ),
    );
  }





}
