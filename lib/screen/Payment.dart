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
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Payment extends StatefulWidget {
  Payment() : super();
  static String tag = '/PaymentIntroduction';
  final String title = "Upload Image Demo";

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File>? file;
  String status = '';
  String base64Image = "";
  File? tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker().getImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

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
                Payment().launch(context);
              },
              child: Text("Pay now", style: boldTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.center),
            ).expand()
          ],
        ),
      ).paddingAll(24),
    );
  }
  Widget showImage() {
    return FutureBuilder<File>(
      future: _image,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  _buildBody(context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlineButton(
            onPressed:  _onImageButtonPressed(ImageSource.gallery, context: context),
            child: Text('Choose Image'),
          ),
          SizedBox(
            height: 20.0,
          ),
          showImage(),
          SizedBox(
            height: 20.0,
          ),
          OutlineButton(
            onPressed: startUpload,
            child: Text('Upload Image'),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

}
