import 'package:get/get.dart';
import 'package:spllive/screens/More%20Details%20Screens/About%20Page/about_page.dart';
import 'package:spllive/screens/More%20Details%20Screens/Change%20Mpin/binding/change_mpin_page_binding.dart';
import 'package:spllive/screens/More%20Details%20Screens/Notification%20Page/binding/notification_details_page_binding.dart';
import 'package:spllive/screens/More%20Details%20Screens/myProfile/binding/myprofile_page_binding.dart';
import 'package:spllive/screens/More%20Details%20Screens/myProfile/myprofile_page.dart';
import 'package:spllive/screens/New%20GameModes/binding/new_gamemode_page_bindings.dart';
import 'package:spllive/screens/New%20GameModes/new_gamemodes_page.dart';
import 'package:spllive/screens/Sangam%20Page/binding/snagam_page_binding.dart';
import 'package:spllive/screens/Starline%20Bid%20Page/bidings/starline_bids_bidings.dart';
import 'package:spllive/screens/authentication/set_mpin_page.dart';
import 'package:spllive/screens/authentication/sign_in_screen_page.dart';
import 'package:spllive/screens/game_pages/game_pages.dart';
import 'package:spllive/screens/gamemode_pages/gamemode_page.dart';
import 'package:spllive/screens/home_screen/dashboard_screen.dart';
import 'package:spllive/screens/sign_up_screen/bindings/sing_up_screen_bindings.dart';
import 'package:spllive/screens/sign_up_screen/sign_up_screen.dart';
import 'package:spllive/screens/slash_screen/bindings/splash_screen_bindings.dart';
import 'package:spllive/screens/slash_screen/splash_screen.dart';
import 'package:spllive/utils/constant.dart';

import '../screens/Forgot Password/binding/forgot_password_page_binding.dart';
import '../screens/Forgot Password/forgot_password_page.dart';
import '../screens/More Details Screens/About Page/binding/about_page_biding.dart';
import '../screens/More Details Screens/Change Mpin/change_mpin_page.dart';
import '../screens/More Details Screens/Change Password/bidding/change_password_bidings.dart';
import '../screens/More Details Screens/Change Password/change_password.dart';
import '../screens/More Details Screens/Check Withdrawal History/binding/check_withdrawal_history_binding.dart';
import '../screens/More Details Screens/Check Withdrawal History/check_withdrawal_history.dart';
import '../screens/More Details Screens/Create Withdrawal Page/binding/create_withdrawal_page_bidings.dart';
import '../screens/More Details Screens/Create Withdrawal Page/create_withdrawal_page.dart';
import '../screens/More Details Screens/Game Rate Page/binding/game_rate_page_binding.dart';
import '../screens/More Details Screens/Game Rate Page/game_rate_page.dart';
import '../screens/More Details Screens/Give Feedback Page/binding/give_feedback_page_binding.dart';
import '../screens/More Details Screens/Give Feedback Page/give_feedback_page.dart';
import '../screens/More Details Screens/My Account Page/binding/myaccount_page_bindings.dart';
import '../screens/More Details Screens/My Account Page/myaccount_page.dart';
import '../screens/More Details Screens/Notification Page/notification_details.dart';
import '../screens/More Details Screens/Starline Terms Page/binding/starline_terms_page_binding.dart';
import '../screens/More Details Screens/Starline Terms Page/starline_terms_page.dart';
import '../screens/More Details Screens/Withdrawal Page/binding/withdrawal_page_binding.dart';
import '../screens/More Details Screens/Withdrawal Page/withdrawal_page.dart';
import '../screens/Normal Game Pages/binding/normal_game_page_controller.dart';
import '../screens/Normal Game Pages/normal_game_pages.dart';
import '../screens/Notification MSG Page/bindings/notification_binding.dart';
import '../screens/Notification MSG Page/notification.dart';
import '../screens/Reset Password Page/binding/reset_password_binding.dart';
import '../screens/Reset Password Page/reset_password.dart';
import '../screens/Sangam Page/sangampages.dart';
import '../screens/Select Bid Page/binding/selectbid_page_bindings.dart';
import '../screens/Select Bid Page/selectbid_page.dart';
import '../screens/StarLine Game Mode Page/binding/starline_game_modes_page_binding.dart';
import '../screens/StarLine Game Mode Page/starline_game_modes_page.dart';
import '../screens/Starline Bid Page/starline_bids.dart';
import '../screens/Starline Game Page/binding/starline_game_page_binding.dart';
import '../screens/Starline Game Page/starline_game_page.dart';
import '../screens/Starline New Game Page/bindings/starline_new_game_page_binding.dart';
import '../screens/Starline New Game Page/starline_new_game_page.dart';
import '../screens/User Details Page/binding/user_details_page_binding.dart';
import '../screens/Verify OTP Page/binding/verify_otp_binding.dart';
import '../screens/Verify OTP Page/verify_otp.dart';
import '../screens/authentication/mpin_page_view.dart';
import '../screens/authentication/user_details_page.dart';
import '../screens/game_pages/bindings/game_mode_page_binding.dart';
import '../screens/gamemode_pages/bindings/game_mode_page_binding.dart';
import '../screens/home_screen/binding/home_screen_binding.dart';
import '../screens/transaction_page/binding/transaction_page_binding.dart';
import '../screens/transaction_page/transaction.dart';
import '../screens/welcome_screen/bindings/welcome_screen_bindings.dart';
import '../screens/welcome_screen/welcome_screen.dart';

