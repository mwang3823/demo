import 'dart:convert';
import 'dart:io';

import 'package:demo_architecture/core/constant/app_constant.dart';
import 'package:demo_architecture/feature/login/data/datasources/local_data.dart';
import 'package:demo_architecture/feature/login/data/repository/user_repository.dart';
import 'package:demo_architecture/feature/login/domain/usecases/user_login.dart';
import 'package:demo_architecture/feature/login/presentation/bloc/user_bloc.dart';
import 'package:demo_architecture/feature/login/presentation/pages/login.dart';
import 'package:demo_architecture/feature/method_chanel.dart';
import 'package:demo_architecture/feature/statistical_feature/data/repositories/statistical_repository_impl.dart';
import 'package:demo_architecture/feature/statistical_feature/data/repositories/waterbill_repository_impl.dart';
import 'package:demo_architecture/feature/statistical_feature/domain/usecase/statistical_usecase.dart';
import 'package:demo_architecture/feature/statistical_feature/domain/usecase/warterbill_usecase.dart';
import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/statistical_bloc.dart';
import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/waterbill_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/uitls/language_notifier.dart';
import 'feature/statistical_feature/data/datasource/local_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? saveLang = pref.getString(AppConstant.localLang) ?? 'en';

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'vi', 'fr', 'ja', 'zh'],
  );
  await delegate.changeLocale(Locale(saveLang));

  LanguageNotifier langNotifier = LanguageNotifier();
  await langNotifier.loadLanguage();

  DeviceInfo.getUniqueId();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    LocalizedApp(
      delegate,
      ChangeNotifierProvider.value(
        value: langNotifier,
        child: MyApp(),
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstant.globalContext = context;
    return Consumer<LanguageNotifier>(
      builder: (context, langProvider, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserBloc(
                  loginUseCase: LoginUseCase(UserRepositoryImpl(LocalUserData()))),
            ),
            BlocProvider(
              create: (context) => StatisticalBloc(
                  getStatisticalUseCase: GetStatisticalUseCase(
                      repository: StatisticalRepositoryImpl(localData: LocalData()))),
            ),
            BlocProvider(
              create: (context) => WaterBillBloc(
                  waterBillUseCase: WaterBillUseCase(
                      repository: WaterBillRepositoryImpl(localData: LocalData()))),
            )
          ],
          child: MaterialApp(
              // key: ValueKey(langProvider.locale.languageCode),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: LocalizedApp.of(context).delegate.supportedLocales,
            locale: langProvider.locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(),
              appBarTheme: AppBarTheme(
                titleTextStyle: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  textStyle: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
            ),
            home: Login(),
          ),
        );
      },
    );
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.notification?.title}");
}