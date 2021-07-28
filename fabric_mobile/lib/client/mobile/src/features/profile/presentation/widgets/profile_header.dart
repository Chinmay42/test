import 'package:fabric_mobile/client/mobile/src/core/components/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

import 'avatar.dart';

class ProfileHeader extends StatelessWidget {
  final Image coverImage;
  final AssetImage avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).size.height / 7;
    return Stack(
      children: <Widget>[
        Ink(
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(
              color: LightColors.kGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 7,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: MediaQuery.of(context).size.width / 11,
                backgroundColor: LightColors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(title,
                  style: TextStyle(
                      color: LightColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 25)),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: LightColors.grey, fontWeight: FontWeight.bold),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
