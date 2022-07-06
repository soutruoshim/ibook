import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:ibook/component/AuthorComponent.dart';
import 'package:ibook/model/user.dart';
import 'package:ibook/providers/user_provider.dart';
import 'package:ibook/screen/AuthorDetailScreen.dart';
import 'package:ibook/utils/Extensions/Constants.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/Extensions/decorations.dart';
import 'package:ibook/utils/Extensions/text_styles.dart';
import 'package:provider/provider.dart';
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
  Book? book;
  static String tag = '/Payment';

  Payment(this.book);

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {

  File? imageFile;
  String status = "";
  String filePath = "";
  User? user;
  Book? book;

  @override
  void initState() {
    super.initState();
  }

  final appBar = appBarWidget(language.lblPayment, color: primaryColor, textColor: Colors.white, showBack: true);
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;
    book = widget.book??null;
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
                if(filePath == ""){
                  Flushbar(
                    title: 'Receipt',
                    message: 'Please choose receipt to upload',
                    duration: Duration(seconds: 10),
                  ).show(context);
                }else{
                  uploadImage(filePath, upload_url).then((value) => {
                    print(value)
                  });
                }
              },
              child: status=="" ?Text("Pay now", style: boldTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.center):loading,
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

  Future<FutureOr> uploadImage(filename, url) async {
      var postUri = Uri.parse(url);
      http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'avatar', filePath);
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
            Map<String, dynamic> object = json.decode(value);
            print(object['url']);


            orderBook(user!.userId, book!.id, book!.price, book!.price, object['url']).then((value) => {

            });
      });
  }

  Future<FutureOr> orderBook(String user_id, String? book_id, String? price, String? amount, String paid_doc) async {
    final Map<String, dynamic> apiBodyData = {
      'user_id': user_id,
      'book_id': book_id,
      'price': price,
      'amount': amount,
      'payment_status':'pending',
      'paid_document':paid_doc
    };

    return await post(
        Uri.parse(order_url),
        body: json.encode(apiBodyData),
        headers: <String, String>{'Content-Type':'application/json'}
    ).then((value) => {
        //print(value)
        //Navigator.pop(context)
       backToBookDetail()
    });
  }
  backToBookDetail(){
    // Flushbar(
    //   title: 'Receipt',
    //   message: 'Thank You for payment.',
    //   duration: Duration(seconds: 10),
    // ).show(context);
    setState(() {
      status = "success";
    });
    int count = 2;
    Navigator.of(context).popUntil((_) => count-- <= 0);
  }

  final loading = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      CircularProgressIndicator(),
      Text(" Uploading ... Please wait")
    ],
  );

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
