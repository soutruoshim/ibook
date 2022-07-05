import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:ibook/model/user.dart';
import 'package:ibook/providers/user_provider.dart';
import 'package:ibook/screen/AuthorListScreen.dart';
import 'package:ibook/screen/ChooseTopicScreen.dart';
import 'package:ibook/screen/SelectThemeScreen.dart';
import 'package:ibook/screen/login.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/Extensions/text_styles.dart';
import 'package:ibook/utils/Extensions/user_shared_preference.dart';
import 'package:ibook/utils/colors.dart';
import 'package:ibook/utils/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../component/SettingItemWidget.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import 'AboutUsScreen.dart';
import 'LanguageScreen.dart';
import 'WebViewScreen.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';
  final Function onTap;

  const SettingScreen({required this.onTap});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mLeadingWidget(var icon) {
    return Icon(icon, color: textPrimaryColorGlobal);
  }

  Widget mTailingIcon() {
    return Icon(
      Icons.chevron_right,
      color: textSecondaryColorGlobal,
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    print("usersd ${user.email}");
    return Scaffold(
      appBar: appBarWidget(language.lblSetting,
          color: primaryColor, textColor: Colors.white, showBack: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingItemWidget(
              title: user.email==null || user.email.isEmpty? language.lblLogin:(user.firstname+" "+ user.firstname).toUpperCase(),
              trailing: mTailingIcon(),
              subTitle: user.email==null || user.email.isEmpty? language.lblLoginDes:"Welcome to iBook-Cambodia",
              leading: mLeadingWidget(Feather.user),
              onTap: () async {

                if(user.email == null || user.email.isEmpty){
                  Login().launch(context);
                }else{
                  if (await confirm(
                    context,
                    title: const Text('Logout'),
                    content: const Text('Do you sure you want logout?'),
                    textOK: const Text('Yes'),
                    textCancel: const Text('No'),
                  )) {
                    UserPreferences().removeUser();
                    Login().launch(context);
                    return print('pressedOK');
                  }
                  return print('pressedCancel');
                }
              },
            ),
            SettingItemWidget(
              title: language.lblAuthors,
              trailing: mTailingIcon(),
              subTitle: language.lblAuthorsDes,
              leading: mLeadingWidget(Feather.users),
              onTap: () async {
                AuthorListScreen().launch(context);
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblChooseTopic,
              trailing: mTailingIcon(),
              subTitle: language.lblChooseTopicTitle,
              leading: mLeadingWidget(
                  MaterialCommunityIcons.checkbox_marked_outline),
              onTap: () async {
                ChooseTopicScreen().launch(context);
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblSelectTheme,
              subTitle: language.lblChooseTheme,
              onTap: () async {
                bool res = await SelectThemeScreen().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Slide);
                if (res == true) setState(() {});
                widget.onTap.call();
              },
              trailing: mTailingIcon(),
              leading: mLeadingWidget(MaterialCommunityIcons.theme_light_dark),
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblLanguage,
              subTitle: language.lblLanguageDesc,
              leading: Icon(Ionicons.language_outline),
              trailing: mTailingIcon(),
              onTap: () async {
                bool res = await LanguageScreen().launch(context);
                if (res == true) setState(() {});
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblPushNotification,
              subTitle: language.lblDisableNotification,
              leading: mLeadingWidget(Ionicons.md_notifications_outline),
              onTap: () async {},
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: primaryColor,
                  value: appStore.isNotificationOn,
                  onChanged: (v) {
                    appStore.setNotification(v);
                    setState(() {});
                  },
                ).withHeight(10),
              ),
            ),
            16.height,
            Divider(thickness: 3).paddingOnly(left: 16, right: 16),
            16.height,
            Row(
              children: [
                Container(color: primaryColor, width: 4, height: 16),
                6.width,
                Text(language.lblOthers,
                    style: boldTextStyle(color: primaryColor, size: 14)),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 4),
            SettingItemWidget(
              title: language.lblRateUs,
              trailing: mTailingIcon(),
              onTap: () {
                PackageInfo.fromPlatform().then((value) {
                  String package = '';
                  if (isAndroid) package = value.packageName;
                  launch('${storeBaseURL()}$package');
                });
              },
            ),
            SettingItemWidget(
              title: language.lblPrivacyPolicy,
              trailing: mTailingIcon(),
              onTap: () {
                if (getStringAsync(PRIVACY_POLICY_PREF).isNotEmpty)
                  WebViewScreen(
                          mInitialUrl: getStringAsync(PRIVACY_POLICY_PREF))
                      .launch(context);
                else
                  toast(language.lblUrlEmpty);
              },
            ).visible(!getStringAsync(PRIVACY_POLICY_PREF).isEmptyOrNull),
            SettingItemWidget(
              title: language.lblTermsCondition,
              trailing: mTailingIcon(),
              onTap: () async {
                if (getStringAsync(TERMS_AND_CONDITION_PREF).isNotEmpty)
                  WebViewScreen(
                          mInitialUrl: getStringAsync(TERMS_AND_CONDITION_PREF))
                      .launch(context);
                else
                  toast(language.lblUrlEmpty);
              },
            ).visible(!getStringAsync(TERMS_AND_CONDITION_PREF).isEmptyOrNull),
            SettingItemWidget(
              title: language.lblAboutUs,
              trailing: mTailingIcon(),
              onTap: () {
                AboutUsScreen().launch(context,
                    pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
              },
            ),
          ],
        ),
      ),
    );
  }
}
