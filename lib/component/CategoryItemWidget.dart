import 'package:ibook/utils/Extensions/Constants.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/decorations.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/appWidget.dart';
import 'package:flutter/material.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/images.dart';

class CategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final Category data;
  final Function? onTap;

  CategoryItemWidget(this.data, {this.onTap});

  @override
  CategoryItemWidgetState createState() => CategoryItemWidgetState();
}

class CategoryItemWidgetState extends State<CategoryItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
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
          widget.onTap!.call();
          setState(() {});
        },
        child: Container(
          decoration: boxDecorationDefaultWidget(
            borderRadius: radius(defaultRadius),
            color: context.cardColor,
          ),
          width: context.width() / 2 - 20,
          child: Column(
            children: [
              widget.data.logo != null && widget.data.logo!.isNotEmpty
                  ? cachedImage(widget.data.logo!.validate(), height: 160, width: 160, fit: BoxFit.fill).cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt())
                  : Image.asset(ic_placeholder, height: 85, width: 85, fit: BoxFit.fill).paddingOnly(top: 25),
              8.height,
              Text(
                widget.data.name.validate(),
                style: boldTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ).paddingOnly(left: 2, right: 2).center(),
              8.height,
            ],
          ),
        ).paddingBottom(16));
  }
}
