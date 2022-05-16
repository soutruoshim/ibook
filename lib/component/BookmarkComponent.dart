import 'package:flutter/material.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/colors.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';

class BookmarkComponent extends StatefulWidget {
  static String tag = '/BookmarkComponent';
  final Function? onTap;
  final Book data;
  final bool isSlider;

  BookmarkComponent(this.data, {this.onTap, this.isSlider = false});

  @override
  BookmarkComponentState createState() => BookmarkComponentState();
}

class BookmarkComponentState extends State<BookmarkComponent> {
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
    return widget.isSlider == false
        ? Container(
            decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: context.cardColor, borderRadius: radius(defaultRadius), border: Border.all(width: 0.4, color: textSecondaryColorGlobal)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 120,
                    height: 150,
                    decoration: boxDecorationWithRoundedCornersWidget(
                      borderRadius: BorderRadius.only(
                        topLeft: radiusCircular(defaultRadius),
                        bottomLeft: radiusCircular(defaultRadius),
                      ),
                      backgroundColor: primaryColor.withOpacity(0.2),
                    ),
                    child: cachedImage(widget.data.logo, fit: BoxFit.fill).paddingAll(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, style: boldTextStyle()),
                    4.height,
                    Text(parseHtmlStringWidget(widget.data.description!.trim()), overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, maxLines: 2, style: secondaryTextStyle()),
                  ],
                ).paddingAll(16).expand()
              ],
            ),
          ).onTap(() {
            widget.onTap!.call();
            setState(() {});
          }).paddingBottom(16)
        : Container(
            width: 150,
            margin: EdgeInsets.only(bottom: 16,right: 8),
            decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: context.cardColor, borderRadius: radius(defaultRadius), border: Border.all(width: 0.4, color: textSecondaryColorGlobal)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 150,
                    height: 200,
                    decoration: boxDecorationWithRoundedCornersWidget(
                        borderRadius: BorderRadius.only(
                          topLeft: radiusCircular(defaultRadius),
                          topRight: radiusCircular(defaultRadius),
                        ),
                        backgroundColor: primaryColor.withOpacity(0.2)),
                    child: cachedImage(widget.data.logo, fit: BoxFit.fill).paddingAll(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, style: boldTextStyle()),
                    4.height,
                    Text(parseHtmlStringWidget(widget.data.description!.trim()), overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, maxLines: 2, style: secondaryTextStyle()),
                  ],
                ).paddingAll(10)
              ],
            ),
          ).onTap(() {
            widget.onTap!.call();
            setState(() {});
          });
  }
}
