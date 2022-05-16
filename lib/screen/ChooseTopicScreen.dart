import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/appWidget.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/AppButton.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import 'DashboardScreen.dart';

class ChooseTopicScreen extends StatefulWidget {
  static String tag = '/ChooseTopicScreen';

  @override
  ChooseTopicScreenState createState() => ChooseTopicScreenState();
}

class ChooseTopicScreenState extends State<ChooseTopicScreen> {
  List<Category>? catResponse = [];
  List<String> selectedId = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    getCategoryList();
  }

  getCategoryList() async {
    appStore.setLoading(true);
    await getCategories().then((value) {
      catResponse = value;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblChooseTopic, color: primaryColor, textColor: Colors.white, showBack: true),
      bottomNavigationBar: AppButtonWidget(
        width: context.width(),
        child: Text(language.lblContinue, style: boldTextStyle(color: Colors.white)),
        shapeBorder: RoundedRectangleBorder(
          borderRadius: radius(defaultAppButtonRadius),
          side: BorderSide(color: primaryColor),
        ),
        onTap: () {
          if (getStringListAsync(chooseTopicList) != null && getStringListAsync(chooseTopicList)!.length >= 3)
            DashboardScreen().launch(context, isNewTask: true);
          else
            toast(language.lblChooseTopicMsg);
        },
        color: primaryColor,
      ).paddingAll(16).visible(catResponse!.isNotEmpty),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Text(language.lblChooseTopicTitle, style: boldTextStyle(size: 24)).paddingOnly(left: 16, right: 16),
                4.height,
                Text(language.lblChooseTopicDesc, style: secondaryTextStyle()).paddingOnly(left: 16, right: 16),
                20.height,
                AnimationLimiter(
                  child: Wrap(
                    runSpacing: 4,
                    children: List.generate(
                      catResponse!.length,
                      (index) {
                        Category data = catResponse![index];
                        return AnimationConfiguration.staggeredGrid(
                          duration: const Duration(milliseconds: 250),
                          columnCount: 1,
                          position: index,
                          child: FlipAnimation(
                            curve: Curves.linear,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: (() {
                                  if (getStringListAsync(chooseTopicList) != null) {
                                    selectedId = getStringListAsync(chooseTopicList)!;
                                    if (selectedId.contains(data.id!.toString()) == true) {
                                      selectedId.remove(data.id!.toString());
                                    } else
                                      selectedId.add(data.id!.toString());
                                    setValue(chooseTopicList, selectedId);
                                  } else {
                                    selectedId.add(data.id!.toString());
                                    setValue(chooseTopicList, selectedId);
                                  }
                                  setState(() {});
                                }),
                                child: Container(
                                    margin: EdgeInsets.only(right: 10, bottom: 8),
                                    decoration: boxDecorationDefaultWidget(
                                        border: Border.all(
                                            width: 0.2,
                                            color: getStringListAsync(chooseTopicList) != null
                                                ? getStringListAsync(chooseTopicList)!.contains(data.id!.toString())
                                                    ? primaryColor
                                                    : textPrimaryColorGlobal
                                                : textPrimaryColorGlobal),
                                        color: getStringListAsync(chooseTopicList) != null
                                            ? getStringListAsync(chooseTopicList)!.contains(data.id!.toString())
                                                ? primaryColor
                                                : context.cardColor
                                            : context.cardColor),
                                    padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                    child: Text(data.name.validate() + " ",
                                        style: primaryTextStyle(
                                            color: getStringListAsync(chooseTopicList) != null
                                                ? getStringListAsync(chooseTopicList)!.contains(data.id!.toString())
                                                    ? Colors.white
                                                    : textPrimaryColorGlobal
                                                : textPrimaryColorGlobal),
                                        textAlign: TextAlign.center)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ).paddingOnly(left: 16),
                16.height,
              ],
            ),
          ),
          mProgress().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
