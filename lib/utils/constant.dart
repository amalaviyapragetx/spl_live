// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppImage {
  static const String imagePath = "assets/images/";

  static String looseBetPNG = "${imagePath}looseBetPNG.png";
  static const splashScreen = "${imagePath}splash.png";
  static const whatsaapIcon = "${imagePath}icons8-whatsapp-48.png";
  static const rupeeImage = "${imagePath}rupee-icon.svg";
  static const splLogo = '${imagePath}Spl.png';
  static const String phoneSVG = "${imagePath}phone_svg.svg";
  static String profileIconSVG = "${imagePath}profile_icon.svg";
  static String lockSVG = "${imagePath}lock_svg.svg";
  static String walletAppbar = "${imagePath}appbar_wallet_icon.svg";
  static String addFundIcon = "${imagePath}addfund_icon.svg";
  static String bidHistoryIcon = "${imagePath}bidhistory_icon.svg";
  static String bidHistoryListIcon = "${imagePath}bidhistory_list_icon.svg";
  static String homeIcon = "${imagePath}home_icon.svg";
  static String chartIcon = "${imagePath}chart_icon.svg";
  static String resultHistoryIcons = "${imagePath}result_history.svg";
  static String starLineIcon = "${imagePath}starline_icon.svg";
  static String moreIcon = "${imagePath}more_Icon.svg";
  static String marketIcon = "${imagePath}market_icon.svg";
  static String openStarsSvg = "${imagePath}open_star_svg.svg";
  static String closeStarsSvg = "${imagePath}close_star_svg.svg";
  static String bakAccount = "${imagePath}bankAccount.svg";
  static String gameRate = "${imagePath}bidhistory_list_icon.svg";
  static String notifiacation = "${imagePath}notification.svg";
  static String playIcon = "${imagePath}circle_filled_play_ic_icon.svg";
  static String plusIcon = "${imagePath}plus_circled_icon.svg";
  static String clockIcon = "${imagePath}alarm_icon.svg";
  static String withDrawalIcon = "${imagePath}wallet_sharp_icon.svg";
  static String rateusStartIcon = "${imagePath}star_rateus_icon.svg";
  static String giveFeedbackIcon = "${imagePath}give_feedback_icon.svg";
  static String infoIcon = "${imagePath}information_sharp_icon.svg";
  static String signOutIcon = "${imagePath}log out_icon.svg";
  static String serchZoomIcon = "${imagePath}search_zoom_icon.svg";
  static String profileImage = "${imagePath}myProfileImage.svg";
  static String aboutUsImage = "${imagePath}8219552_communication_support_talk_conversation_folder_icon.svg";
  static String stopWatchIcon = "${imagePath}stop_watch.svg";
  static String passBookIcon = "${imagePath}passbook_icon.svg";
  static String withDrawalPageIcon = "${imagePath}bid_History_Icon.svg";
  static String clockSvg = "${imagePath}clock.svg";
  static String withDrawalFundIcon = "${imagePath}vaadin_money-withdraw.svg";
  static String addFundIconInWallet = "${imagePath}majesticons_rupee-circle-line.svg";
}

