import 'dart:async';

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
  File? imageFile;
  String status = "";
  String filePath = "";


  @override
  void initState() {
    super.initState();
  }

  final appBar = appBarWidget(language.lblPayment, color: primaryColor, textColor: Colors.white, showBack: true);
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
                uploadImage(filePath, upload_url).then((value) => {
                    print(value)
                });
              },
              child: Text("Pay now", style: boldTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.center),
            ).expand()
          ],
        ),
      ).paddingAll(24),
    );
  }
  imageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        filePath = pickedFile.path;
      });
    }
  }
  // uploadFile() async {
  //   var postUri = Uri.parse("<APIUrl>");
  //   var request = new http.MultipartRequest("POST", postUri);
  //   request.fields['user'] = 'blah';
  //   request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))
  //
  //   request.send().then((response) {
  //     if (response.statusCode == 200) print("Uploaded!");
  //   });
  // }

  Future<FutureOr> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('avatar', filename));

    var res = await request.send();
    request.send().then((response) {
      if (response.statusCode == 200){
           final Map<String, dynamic> responseData = json.decode(response.stream.toString());
           return responseData;
      }
    });
    return "fail";
  }


  imageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _buildBody(context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlineButton(
            onPressed:  () {
              imageFromGallery();
            },
            child: Text('Choose Receipt'),
          ),
          SizedBox(
            height: 20.0,
          ),
          Flexible(
            child: imageFile!=null? Image.file(
              imageFile!,
              fit: BoxFit.fill,
            ):Container(color: Colors.white,)
          ),
          SizedBox(
            height: 20.0,
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
