import 'package:ibook/utils/Extensions/shared_pref.dart';


const AppName = "iBook-Cambodia";

/// Note: /api/ is required after your domain. Ex if your domain is www.abc.com then ${mBaseUrl} will be  https://www.abc.com/api/
//const mBaseUrl = 'https://meetmighty.com/mobile/mighty-ebook/api/';
const mBaseUrl = 'https://ibook-cambodia.000webhostapp.com/api/';

// Facebook
const FACEBOOK_KEY = '';
const fbBannerId = "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047";
const fbBannerIdIos = "";
const fbInterstitialId = "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617";
const fbInterstitialIdIos = "";

//AdmobId
const adMobBannerId = "ca-app-pub-3940256099942544/6300978111";
const adMobInterstitialId = "ca-app-pub-3940256099942544/1033173712";
const adMobBannerIdIos = "ca-app-pub-3940256099942544/2934735716";
const adMobInterstitialIdIos = "ca-app-pub-3940256099942544/4411468910";

const mOneSignalID = '4ca75d7f-84f7-44ce-892f-48cf80d9e3f1';

const ADD_TYPE = 'ads_type';
const NONE = 'none';
const FACEBOOK_BANNER_PLACEMENT_ID = 'facebook_banner_id';
const FACEBOOK_INTERSTITIAL_PLACEMENT_ID = 'facebook_interstitial_id';
const FACEBOOK_BANNER_PLACEMENT_ID_IOS = 'facebook_banner_id_ios';
const FACEBOOK_INTERSTITIAL_PLACEMENT_ID_IOS = 'facebook_interstitial_id_ios';

const ADMOB_BANNER_ID = 'admob_banner_id';
const ADMOB_INTERSTITIAL_ID = 'admob_interstitial_id';
const ADMOB_BANNER_ID_IOS = 'admob_banner_id_ios';
const ADMOB_INTERSTITIAL_ID_IOS = 'admob_interstitial_id_ios';

const INTERSTITIAL_ADS_INTERVAL = "interstitial_ads_interval";
const BANNER_AD_BOOK_LIST = "banner_ad_book_list";
const BANNER_AD_CATEGORY_LIST = "banner_ad_category_list";
const BANNER_AD_AUTHOR_LIST = "banner_ad_author_list";
const BANNER_AD_AUTHOR_DETAIL = "banner_ad_author_detail";
const BANNER_AD_BOOK_DETAIL = "banner_ad_book_detail";
const BANNER_AD_BOOK_SEARCH = "banner_ad_book_search";
const INTERSTITIAL_AD_BOOK_LIST = "interstitial_ad_book_list";
const INTERSTITIAL_AD_CATEGORY_LIST = "interstitial_ad_category_list";
const INTERSTITIAL_AD_BOOK_DETAIL = "interstitial_ad_book_detail";
const INTERSTITIAL_AD_AUTHOR_LIST = "interstitial_ad_author_list";
const INTERSTITIAL_AD_AUTHOR_DETAIL = "interstitial_ad_author_detail";

const TERMS_AND_CONDITION_PREF = 'TermsAndConditionPref';
const PRIVACY_POLICY_PREF = 'PrivacyPolicyPref';
const CONTACT_PREF = 'ContactPref';
const ABOUT_US_PREF = 'AboutUsPref';
const FACEBOOK = 'facebook';
const WHATSAPP = 'whatsapp';
const TWITTER = 'twitter';
const INSTAGRAM = 'instagram';
const COPYRIGHT = 'copyright';
const WISHLIST_ITEM_LIST = 'WISHLIST_ITEM_LIST';
const IS_NOTIFICATION_ON = "IS_NOTIFICATION_ON";

const msg = 'message';

const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

String isGoogleAds = "admob";
String isFacebookAds = "facebook";

String adsInterval = getStringAsync(INTERSTITIAL_ADS_INTERVAL);

String mSearchBannerAds = getStringAsync(BANNER_AD_BOOK_SEARCH);
String mAuthorBannerAds = getStringAsync(BANNER_AD_AUTHOR_LIST);
String mAuthorDetailBannerAds = getStringAsync(BANNER_AD_AUTHOR_DETAIL);
String mWebBannerAds = getStringAsync(BANNER_AD_BOOK_DETAIL);
String mViewAllBannerAds = getStringAsync(BANNER_AD_BOOK_LIST);
String mCategoryViewAllBannerAds = getStringAsync(BANNER_AD_CATEGORY_LIST);

String mCategoryViewAllInterstitialAds = getStringAsync(INTERSTITIAL_AD_CATEGORY_LIST);
String mWebInterstitialAds = getStringAsync(INTERSTITIAL_AD_BOOK_DETAIL);
String mAuthorListInterstitialAds = getStringAsync(INTERSTITIAL_AD_AUTHOR_LIST);
String mAuthorDetailInterstitialAds = getStringAsync(INTERSTITIAL_AD_AUTHOR_DETAIL);
String mViewAllInterstitialAds = getStringAsync(INTERSTITIAL_AD_BOOK_LIST);

final String chooseTopicList = 'chooseTopicList';

AppThemeMode appThemeMode = AppThemeMode();

class AppThemeMode {
  final int themeModeLight = 1;
  final int themeModeDark = 2;
  final int themeModeSystem = 0;
}

const AUTHOR_LIMIT = 20;
const CATEGORY_LIMIT = 50;

class DefaultValues {
  final String defaultLanguage = "en";
}

DefaultValues defaultValues = DefaultValues();