class AppRoutes {
  var appRoutName = AppRouteNames;
  static List<GetPage> pages = [
    GetPage(
      name: AppRouteNames.splashScreen,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SplashScreen(),
      bindings: [SplashScreenBinding()],
    ),
    GetPage(
      name: AppRouteNames.welcomeScreen,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => WelcomeScreen(),
      bindings: [WelcomeScreenBinding()],
    ),
    GetPage(
      name: AppRouteNames.dashboardPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => DashBoardPage(),
      bindings: [HomePageBindings()],
    ),
    GetPage(
      name: AppRouteNames.transactionPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => TransactionPage(),
      bindings: [
        TransactionPageBindings(),
      ],
    ),
    GetPage(
      name: AppRouteNames.notificationPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => NotificationPage(),
      bindings: [
        NotificationBinding(),
      ],
    ),
    GetPage(
      name: AppRouteNames.gameModePage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => GameModePage(),
      bindings: [
        GameModepageBinding(),
      ],
    ),

    GetPage(
      name: AppRouteNames.signInPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SignInScreen(),
    ),
    GetPage(
      name: AppRouteNames.signUnPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SignUpScreen(),
      bindings: [SignUpPageBinding()],
    ),

    /// verifyOTPPage
    GetPage(
      name: AppRouteNames.verifyOTPPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => VerifyOTPPage(),
      bindings: [
        VerifyOTPBinding(),
      ],
    ),

    /// UserDetailsPage
    GetPage(
      name: AppRouteNames.userDetailsPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => UserDetailsPage(),
      bindings: [
        UserDetailsPageBinding(),
      ],
    ),

    /// SetMPINPage
    GetPage(
      name: AppRouteNames.setMPINPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => const SetMPINPage(),
    ),

    // MPINPage
    GetPage(
      name: AppRouteNames.mPINPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => MPINPageView(),
    ),
    GetPage(
      name: AppRouteNames.forgotPasswordPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ForgotPasswordPage(),
      bindings: [
        ForgotPasswordPageBindings(),
      ],
    ),

    /// Reset Password Page
    GetPage(
      name: AppRouteNames.resetPasswordPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ResetPasswordPage(),
      bindings: [
        ResetPasswordBinding(),
      ],
    ),

    // profile page
    GetPage(
      name: AppRouteNames.profilePage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ProfilePage(),
      bindings: [
        MyProfilePageBindings(),
      ],
    ),

    // game page's
    GetPage(
      name: AppRouteNames.singleAnkPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SingleAnkPage(),
      bindings: [
        GamepageBinding(),
      ],
    ),

    /// SelectedBidsPage
    GetPage(
      name: AppRouteNames.selectedBidsPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SelectedBidsPage(),
      bindings: [
        SelecteBidPageBinding(),
      ],
    ),

    /// SelectedBidsPage
    GetPage(
      name: AppRouteNames.sangamPages,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => SangamPages(),
      bindings: [
        SangamPageBindings(),
      ],
    ),

    /// starLineGameModesPage
    GetPage(
      name: AppRouteNames.starLineGameModesPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => StarLineGameModesPage(),
      bindings: [
        StarLineGameModesPageBindings(),
      ],
    ),

    /// starLineGamePage
    GetPage(
      name: AppRouteNames.starLineGamePage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => StarLineGamePage(),
      bindings: [
        StarLineGamePageBinding(),
      ],
    ),

    /// MyAccountPage
    GetPage(
      name: AppRouteNames.myAccountPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => MyAccountPage(),
      bindings: [
        MyAccountPageBinding(),
      ],
    ),

    /// gameRatePage
    GetPage(
      name: AppRouteNames.gameRatePage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => GameRatePage(),
      bindings: [
        GameRatePageBinding(),
      ],
    ),

    /// notificationDetailspage
    GetPage(
      name: AppRouteNames.notificationDetailsPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => NotificationDetailsPage(),
      bindings: [
        NotificationDetailsPageBindings(),
      ],
    ),

    /// withdrawal Page
    GetPage(
      name: AppRouteNames.withdrawalpage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => WithdrawalPage(),
      bindings: [
        WithdrawalPageBindings(),
      ],
    ),

    /// withdrawal Page
    GetPage(
      name: AppRouteNames.feedBackPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => GiveFeedbackPage(),
      bindings: [
        GiveFeedbackPageBinding(),
      ],
    ),
    GetPage(
      name: AppRouteNames.stalineTerms,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => StarlineTermsPage(),
      bindings: [
        StarlineTermsPageBindig(),
      ],
    ),
    //// About Us Page
    GetPage(
      name: AppRouteNames.aboutPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => AboutUsPage(),
      bindings: [AboutUsPageBiding()],
    ),
    GetPage(
      name: AppRouteNames.changePassPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ChangePasswordPage(),
      bindings: [ChangePasswordPageBidings()],
    ),

    //// Change Mpin Page
    GetPage(
      name: AppRouteNames.changeMpinPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => ChangeMpinPage(),
      bindings: [ChangeMpinPageBinding()],
    ),

    /// create WithDrawal Req Page
    GetPage(
      name: AppRouteNames.createWithDrawalPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => CreatewithDrawalPage(),
      bindings: [CreateWithDrawalPageBiding()],
    ),
    GetPage(
      name: AppRouteNames.checkWithDrawalPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => CheckWithdrawalPage(),
      bindings: [CheckWithdrawalPageBinding()],
    ),
    // GetPage(
    //   name: AppRouteNames.normalMarketPage,
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 300),
    //   page: () => NormalMarketPage(),
    //   bindings: [NormalMarketPageBinding()],
    // ),
    GetPage(
      name: AppRouteNames.newGameModePage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => NewGameModePage(),
      bindings: [NewGamemodePageBindings()],
    ),
    GetPage(
      name: AppRouteNames.newOddEvenPage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => NormalGamePage(),
      bindings: [NormalGamePageBindings()],
    ),
    GetPage(
      name: AppRouteNames.starlineBidpage,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => StarlineBidsPage(),
      bindings: [StarlineBidsBidings()],
    ),
    GetPage(
      name: AppRouteNames.newStarlineGames,
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      page: () => StarLineNewGamePage(),
      bindings: [StarlineNewGamePageBinding()],
    ),
    // GetPage(
    //   name: AppRouteNames.newBidHistorypage,
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 300),
    //   page: () => BidHistoryDetailsNewPage(),
    //   bindings: [BidHistoryPageDetailsBinding()],
    // )
  ];
}
