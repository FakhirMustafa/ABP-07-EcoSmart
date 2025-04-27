import 'package:flutter/material.dart';
import 'package:tubes_abp/pages/about.dart';
import 'package:tubes_abp/pages/camera.dart';
import 'package:tubes_abp/pages/dashboard.dart';
import 'package:tubes_abp/pages/history.dart';
import 'package:tubes_abp/pages/home.dart';
import 'package:tubes_abp/pages/login.dart';
import 'package:tubes_abp/pages/profile.dart';
import 'package:tubes_abp/pages/register.dart';
import 'package:tubes_abp/pages/result.dart';
import 'package:tubes_abp/pages/uploadimagepage.dart';
import 'package:tubes_abp/pages/setting.dart';
import 'package:tubes_abp/pages/editprofile.dart';


MaterialPageRoute _pageRoute({required Widget body, required RouteSettings settings}) =>
    MaterialPageRoute(builder: (_) => body, settings: settings);

Route<dynamic>? generateRoute(RouteSettings settings) {
  Route<dynamic>? _route;
  final _args = settings.arguments;

  switch (settings.name) {
    case rLogin:
      _route = _pageRoute(body: SignIn(), settings: settings);
      break;
    case rRegister:
      _route = _pageRoute(body: SignUp(), settings: settings);
      break;
    case rHome:
      _route = _pageRoute(body: Home(), settings: settings);
      break;
    case rDashboard:
      _route = _pageRoute(body: Dashboard(), settings: settings);
      break;
    case rProfile:
      _route = _pageRoute(body: Profile(), settings: settings);
      break;
    case rCamera:
      _route = _pageRoute(body: Camera(), settings: settings);
      break;
    case rAbout:
      _route = _pageRoute(body: About(), settings: settings);
      break;
    case rResult:
      _route = _pageRoute(body: Result(), settings: settings);
      break;
    case rUploadImage:
      _route = _pageRoute(body: UploadImagePage(), settings: settings);
      break;
    case rHistory:
      _route = _pageRoute(body: History(), settings: settings);
      break;
    case rSetting:
      _route = _pageRoute(body: Setting(), settings: settings);
      break;
    case rEditProfile:
      _route = _pageRoute(body: EditProfile(), settings: settings);
      break;
  }
  return _route ?? MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Center(
        child: Text('404 Page Not Found'),
      ),
    ),
    settings: settings,
  );
}

final NAV_KEY = GlobalKey<NavigatorState>();

const String rLogin = '/login';
const String rRegister = '/register';
const String rHome = '/home';
const String rDashboard = '/dashboard';
const String rProfile = '/profile';
const String rCamera = '/camera';
const String rAbout = '/about';
const String rResult = '/result';
const String rUploadImage = '/upload_image';
const String rHistory = '/history';
const String rSetting = '/setting';
const String rEditProfile = '/editprofile';
