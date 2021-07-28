
import 'package:fabric_mobile/client/mobile/src/core/components/color_loader.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class OTP extends StatefulWidget{

 const OTP({Key key}) : super(key: key);
  @override
  OTPState createState() => new OTPState();
}

class OTPState extends State<OTP>
    with TickerProviderStateMixin {

@override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 4),
            () {
              Toast.show('OTP validated successfully!',context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
              Navigator.pushReplacementNamed(context, '/profile');
            });
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    backgroundColor: LightColors.white,
    body: Center(

      child: Padding(
                padding: const EdgeInsets.all(36.0),
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

              InkWell(
           
                  onTap: (){
                        //     Navigator.pushNamed(context, '/profile');
                             },

                   child: ColorLoader3(
                   radius: MediaQuery.of(context).size.width/10,
                   dotRadius:MediaQuery.of(context).size.width/50 ,
                 ),
              
              ),
          
            SizedBox(height: 25.0,),

            Container(
              alignment: Alignment.center,
                width:MediaQuery.of(context).size.width/1.2,
                height:MediaQuery.of(context).size.width/5,
              child:Text('AUTO OTP VALIDATION IN PROGRESS...',
              style:TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width/25)),

            ),


                  ]
          ),
  
           ),

      ),
    
    );
  }


}