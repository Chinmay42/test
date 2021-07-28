//import 'package:attnd/core/Components/InputFields.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/round_button.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/my_exams/login(cac_id)/selfie_upload/presentation/widgets/selfie_upload.dart';
import 'package:flutter/material.dart';

class TextFields extends StatefulWidget {
  TextFields();

TextFieldsState createState() => new TextFieldsState();
}




class TextFieldsState extends State<TextFields>
{

  final cac_id = TextEditingController();
  final password2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: new EdgeInsets.symmetric(horizontal: 15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

             
             Card(
               elevation: 1,
               color: LightColors.kGrey,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
              ListTile(
                 contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),

               title: TextFormField(
                 
                 controller: cac_id,
                autofocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                hintText : ('Enter Your CAC_ID'),
                    hintStyle: TextStyle(
                      color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/60
                      
                    ),
                    suffixIcon:  Icon(Icons.person_outline,color: LightColors.grey,size: MediaQuery.of(context).size.height/30,)),
              ),
              ),
                SizedBox(height: 10.0),

              ListTile(
                        contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),

              title: TextFormField(
                  autofocus: false,
                  controller: password2,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    hintText: "Enter your Password",
                      hintStyle: TextStyle(
                        color: LightColors.grey,fontSize: MediaQuery.of(context).size.height/60
                      ),
                      suffixIcon: Icon(Icons.lock_outline,color: LightColors.grey,size: MediaQuery.of(context).size.height/30,)),
              ),
              ),

              SizedBox(height: 10.0,),

                  Divider(color: LightColors.grey,),
              
              SizedBox(height: 10.0),
                ListTile(
                       contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),

                                 title: SimpleRoundButton(
                                     onPressed: () {
                                      
                                        print(' CAC_ID:  ${cac_id.text}');
                                        print(' pass:  ${password2.text}');
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => SelfieUpload(),
                                          ),
                                        );
                                     },
                                     backgroundColor:LightColors.kGrey ,
                                      buttonText: Text('Sign In',style: TextStyle(color: LightColors.grey,fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.height/50 ),
                                     ),
                                     ),
                                     
                                     ),
                SizedBox(height: 15.0),
                ],
              ),
            ),
             ),
            ],
          )),
        ],
      ),
    ));
  }
}
