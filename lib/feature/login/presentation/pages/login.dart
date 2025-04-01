import 'dart:async';
import 'dart:math';
import 'package:demo_architecture/core/constant/app_constant.dart';
import 'package:demo_architecture/feature/login/presentation/bloc/user_bloc.dart';
import 'package:demo_architecture/feature/login/presentation/bloc/user_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/size_config.dart';
import '../../../../core/uitls/language_notifier.dart';
import '../../../statistical_feature/presentation/pages/chart_screen.dart';
import '../bloc/user_event.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _slideBodyController;

  late Animation<double> _slideBodyAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  bool hasErrorTextField = false;

  String _selectedLang = 'en';
  Map<String, String> languages = {
    "en": "English",
    "vi": "Tiếng Việt",
    "fr": "Français",
    "ja": "日本語",
    "zh": "中文"
  };

  @override
  initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideBodyController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _slideBodyAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _slideBodyController, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(begin: 2, end: 1.5).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -3),
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    _scaleController.forward().then((_) {
      Future.delayed(Duration(seconds: 1), () {
        _slideController.forward();

        Future.delayed(Duration(milliseconds: 250), () {
          _slideBodyController.forward();
        });
      });
    });

// Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.notification?.body ?? "No body")),
      );
    });

    // Khi người dùng nhấn vào thông báo (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened app from notification: ${message.notification?.title}");
    });


  }
  void getToken() async {
    //du_VhDakTOmog1se6I1Q9B:APA91bFyZlvm1dv5fcFEpLiylJaTwzPH8HI8am1PbsYU2rTGFPapsaRFjHx_H8ZJsyqfbPEsc4W5PCDG-rhSzyCh4C8aGc5lDMiAh3o9APFI8AjmiLQivT0
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }
  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageNotifier>(context);
    SizeConfig.init(context);
    final width = SizeConfig.screenWidth;
    final height = SizeConfig.screenHeight;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            DropdownButton<String>(
              items: languages.entries.map((e) {
                return DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLang=value;
                  });
                  langProvider.changeLanguage(value);
                }
              },
              value: langProvider.locale.languageCode,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: BlocListener<UserBloc, UserState>(

          listener: (context, state) {
            if (state is UserError) {
              hasErrorTextField = !hasErrorTextField;
            } else if (state is UserSuccess) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChartScreen(),
                  ));
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppConstant.backgroundLogin,
                fit: BoxFit.cover,
              ),
              Stack(
                fit: StackFit.passthrough,
                children: [
                  // ElevatedButton(onPressed: () => getToken(), child: Text('aaaaaaaaaaaaa')),
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.center,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Image.asset(
                              AppConstant.logoApp,
                              width: height * 0.1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    top: height * 0.3,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _slideBodyController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _slideBodyAnimation.value,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 700),
                              child:
                          Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    translate('login_screen.name_app'),
                                    // 'Công ty Cổ Phần Cấp Nước Nhà Bè',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: min(SizeConfig.textSize(4), 30),
                                    ),
                                  ),
                                  Spacer(),
                                  _bottomWidget(
                                    function: (p0, p1) async {

                                        // await getToken();
                                      context.read<UserBloc>().add(
                                          LoginEvent(email: p0, password: p1));
                                    },
                                    width: width,
                                    height: height,
                                    hasError: hasErrorTextField,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class _bottomWidget extends StatefulWidget {
  final Function(String, String) function;
  final double width;
  final double height;
  final bool hasError;

  const _bottomWidget(
      {super.key,
      required this.hasError,
      required this.function,
      required this.width,
      required this.height});

  @override
  State<_bottomWidget> createState() => _bottomWidgetState();
}

class _bottomWidgetState extends State<_bottomWidget> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final StreamController<bool> _streamController = StreamController();

  void _checkInput() {
    final hasData = _userName.text.isNotEmpty && _password.text.isNotEmpty;
    _streamController.add(hasData);
  }

  @override
  void initState() {
    super.initState();
    _userName.addListener(_checkInput);
    _password.addListener(_checkInput);
  }

  @override
  void dispose() {
    super.dispose();
    _userName.removeListener(_checkInput);
    _password.removeListener(_checkInput);
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height * 0.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                // 'Ứng dụng nhân viên',\
                translate('login_screen.role_app'),
                style: TextStyle(
                    color: Color.fromRGBO(24, 74, 180, 1),
                    fontSize: min(SizeConfig.textSize(4), 30),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                return _customTextField(
                  controller: _userName,
                  labelText: translate('login_screen.user_name'),
                  // 'Tên người dùng',
                  icon: AppConstant.iconUserLogin,
                  isObscure: false,
                  hasError: snapshot.data ?? false,
                  onPress: () {
                    setState(() {
                      _userName.text = '';
                      _password.text = '';
                    });
                  },
                );
              },
            ),
            _customTextField(
              controller: _password,
              labelText: translate('login_screen.password'),
              //'Mật khẩu',
              icon: AppConstant.iconLock,
              isObscure: true,
              hasError: widget.hasError,
              onPress: () {
                setState(() {
                  _userName.text = '';
                  _password.text = '';
                });
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: AppConstant.textColor,
                      minimumSize: Size(widget.width, 50)),
                  onPressed: () =>
                      widget.function(_userName.text, _password.text),

                  child: Text(
                    // 'Đăng nhập',
                    translate('login_screen.login'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: min(SizeConfig.textSize(4), 30),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class _customTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String icon;
  final bool isObscure;
  final bool hasError;
  final VoidCallback onPress;

  const _customTextField(
      {super.key,
      required this.onPress,
      required this.controller,
      required this.labelText,
      required this.icon,
      required this.isObscure,
      required this.hasError});

  @override
  State<_customTextField> createState() => _customTextFieldState();
}

class _customTextFieldState extends State<_customTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocus = false;
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    if (widget.isObscure) {
      setState(() {
        obscure = true;
      });
    }
    _focusNode.addListener(
      () {
        setState(() {
          _isFocus = _focusNode.hasFocus;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: obscure,
      decoration: InputDecoration(
          prefixIcon: ImageIcon(
            AssetImage(widget.icon),
            color: _isFocus ? AppConstant.textColor : Colors.grey,
            size: min(SizeConfig.textSize(7),30),
          ),
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppConstant.textColor)),
          labelText: widget.labelText,
          labelStyle: _isFocus
              ? TextStyle(
                  color: AppConstant.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: min(SizeConfig.textSize(3), 30),
                )
              : TextStyle(
                  color: Colors.grey,
                  fontSize: min(SizeConfig.textSize(3), 30)),
          suffixIcon: widget.isObscure
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: obscure
                      ? Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.grey,
                    size: min(SizeConfig.textSize(7),30),
                        )
                      : Icon(
                          Icons.remove_red_eye_rounded,
                          color: AppConstant.textColor,
                    size: min(SizeConfig.textSize(7),30),
                        ))
              : Visibility(
                  visible: widget.hasError,
                  child: GestureDetector(
                    onTap: widget.onPress,
                    child: Text(
                      translate('login_screen.clear'),
                      // 'Nhập lại',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: min(SizeConfig.textSize(3), 30)),
                    ),
                  ))),
    );
  }
}
