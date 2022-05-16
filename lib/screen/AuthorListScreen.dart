import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ibook/component/AuthorComponent.dart';
import 'package:ibook/screen/AuthorDetailScreen.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';

class AuthorListScreen extends StatefulWidget {
  static String tag = '/AuthorListScreen';

  @override
  AuthorListScreenState createState() => AuthorListScreenState();
}

class AuthorListScreenState extends State<AuthorListScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblAuthors, color: primaryColor, textColor: Colors.white, showBack: true),
      body: FutureBuilder<List<Author>>(
        future: getAuthor(),
        builder: (_, snap) {
          if (snap.hasData) {
            return snap.data!.length == 0
                ? noDataWidget(context)
                : SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 16,
                      spacing: 10,
                      children: List.generate(
                        snap.data!.length,
                        (index) {
                          Author data = snap.data![index];
                          return AnimationConfiguration.staggeredGrid(
                            duration: Duration(milliseconds: 750),
                            columnCount: 1,
                            position: index,
                            child: AuthorComponent(data, onTap: () {
                              AuthorDetailScreen(data).launch(context);
                            }),
                          );
                        },
                      ),
                    ).paddingOnly(left: 6),
                  );
          }
          return snapWidgetHelper(snap, loadingWidget: mProgress());
        },
      ),
      bottomNavigationBar: mAuthorBannerAds == '1' ? showBannerAds() : SizedBox(),
    );
  }
}
