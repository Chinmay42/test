import 'dart:io';


import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/hive/artifects/artifectfile.dart';
import 'package:flutter/material.dart';

class ChildGridWidget extends StatelessWidget {

  List<ArtifectFile> list;
  String title;
  ChildGridWidget({this.list,this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10),
            child: Text(title,style: TextStyle(color: LightColors.kBlue,fontSize: MediaQuery.of(context).size.height/55),),),
          GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              shrinkWrap: true,
              children: List.generate(4, (index)
              {
                return  Padding(
                  padding: EdgeInsets.all(3),
                  child: Stack(
                    children: [
                      Card(
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: LightColors.grey,width: 1),
                            image: DecorationImage(
                                image: FileImage(File(list[index].filePath)) ,
                                fit: BoxFit.cover
                            ),
                          ),

                        ),color: LightColors.white,
                        elevation: 5,
                      ),
                      Align(alignment: Alignment.bottomRight ,
                      child: (
                        list[index].status=='success')
                        ?Icon(Icons.check_circle,color: LightColors.kBlue,)
                        :Icon(Icons.cloud_upload,color: LightColors.kBlue,)
                        ,) ],
                  )
                );
              })
          )
        ],
      ),
    );
  }
}
