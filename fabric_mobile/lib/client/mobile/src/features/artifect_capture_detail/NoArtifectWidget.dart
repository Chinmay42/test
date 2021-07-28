import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
class NoArtifectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return Center(
        child:Padding(
          padding: EdgeInsets.all(20),
          child: Column(
           children: [
            SizedBox(height: 50 ,),
            Image.asset('assets/no_data.jpg',height: MediaQuery.of(context).size.height/3,width: MediaQuery.of(context).size.height/3,),
            SizedBox(height: 15,),
            Text('No Artifacts capture record found.\nPlease capture first!',textAlign: TextAlign.center,style:TextStyle(color:LightColors.grey,fontSize: MediaQuery.of(context).size.height/45))
          ],
          ),
        )
    );
  }
}