class AppColor {
  static Color redColor = Colors.red;
  static Color white = Colors.white;
  static Color grey = Colors.grey;
  static Color black = Colors.black;
  static Color blueAccent = Colors.blueAccent;
  static Color appbarColor = const Color(0xFF2A5AAD);
  static Color blueButton = const Color.fromARGB(255, 42, 90, 173);
  static Color buttonColorDarkGreen = const Color.fromARGB(255, 23, 123, 25);
  static Color buttonColorOrange = const Color.fromARGB(255, 254, 69, 2);
  static Color green = Colors.green;
  static Color transparent = Colors.transparent;
  static Color greenShade = Colors.green.shade800;
  static Color greyShade = Colors.grey.shade600;
  static Color greywhite = const Color.fromARGB(255, 201, 198, 198);
  static Color greenAccent = const Color(0xFFB2FF89);
  static Color balanceCoinsColor = const Color(0xFFb47e25);
  static Color iconColorMain = const Color(0xff0b0b0b);
  static Color numberListContainer = const Color(0xff9b8083);
  static Color numberListgreen = const Color(0xFF2AF330);
  static Color wpColor1 = const Color(0xffFFA71E);
  static Color wpColor2 = const Color(0xffD82700);
  static Color textFieldFillColor = const Color(0xffF1F1F1);
  static Color openclose = const Color(0xffE8E8E8);
  static Color withDrawalSvgColor = const Color(0xFF377dd2);
  static Color statusCode = fromHex("25D366");
  static Color borderColor = const Color(0xFFDDDDDD);
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class EndPoints {
  EndPoints._();
  // Spl Production
  // static String baseUrl = "https://vishnulive.in:9869";

  // // local url
  static String baseUrl = "http://192.168.29.143:8080";
  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;
  // endpoints
  static String signUP = '$baseUrl/auth/signup';
  static String signIN = '$baseUrl/auth/signin';
  static String verifyUSER = '$baseUrl/auth/verifyUser';
  static String verifyOTP = '$baseUrl/auth/verifyOtp';
  static String resendOTP = '$baseUrl/auth/resendOtp';
  static String forgotPassword = '$baseUrl/auth/forgotPassword';
  static String logout = '$baseUrl/auth/logout';
  static String resetPassword = '$baseUrl/auth/resetPassword';
  static String changePassword = '$baseUrl/auth/changePassword';
  static String getBankDetails = '$baseUrl/bank/getByUserId';
  static String editBankDetails = '$baseUrl/bank/createOrUpdate';
  static String getDailyMarkets = '$baseUrl/market/getDailyMarket';
  static String getGameModes = '$baseUrl/market/getGameModeForMarket/';
  static String getStarLineGameModes = '$baseUrl/starline/getGameModeForStarlineMarket/';
  static String createMarketBid = '$baseUrl/bid/marketBidcreate';
  static String createStarLineMarketBid = '$baseUrl/bid/starlineBidCreate';
  static String getDailyStarLineMarkets = '$baseUrl/starline/getDailyStarlineMarket';
  static String createWithdrawalRequest = '$baseUrl/withdraw/createRequest';
  static String getWithdrawalHistoryByUserId = '$baseUrl/withdraw/getRequestByUserId/';
  static String getStarlineGameRates = '$baseUrl/game/getAll/';
  static String createFeedback = '$baseUrl/feedback/create';
  static String getFeedbackAndRatingsById = '$baseUrl/feedback/getById/';
  static String getTransactionHistory = '$baseUrl/bid/getByUserId';
  static String verifyMPIN = '$baseUrl/auth/mPin/verify';
  static String forgotMPIN = '$baseUrl/auth/mPin/forgot';
  // new api endpoints
  static String setUserDetails = '$baseUrl/auth/setUserDetails';
  static String setDeviceDetails = '$baseUrl/auth/setDeviceDetails';
  static String setMPIN = '$baseUrl/auth/mPin/set';
  static String getBalance = '$baseUrl/wallet/getBalance';
  static String normalMarketBidHistory = '$baseUrl/bid/getByUserId';
  static String starlineMarketBidHistory = '$baseUrl/bid/starline/getByUserId';
  static String changeMPIN = "$baseUrl/auth/mPin/change";
  static String webStarLinechar = "$baseUrl/web/starlineChart";
  static String dailyStarlineMarketBidHistory = "$baseUrl/bid/getAllBidByDailyStarlineMarketId";
  static String spdptp = "$baseUrl/gameMode/getSPDPTPPana";
  static String panelGroup = "$baseUrl/gameMode/getPanelGroupPana";
  static String spMotor = "$baseUrl/gameMode/getSPMotorPana";
  static String dpMotor = "$baseUrl/gameMode/getDPMotorPana";
  static String towDigitJodi = "$baseUrl/gameMode/getTwoDigitPanelPana";
  static String groupJody = "$baseUrl/gameMode/groupJodi";
  static String choicePanaSPDP = "$baseUrl/gameMode/getChoicePanaSPDPTP";
  static String digitsBasedJodi = "$baseUrl/gameMode/digitBasedJodi";
  static String passBookApi = "$baseUrl/user/getUserPassbookDetails";
  // static String marketbidHistory = "$baseUrl/bid/getBidHistory";
  static String bidHistory = "$baseUrl/bid/getByUserId";
  static String marketBidNewLists = "$baseUrl/bid/getBidHistoryByBidType";
  static String getNotificationCount = "$baseUrl/notification/getNotificationCount";
  static String getAllNotifications = "$baseUrl/notification/getAll?search=&limit=10&offset=0";
  static String resetNotificationCount = "$baseUrl/notification/resetCount";

  /// new Rating Api
  static String rateAppApi = "$baseUrl/feedback/createRating";

  // Notifiaction Api
  static String marketNotification = "$baseUrl/notification/updateNotificationStatus";
  static String bennerApi = "$baseUrl/banner/getAll";
  static String fcmToken = "$baseUrl/auth/setFCMToken";
  static String getVersion = "$baseUrl/auth/appVersion";
  static String appKillApi = "$baseUrl/user/log/out";
}

class AppRouteNames {
  AppRouteNames._();

