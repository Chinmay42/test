
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class CollapsingToolBar extends StatelessWidget {

  Function function;
  CollapsingToolBar(this.function);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      
      backgroundColor: LightColors.kGrey,
      pinned: true,
      leading: GestureDetector(
          onTap: () {
            print("onTab");
            function();
            },
          child: Icon(Icons.keyboard_backspace,color: LightColors.grey,)),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.search,color: LightColors.grey,size:MediaQuery.of(context).size.height/35 ,),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          'Exam Center 1',
          style: TextStyle(fontSize: MediaQuery.of(context).size.height/50,color: LightColors.grey),
        ),
        background: Image.asset(
          'assets/demo.jpg', // <===   Add your own image to assets or use a .network image instead.
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
