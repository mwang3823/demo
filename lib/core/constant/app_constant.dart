import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppConstant{
  static BuildContext? appContext;
  static late BuildContext globalContext;

  static final Color textColor =Color.fromRGBO(24, 74, 180, 1);

  //background
  static final String backgroundWaterBill='assets/background/backround_waterbill.png';
  static final String backgroundIcon='assets/icon/backround_icon.png';
  static final String backgroundLogin='assets/background/background.jpg';

  //icon
  static final String iconLock='assets/icon/lock.png';
  static final String iconUserLogin='assets/icon/users.png';

  //logo
  static final String logoApp='assets/icon/icon.png';

  //shared preferences
  static final String localLang='local_lang';

}