import 'dart:io';



import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



import 'package:flutter/material.dart';



class UploadStatsArtifactsScreen extends StatefulWidget {

  @override
  _UploadStatsArtifactsScreenState createState() => _UploadStatsArtifactsScreenState();

}

class _UploadStatsArtifactsScreenState extends State<UploadStatsArtifactsScreen> {

  File _candidateImage ;
  File _counterfoilImage;
  File _idProof;
  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: LightColors.kGrey,
        elevation: 1,
        title: Text("Artifacts Upload Progress",style: TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/45),),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    print(MediaQuery.of(context).size.height/1.5);
    print(MediaQuery.of(context).size.width);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left:10.0,right: 10.0),
      child: Column(
        children: <Widget>[
          // _buildHeader(),
          const SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) ,
                      elevation: 1,
                      child:  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors.grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),

                        height: MediaQuery.of(context).size.height/2.5,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: _candidateImage == null
                                  ? Icon(Icons.photo_camera,color: LightColors.grey,size: MediaQuery.of(context).size.height/5,)
                                  : Image.file(_candidateImage,height: 200,width: 130,),
                            ),

                            SizedBox(height: 10.0,),

                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width/3,
                              alignment: MainAxisAlignment.center,
                              lineHeight: 5.0,
                              percent: 0.5,
                              backgroundColor: LightColors.grey,
                              progressColor: LightColors.kBlue,
                            ),

                            SizedBox(height: 15.0,),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Candidate\nPhoto",
                                        textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/50),
                                    ),
                                  ),

                                  SizedBox(width: 10.0,),
                                  _candidateImage == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                ]
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) ,
                      elevation: 1,
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors.grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),

                        height: MediaQuery.of(context).size.height/2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: _idProof == null
                                  ? Icon(Icons.file_upload,size: MediaQuery.of(context).size.height/5,color: LightColors.grey,)
                                  : Image.file(_idProof,height: 200,width: 130),//color: LightColors.grey,)
                            ),

                            SizedBox(height: 10.0,),

                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width/3,
                              alignment: MainAxisAlignment.center,
                              lineHeight: 5.0,
                              percent: 0.5,
                              backgroundColor: LightColors.grey,
                              progressColor: LightColors.kBlue,
                            ),

                            SizedBox(height: 15.0,),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ID Proof",
                                      style:
                                      TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/50),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),

                                  _idProof == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) ,
                      elevation: 1,
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors.grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),

                        height: MediaQuery.of(context).size.height/2.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child:// Icon(Icons.fingerprint,size: 150,)
                              Icon(Icons.fingerprint,size:MediaQuery.of(context).size.height/5,color: LightColors.grey,),//color: LightColors.grey,)
                            ),
                            SizedBox(height: 10.0,),

                            LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width/3,
                              lineHeight: 5.0,
                              percent: 0.5,
                              backgroundColor: LightColors.grey,
                              progressColor: LightColors.kBlue,
                            ),

                            SizedBox(height: 15.0,),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children :[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Biometrics",
                                      style:
                                      TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/50),
                                    ),
                                  ),
                                   SizedBox(width: 10.0,),

                                  _idProof == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                  

                                ]
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)) ,
                      elevation: 1,
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: LightColors.white,
                          border: Border.all(
                            color: LightColors.grey, //                   <--- border color
                            width: 2.0,
                          ),
                        ),

                        height: MediaQuery.of(context).size.height/2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                child: _counterfoilImage == null
                                    ? Icon(Icons.camera_front,size: MediaQuery.of(context).size.height/5,color: LightColors.grey,)
                                    : Image.file(_counterfoilImage,height: 200,width: 130,)//color: LightColors.grey,)
                            ),

                            SizedBox(height: 15.0,),

                          
                              LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              width: MediaQuery.of(context).size.width/3,
                              lineHeight: 5.0,
                              percent: 0.5,
                              backgroundColor: LightColors.grey,
                              progressColor: LightColors.kBlue,
                            ),
                            
                            SizedBox(height: 15.0,),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    //width: MediaQuery.of(context).size.width/4,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Counterfoil",
                                      style:
                                      TextStyle(color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/50),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  _counterfoilImage == null
                                      ? notUploadedIcon()
                                      : uploadedIcon(),
                                ]
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
          SizedBox(height: 20.0,),

        ],
      ),
    );
  }

  CircleAvatar uploadedIcon() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height/70,
      backgroundColor: LightColors.kGreen,
      child: Icon(Icons.check,size:  MediaQuery.of(context).size.height/50,color: LightColors.white,),
    );
  }

   CircleAvatar notUploadedIcon() {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height/70,
      backgroundColor: LightColors.kRed,
      child: Icon(Icons.close,size:  MediaQuery.of(context).size.height/50,color: LightColors.white),
    );
  }



}
