import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ibook/component/AuthorComponent.dart';
import 'package:ibook/screen/AuthorDetailScreen.dart';
import 'package:ibook/utils/Extensions/Constants.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/decorations.dart';
import 'package:ibook/utils/Extensions/text_styles.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';

class PaymentInstruction extends StatefulWidget {
  static String tag = '/PaymentIntroduction';

  @override
  PaymentInstructionState createState() => PaymentInstructionState();
}

class PaymentInstructionState extends State<PaymentInstruction> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    if (mAuthorListInterstitialAds == '1') loadInterstitialAds();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (mAuthorListInterstitialAds == '1') {
      if (mAdShowAuthorListCount < int.parse(adsInterval)) {
        mAdShowAuthorListCount++;
      } else {
        mAdShowAuthorListCount = 0;
        showInterstitialAds();
      }
    }
    super.dispose();
  }
  final appBar = appBarWidget(language.lblIntroduction, color: primaryColor, textColor: Colors.white, showBack: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: _buildBody(context),
      bottomNavigationBar: Container(
        width: context.width(),
        height: 50.0,
        decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: primaryColor, borderRadius: radius(defaultRadius)),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                PaymentInstruction().launch(context);
              },
              child: Text("Go Payment", style: boldTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.center),
            ).expand()
          ],
        ),
      ).paddingAll(24),
    );
  }

  _buildBody(context) {
    final minHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
