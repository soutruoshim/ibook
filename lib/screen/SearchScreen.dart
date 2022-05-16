import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ibook/component/ItemWidget.dart';
import 'package:ibook/model/DashboardResponse.dart';
import 'package:ibook/network/RestApis.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/appWidget.dart';
import '../main.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import 'BookDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCont = TextEditingController();
  List<Book> mBookList = [];
  List<Book> mSearchList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    loadBooks();
  }

  void loadBooks() {
    appStore.setLoading(true);
    var request = {};
    getBooks(request: request).then((value) {
      appStore.setLoading(false);
      setState(() {
        mBookList.addAll(value);
        mSearchList = mBookList;
      });
    }).catchError((e) {
      appStore.setLoading(false);
      log(e);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", color: primaryColor, textColor: Colors.white, showBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            autoFocus: true,
            textFieldType: TextFieldType.OTHER,
            decoration: inputDecoration(context, label: language.lblSearchBook, prefixIcon: Icon(Ionicons.search_outline)),
            controller: searchCont,
            onChanged: (v) async {
              setState(() {
                mSearchList = mBookList.where((u) => (u.name!.toLowerCase().contains(v.toLowerCase()) || u.name!.toLowerCase().contains(v.toLowerCase()))).toList();
              });
            },
            onFieldSubmitted: (c) {
              loadBooks();
              setState(() {});
            },
          ).paddingAll(16),
          mSearchList.isEmpty && !appStore.isLoading
              ? noDataWidget(context).center()
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: mSearchList.length,
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  itemBuilder: (_, i) {
                    return ItemWidget(
                      mSearchList[i],
                      onTap: () async {
                        BookDetailScreen(data: mSearchList[i]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    );
                  },
                ).expand(),
          mProgress().center().visible(appStore.isLoading)
        ],
      ),
      bottomNavigationBar: mSearchBannerAds == '1' ? showBannerAds() : SizedBox(),
    );
  }
}
