/*import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import "package:flutter/material.dart";

class ArtifactBox extends StatelessWidget {

  ArtifactBox() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget> [
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
        ],
        ),

    );
  }
}
*/