  static const splashScreen = "/splash_screen";
  static const welcomeScreen = "/walcome_screen";
  static const dashboardPage = "/dashboard_page";
  static const transactionPage = "/transaction_page";
  static const notificationPage = "/notification_page";
  static const gameModePage = "/game_mode_page";
  static const signInPage = "/sign_in_page";
  static const signUnPage = "/sign_up_page";
  static String verifyOTPPage = '/verify_otp_page';
  static String userDetailsPage = "/user_details_page";
  static String setMPINPage = '/set_mpin_page';
  static String mPINPage = '/mpin_page';
  static String forgotPasswordPage = '/forgot_password_page';
  static String resetPasswordPage = '/reset_password_page';
  static String profilePage = "/profile_page";
  static String singleAnkPage = "/game_pages";
  static String sangamPages = "/sangam_pages";
  static String selectedBidsPage = '/selected_bids_page';

  /// StarLine Game Modes Page
  static String starLineGameModesPage = '/starline_game_modes_page';

  /// StarLine Game Page

  static String starLineGamePage = '/starline_game_page';

  // More Details Pages
  static String myAccountPage = '/my_account_page';

  /// Game Rate Page
  static String gameRatePage = '/game_rate_page';

  /// NotificationDetails Page
  static String notificationDetailsPage = '/notification_details_page';

  /// withDrawal Page
  static String withdrawalpage = '/withdrawal_page';

  /// withDrawal Page
  static String feedBackPage = '/feedback_page';

  /// withDrawal Page
  static String stalineTerms = '/starline_terms_pages';

  /// About Us Page
  static String aboutPage = "/about_page";

  /// Change Password Page
  static String changePassPage = "/change_password";

  /// Change Mpin Page
  static String changeMpinPage = "/change_mpin";

  /// CreateWithDrawal Req Page
  static String createWithDrawalPage = "/create_withdrawal_page";

  /// CheckWithDrawal History Page
  static String checkWithDrawalPage = "/check_withdrawal_page";

  /// NormalMarketPage
  static String normalMarketPage = "/normal_market_page";

  /// NewGamemodePage
  static String newGameModePage = "/new_gamemode_page";

  /// oddEvenGamePage
  static String newOddEvenPage = "/new_game_page_odd_even";

  /// starlineBidPage
  static String starlineBidpage = "/starline_bid_page";

  /// starlineBidPage
  static String newStarlineGames = "/new_starline_games";

  /// newBidHistorypage
  static String newBidHistorypage = "/bid_history_page_new";
}

class UserDetails {
  String? userName;
  String? fullName;
  String? password;

  UserDetails({this.userName, this.fullName, this.password});
}

class ConstantsVariables {
  static const String userData = "user_data";
  static const String bidsList = "bids_list";
  static const String starlineBidsList = "starline_bid_list";
  static const String biddingType = "bidding_type";
  static const String marketName = "market_name";
  static const String isActive = "is_active";
  static const String isVerified = "is_verified";
  static const String isMpinSet = "is_mpin_set";
  static const String isUserDetailSet = "is_user_detail_set";
  static const String userPhN = "user_phone";
  static const String userName = "user_name";
  static const String id = "id";

  //api variables
  static const String authToken = "auth_token";

  //localization variables
  static const String languageName = "language_name";
  static const String localeEnglish = "locale_english";
  static const String localeHindi = "locale_hindi";

  /// arguments constants
  static const String phoneNumber = "phone_number";
  static const String countryCode = "country_code";

  // change Screens
  // static const String boolData = "bool_data";

  // change Screens
  static const String playMore = "play_data";
  static const String withDrawal = "withdrawal";
  static const String bidType = "bid_type";

  // set total Ammount and market name for playMore
  static const String totalAmount = "total_ammount";
  static const String timeOut = "time_out";

  //Notification

  static const String marketNotification = "market_notification";
  static const String starlineNotification = "starline_notification";

  /// fcm Token
  static const String fcmToken = "fcm_token";

  /// on back starLine
  static const String starlineConnect = "starline_connect";

  // locationData
  static const String locationData = "location_data";
  static const String mPinTimeOut = "m_pin_time_out";
}
