import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_mvvm/app/di.dart';
import 'package:ecommerce_mvvm/presentation/forgot_password/forgot_password_view.dart';
import 'package:ecommerce_mvvm/presentation/login/view/login_view.dart';
import 'package:ecommerce_mvvm/presentation/main/main_view.dart';
import 'package:ecommerce_mvvm/presentation/onboarding/view/onboarding_view.dart';
import 'package:ecommerce_mvvm/presentation/register/view/register_view.dart';
import 'package:ecommerce_mvvm/presentation/resources/strings_manager.dart';
import 'package:ecommerce_mvvm/presentation/splash/splash_view.dart';
import 'package:ecommerce_mvvm/presentation/store_details/store_details_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPassword = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String onBoardingRoute = "/onBoarding";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound.tr()),
        ),
        body: Center(
          child: Text(AppStrings.noRouteFound.tr()),
        ),
      ),
    );
  }
}
