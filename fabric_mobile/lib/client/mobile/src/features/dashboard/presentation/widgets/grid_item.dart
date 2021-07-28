
import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:fabric_mobile/client/mobile/src/features/dashboard/presentation/widgets/gridmodel.dart';
import 'package:flutter/material.dart';


class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
        color: LightColors.kGrey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                
                gridModel.icons,
                color: gridModel.color,
                size: MediaQuery.of(context).size.height/30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  gridModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height/60,color: gridModel.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
