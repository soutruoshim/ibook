import 'dart:convert';
import 'package:http/http.dart';
import 'package:ibook/main.dart';
import 'package:ibook/model/DashboardResponse.dart';
import 'package:ibook/network/NetworkUtils.dart';
import 'package:ibook/utils/constant.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import '../utils/Extensions/shared_pref.dart';

Future<List<Category>> getCategories() async {
  Iterable it = await (handleResponse(await buildHttpResponse('category.php?limit=$CATEGORY_LIMIT')));
  return it.map((e) => Category.fromJson(e)).toList();
}

Future<DashboardResponse> getDashboard() async {
  return await handleResponse(await buildHttpResponse('dashboard.php')).then((value) async {
    var res = DashboardResponse.fromJson(value);

    if (res.appconfiguration != null) {
      await setValue(TERMS_AND_CONDITION_PREF, res.appconfiguration!.termsCondition.validate());
      await setValue(PRIVACY_POLICY_PREF, res.appconfiguration!.privacyPolicy.validate());
      await setValue(CONTACT_PREF, res.appconfiguration!.contactUs.validate());
      await setValue(ABOUT_US_PREF, res.appconfiguration!.aboutUs.validate());
      await setValue(FACEBOOK, res.appconfiguration!.facebook.validate());
      await setValue(WHATSAPP, res.appconfiguration!.whatsapp.validate());
      await setValue(TWITTER, res.appconfiguration!.twitter.validate());
      await setValue(INSTAGRAM, res.appconfiguration!.instagram.validate());
      await setValue(COPYRIGHT, res.appconfiguration!.copyright.validate());
    }
    if (res.adsconfiguration != null) {
      //ad
      await setValue(ADD_TYPE, res.adsconfiguration!.adsType);
      await setValue(FACEBOOK_BANNER_PLACEMENT_ID, res.adsconfiguration!.facebookBannerId.validate());
      await setValue(FACEBOOK_INTERSTITIAL_PLACEMENT_ID, res.adsconfiguration!.facebookInterstitialId.validate());
      await setValue(FACEBOOK_BANNER_PLACEMENT_ID_IOS, res.adsconfiguration!.facebookBannerIdIos.validate());
      await setValue(FACEBOOK_INTERSTITIAL_PLACEMENT_ID_IOS, res.adsconfiguration!.facebookInterstitialIdIos.validate());

      await setValue(ADMOB_BANNER_ID, res.adsconfiguration!.admobBannerId.validate());
      await setValue(ADMOB_INTERSTITIAL_ID, res.adsconfiguration!.admobInterstitialId.validate());
      await setValue(ADMOB_BANNER_ID_IOS, res.adsconfiguration!.admobBannerIdIos.validate());
      await setValue(ADMOB_INTERSTITIAL_ID_IOS, res.adsconfiguration!.facebookInterstitialIdIos.validate());

      if (res.adsconfiguration!.interstitialAdsInterval.validate().isEmptyOrNull) {
        await setValue(INTERSTITIAL_ADS_INTERVAL, "1");
      } else {
        await setValue(INTERSTITIAL_ADS_INTERVAL, res.adsconfiguration!.interstitialAdsInterval.validate());
      }
      await setValue(BANNER_AD_BOOK_LIST, res.adsconfiguration!.bannerAdBookList.validate());
      await setValue(BANNER_AD_CATEGORY_LIST, res.adsconfiguration!.bannerAdCategoryList.validate());
      await setValue(BANNER_AD_BOOK_DETAIL, res.adsconfiguration!.bannerAdBookDetail.validate());
      await setValue(BANNER_AD_BOOK_SEARCH, res.adsconfiguration!.bannerAdBookSearch.validate());
      await setValue(INTERSTITIAL_AD_BOOK_LIST, res.adsconfiguration!.interstitialAdBookList.validate());
      await setValue(INTERSTITIAL_AD_CATEGORY_LIST, res.adsconfiguration!.interstitialAdCategoryList.validate());
      await setValue(INTERSTITIAL_AD_BOOK_DETAIL, res.adsconfiguration!.interstitialAdBookDetail.validate());
      await setValue(BANNER_AD_AUTHOR_LIST, res.adsconfiguration!.bannerAdAuthorList.validate());
      await setValue(BANNER_AD_AUTHOR_DETAIL, res.adsconfiguration!.bannerAdAuthorDetail.validate());
      await setValue(INTERSTITIAL_AD_AUTHOR_LIST, res.adsconfiguration!.interstitialAdAuthorList.validate());
      await setValue(INTERSTITIAL_AD_AUTHOR_DETAIL, res.adsconfiguration!.interstitialAdAuthorDetail.validate());
    }
    //print(res.adsconfiguration!.interstitialAdBookList.validate());
    return res;
  });
}

Future<List<Book>> getBooks({
  int? id,
  bool isFilter = false,
  Map? request,
}) async {
  Iterable it = await (handleResponse(await buildHttpResponse('book.php', request: request, method: HttpMethod.POST)));
  //print("${it}");
  return it.map((e) => Book.fromJson(e)).toList();
}

Future<List<Book>> getFilterBooks({List<String>? list, bool? isPopular = false, bool? isFeature = false, int? categoryId, bool? isCategory = false, bool? isLatest = false, int? page}) async {
  var multiPartRequest = MultipartRequest('POST', Uri.parse('$mBaseUrl${'book.php'}'));
  if (isPopular == true) {
    multiPartRequest.fields['is_popular'] = "true";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isFeature == true) {
    multiPartRequest.fields['is_featured'] = "true";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isCategory == true) {
    multiPartRequest.fields['category_id'] = "$categoryId";
    multiPartRequest.fields['page'] = page.toString();
  } else if (isLatest == true) {
    multiPartRequest.fields['order'] = "desc";
    multiPartRequest.fields['order_by'] = "id";
    multiPartRequest.fields['page'] = page.toString();
  } else {
    multiPartRequest.fields['category_ids'] = "$list";
    multiPartRequest.fields['page'] = page.toString();
  }
  multiPartRequest.headers.addAll(buildHeaderTokens());
  Response response = await Response.fromStream(await multiPartRequest.send());
  var responseJson = json.decode(response.body);
  Iterable? mCategory = responseJson;
  return mCategory!.map((e) => Book.fromJson(e)).toList();
}

Future<List<Book>> getFavourite() async {
  return wishListStore.wishList;
}

Future<List<Author>> getAuthor() async {
  Iterable it = await (handleResponse(await buildHttpResponse('author.php?limit=$AUTHOR_LIMIT', method: HttpMethod.GET)));
  return it.map((e) => Author.fromJson(e)).toList();
}

Future<List<Book>> getAuthorBook(Map? request) async {
  Iterable it = await (handleResponse(await buildHttpResponse('book.php', request: request, method: HttpMethod.POST)));
  return it.map((e) => Book.fromJson(e)).toList();
}
