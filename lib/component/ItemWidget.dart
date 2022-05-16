import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ibook/utils/Extensions/Commons.dart';
import 'package:ibook/utils/Extensions/Constants.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/appWidget.dart';
import 'package:flutter/material.dart';
import 'package:ibook/utils/images.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/text_styles.dart';

class ItemWidget extends StatefulWidget {
  static String tag = '/ItemWidget';
  final Function? onTap;
  final bool? isFavourite;
  final bool? isGrid;
  final bool? isFeatured;
  final Book data;

  ItemWidget(this.data, {this.onTap, this.isFavourite = false, this.isGrid = false, this.isFeatured = false});

  @override
  ItemWidgetState createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget> {
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

  Widget mData() {
    var width = context.width() / 3 - 13.7;
    if (widget.isGrid == true) {
      //var width = context.width() * 0.39;
      return SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () {
            widget.onTap!.call();
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.data.logo != null && widget.data.logo!.isNotEmpty
                  ? cachedImage(widget.data.logo, fit: BoxFit.fill, width: width, height: 160).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(left: 4)
                  : Image.asset(ic_placeholder, fit: BoxFit.fill, width: width, height: 160).cornerRadiusWithClipRRect(defaultRadius),
              6.height,
              Text(parseHtmlStringWidget(widget.data.name!.trim()), textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()).paddingSymmetric(horizontal: 4),
            ],
          ),
        ),
      );
    } else if (widget.isFeatured == true) {
      return SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () {
            widget.onTap!.call();
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.data.logo != null && widget.data.logo!.isNotEmpty)
                cachedImage(widget.data.logo, fit: BoxFit.fill, width: width, height: 160).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(left: 4, right: 4),
              6.height,
              Text(parseHtmlStringWidget(widget.data.name!.trim()), textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()).paddingSymmetric(horizontal: 4),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          widget.onTap!.call();
          setState(() {});
        },
        child: SizedBox(
          width: context.width(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              cachedImage(widget.data.logo, fit: BoxFit.fill, width: 105, height: 140).cornerRadiusWithClipRRect(defaultRadius).paddingOnly(left: 4, right: 4),
              6.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(parseHtmlStringWidget(widget.data.name!.trim()), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, style: boldTextStyle()).expand(),
                      IconButton(
                        onPressed: () {
                          Book mWishListModel = Book();
                          mWishListModel = widget.data;
                          wishListStore.addToWishList(mWishListModel);
                          setState(() {});
                        },
                        icon: Icon(wishListStore.isItemInWishlist(widget.data.id!.toInt()) == false ? MaterialIcons.bookmark_outline : MaterialIcons.bookmark, size: 24),
                      )
                    ],
                  ),
                  Text(parseHtmlStringWidget(widget.data.description!.trim()), overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, maxLines: 2, style: secondaryTextStyle()).paddingRight(16),
                ],
              ).expand()
            ],
          ).paddingOnly(left: 10, bottom: 16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return mData();
  }
}
