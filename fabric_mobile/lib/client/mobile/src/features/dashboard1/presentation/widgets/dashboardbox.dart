




import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/formbuilder/presentation/pages/formbuilder_page.dart';
import 'package:flutter/material.dart';
//import 'package:random_color/random_color.dart';

Widget createGridItem(String name, String examtype) {
 // RandomColor _randomColor = RandomColor();

  //var color = _randomColor.randomColor();
  var icondata = Icons.access_time;

  return Builder(builder: (context) {
    //SizedBox(height: 10.0,);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 10.0),
      child: Card(
        elevation: 10,
        color: LightColors.kGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: LightColors.grey,width:2.0),
        ),
        child: InkWell(
          onTap: () {
            // Scaffold.of(context)
            //     .showSnackBar(SnackBar(content: Text("Selected Item $name")));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FormBuilderScreen(formtitle: name, examtype: examtype)),
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icondata,
                  size: 40,
                  color: LightColors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name != null ? name : '',
                    style: TextStyle(color: LightColors.grey),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  });
}
