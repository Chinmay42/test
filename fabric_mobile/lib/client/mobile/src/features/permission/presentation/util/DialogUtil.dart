
import 'package:app_settings/app_settings.dart';
import 'package:fabric_mobile/client/mobile/src/features/permission/presentation/util/style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Constants.dart';



class DialogUtil
{

  DialogUtil._privateConstructor();

  static final DialogUtil instance = DialogUtil._privateConstructor();

  showMoveSettingDialog(BuildContext context,List<String> permissionString,{Function cancelFunction,Function operationFunction}) {

    // show the dialog


    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return  Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Container(

              width: 300.0,
              margin: const EdgeInsets.all(20),

              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(Constants.title,style: getPermissionDialogTextStyle(context),),
                      SizedBox(height: 20,),
                      _createPermissionList(permissionString,context),
                      SizedBox(height: 20,),
                      Text(Constants.moveToSetting,style: getPermissionDialogTextStyle(context),),
                      SizedBox(height: 20,),
                      Row(mainAxisAlignment: MainAxisAlignment.end,children: [actionButton(Constants.cancel,context,function: cancelFunction),actionButton(Constants.openSetting,context,function: operationFunction)],)
                    ],
                  )
                ],
              )
          ),
        );
      },
    );
  }



  permissionChild(BuildContext context,String name)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start ,
      children: [
        SizedBox(width: 10,),
        Icon(Icons.star_border,size: 10,),
        SizedBox(width: 10,),
        Text(name,style: getPermissionDialogTextStyle(context,size: 16,color:Colors.black ),),
        SizedBox(height: 30,)
      ],);
  }
  actionButton(String name,BuildContext context,{Function function})
  {
    return TextButton(
      child: Text(name.toUpperCase(), style: getPermissionDialogButtonStyle(context)),
      onPressed: () {

        if(function!=null)
        {
          function.call();
        }
        Navigator.pop(context);
      },
    );
  }



  _createPermissionList(List<String> permissionString,BuildContext context)
  {
    return  Container(
      child: ListView.builder(
          itemBuilder: (context, index) => permissionChild(context,permissionString[index]),
          itemCount: permissionString.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true),
    );
  }



  //show Aain for confirm view

  showViewAgainPermissionDialog(BuildContext context,Function function,{Function cancelFunction}) {

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return  Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Container(

              width: 300.0,
              margin: const EdgeInsets.all(20),

              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(Constants.reviewPermissionNeed,style: getPermissionDialogTextStyle(context),),
                      SizedBox(height: 5,),
                      Text(Constants.wouldYou,style: getPermissionDialogTextStyle(context),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          actionButton(Constants.cancel,context,function: cancelFunction,),
                          actionButton(Constants.tryAgain,context,function: function)
                        ],
                      )
                    ],
                  )
                ],
              )
          ),
        );
      },
    );
  }
}