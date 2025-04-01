import 'package:demo_architecture/core/constant/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LanguageNotifier extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedLang = pref.getString(AppConstant.localLang);
    if (savedLang != null) {
      _locale = Locale(savedLang);
    }
    notifyListeners();
  }

  void changeLanguage(String langCode) async {
    _locale = Locale(langCode);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(AppConstant.localLang, langCode);

    var delegate = LocalizedApp.of(AppConstant.globalContext).delegate;
    await delegate.changeLocale(_locale);

    notifyListeners();
  }

}
