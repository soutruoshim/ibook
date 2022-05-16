import 'package:flutter/material.dart';
import 'package:ibook/model/DashboardResponse.dart';
import 'package:ibook/screen/WebViewScreen.dart';
import 'package:ibook/utils/Extensions/Constants.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';

import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';

class HomeSliderComponent extends StatefulWidget {
  static String tag = '/HomeSliderComponent';

  final AppSlider mSliderList;

  HomeSliderComponent(this.mSliderList);

  @override
  HomeSliderComponentState createState() => HomeSliderComponentState();
}

class HomeSliderComponentState extends State<HomeSliderComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WebViewScreen(mInitialUrl: widget.mSliderList.url.toString()).launch(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedImage(widget.mSliderList.imageUrl.toString(), height: context.height() * 0.25, fit: BoxFit.fill, width: context.width()).cornerRadiusWithClipRRect(defaultRadius),
          Container(
            decoration: boxDecorationWithShadowWidget(borderRadius: radius(defaultRadius), gradient: LinearGradient(colors: [Colors.transparent, Colors.black87], begin: Alignment.center, end: Alignment.bottomCenter)),
            width: context.width(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Text(widget.mSliderList.title!, style: primaryTextStyle(color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 2).paddingAll(16),
          )
        ],
      ),
    );
  }
}
