
import 'package:fabric_mobile/client/mobile/src/core/components/Consts.dart';
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


class CustomDialog extends StatelessWidget {
  final String title, buttonTextFirst, buttonTextSecond;
  final Image image;
  static const IconData fingerprint =
  IconData(0xe90d, fontFamily: 'MaterialIcons');
  CustomDialog({
    @required this.title,
    @required this.buttonTextFirst,
    @required this.buttonTextSecond,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context)
  {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: LightColors.grey,
                  fontSize: MediaQuery.of(context).size.height/52,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 20.0),
              new Row(
                mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    
                    RaisedButton(onPressed:()
                    {
                      print('select');
                      Navigator.pop(context,buttonTextFirst);


                      },child: new Text(buttonTextFirst,style:TextStyle(color:LightColors.grey,fontSize: MediaQuery.of(context).size.height/50)),padding: const EdgeInsets.all(10),),
                    SizedBox(width:25.0),
                    RaisedButton(onPressed: ()
                    {
                      print('select');
                      Navigator.pop(context,buttonTextSecond);

                    },child: new Text(buttonTextSecond,style:TextStyle(color:LightColors.grey,fontSize: MediaQuery.of(context).size.height/50)),padding: const EdgeInsets.all(10),)
                  ]
              ),
              SizedBox(height: 24.0),

            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: LightColors.white,
            child:  new Icon(Icons.fingerprint, size: MediaQuery.of(context).size.height/9, color: LightColors.grey),
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }


}