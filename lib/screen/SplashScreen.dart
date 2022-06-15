import 'package:ibook/screen/GetStaredScreen.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/decorations.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/constant.dart';
import 'package:ibook/utils/images.dart';
import 'package:flutter/material.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import 'DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await 2.seconds.delay;
    bool seen = (getBoolAsync('isFirstTime'));
    if (seen) {
      DashboardScreen().launch(context, isNewTask: true);
    } else {
      await setValue('isFirstTime', true);
      GetStaredScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Image.asset(ic_logo, fit: BoxFit.fill, width: 100, height: 100)),
          16.height,
          Text(AppName, style: boldTextStyle(size: 26, color: Colors.white)),
        ],
      ).center(),
    );
  }
}
