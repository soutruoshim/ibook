import 'dart:async';
import 'dart:convert';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:ibook/model/user.dart';
import 'package:ibook/providers/user_provider.dart';
import 'package:ibook/screen/PaymentInstroduction.dart';
import 'package:ibook/screen/login.dart';
import 'package:ibook/utils/Extensions/Commons.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/decorations.dart';
import 'package:ibook/utils/Extensions/int_extensions.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/Extensions/text_styles.dart';
import 'package:ibook/utils/appWidget.dart';
import 'package:provider/provider.dart';
import '../component/PDFViewerComponent.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import '../utils/images.dart';
import 'WebViewScreen.dart';

class BookDetailScreen extends StatefulWidget {
  static String tag = '/BookDetailScreen';
  final Book data;

  BookDetailScreen({required this.data});

  @override
  BookDetailScreenState createState() => BookDetailScreenState();
}

class BookDetailScreenState extends State<BookDetailScreen> {
  String? formatted;
  User? user;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
    if (mWebInterstitialAds == '1') loadInterstitialAds();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (mWebInterstitialAds == '1') {
      if (mAdShowBookDetailCount < int.parse(adsInterval)) {
        mAdShowBookDetailCount++;
      } else {
        mAdShowBookDetailCount = 0;
        showInterstitialAds();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    getLblReadBook();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: context.statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              overflow: Overflow.visible,
              children: [
                Container(
                  height: 200,
                  width: context.width(),
                  color: primaryColor.withOpacity(0.2),
                ),
                Positioned(
                  top: 2,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColorGlobal),
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Positioned(
                  bottom: -50,
                  right: 16,
                  left: 16,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.data.name.validate(), style: boldTextStyle(size: 18), maxLines: 4, overflow: TextOverflow.ellipsis),
                          8.height,
                          Text(language.lblBy + " " + widget.data.authorName.validate(), style: secondaryTextStyle()),
                        ],
                      ).paddingOnly(bottom: 16, right: 16).expand(),
                      widget.data.logo != null
                          ? cachedImage(widget.data.logo.validate(), height: 210, width: 150, fit: BoxFit.fill).cornerRadiusWithClipRRect(defaultRadius)
                          : Image.asset(ic_placeholder, height: 150, width: 120, fit: BoxFit.fill).cornerRadiusWithClipRRect(defaultRadius),
                    ],
                  ),
                )
              ],
            ),
            35.height,
            Text(language.lblDescription, style: boldTextStyle()).paddingOnly(left: 16, bottom: 8),
            Text(parseHtmlString(widget.data.description.validate()), style: secondaryTextStyle(size: 16)).paddingOnly(left: 16, right: 16, bottom: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: context.width(),
        decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: primaryColor, borderRadius: radius(defaultRadius)),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Book mWishListModel = Book();
                mWishListModel = widget.data;
                wishListStore.addToWishList(mWishListModel);
                setState(() {});
              },
              icon: Icon(wishListStore.isItemInWishlist(widget.data.id!.toInt()) == false ? MaterialIcons.bookmark_outline : MaterialIcons.bookmark, size: 24, color: Colors.white),
            ),
            Container(width: 2, height: 50, color: Colors.white),
            GestureDetector(
              onTap: () {

                // if(widget.data.price.toDouble() == 0){
                //
                // }else{
                //
                // }

                switch(gotoPay) {
                  case "read": {
                    if (widget.data.type == "file") {
                      if (widget.data.type.isEmptyOrNull) {
                        toast(language.lblTryAgain);
                      } else if (!widget.data.file!.contains(".pdf")) {
                        WebViewScreen(mInitialUrl: widget.data.file!).launch(context);
                      } else {
                        PDFViewerComponent(url: widget.data.file!).launch(context);
                      }
                    } else {
                      if (widget.data.url.isEmptyOrNull) {
                        toast(language.lblTryAgain);
                      } else if (!widget.data.url!.contains(".pdf")) {
                        WebViewScreen(mInitialUrl: widget.data.url!).launch(context);
                      } else {
                        PDFViewerComponent(url: widget.data.url!).launch(context);
                      }
                    }
                  }
                  break;

                  case "login": {
                    Login().launch(context);
                  }
                  break;
                  case "process": {
                    showAlertDialog(context);
                  }
                  break;
                  case "gotopay": {
                     PaymentInstruction(widget.data).launch(context);
                  }
                  break;
                }
              },
              child: Text(lblReadBook, style: boldTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.center),
            ).expand()
          ],
        ),
      ).paddingAll(24),
    );
  }

  String lblReadBook = "Read Book";
  String gotoPay = "read";

  getLblReadBook() {
    if(widget.data.price.toDouble() > 0){
         // check user is active
         if(user!.userId !=""){
           orderCheck(user!.userId, widget.data.id).then((value) => {
           });
         }else{
           //print("user null and book price");
           setState(() {
              lblReadBook = "Buy \$ " + widget.data.price.toString();
              gotoPay = "login";
           });
         }
    }
  }

  Future<FutureOr> orderCheck(String user_id, String? book_id) async {
    final Map<String, dynamic> apiBodyData = {
      'user_id': user_id,
      'book_id': book_id,
    };
    print(apiBodyData);

    Response response = await post(
        Uri.parse(ordercheck_url),
        body: json.encode(apiBodyData),
        headers: <String, String>{'Content-Type':'application/json'}
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData['order']['payment_status'] != null){
        if(responseData['order']['payment_status'] == 'pending'){
          setState(() {
            lblReadBook = "Process Confirm";
            gotoPay = "process";
          });
        }else{
          setState(() {
            lblReadBook = "Read Book";
            gotoPay = "read";
          });
        }

      }else{
        setState(() {
            lblReadBook = "Buy \$ " + widget.data.price.toString();
            gotoPay = "gotopay";
        });
      }

    }
    return response;
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order Book"),
      content: Text("Your order processing to confirm."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
