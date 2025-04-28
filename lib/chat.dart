import 'dart:async';
import 'dart:io';
import 'package:chat/chat_screen/home_screen.dart';
import 'package:chat/connection/chat_connection.dart';
import 'package:chat/connection/http_connection.dart';
import 'package:chat/data_model/chat_message.dart';
import 'package:chat/data_model/response/room_info_response_model.dart';
import 'package:chat/localization/app_localizations.dart';
import 'package:chat/localization/lang_key.dart';
import 'package:chat/presentation/chat_module/ui/chat_screen.dart';
import 'package:chat/presentation/utils/media_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

import 'data_model/room.dart' as r;

class Chat {
  static const MethodChannel _channel = MethodChannel('chat');
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> chatToken(
      String email, String password, String domain) async {
    HTTPConnection.domain = domain;
    return await ChatConnection.token(email, password);
  }

  static Future<bool> connectSocket(
      BuildContext context, String email, String password, String appIcon,
      {String? domain, String? token}) async {
    ChatConnection.buildContext = context;
    ChatConnection.appIcon = appIcon;
    bool result = await ChatConnection.init(email, password, token: token);
    return result;
  }

  static disconnectSocket() {
    ChatConnection.dispose(isDispose: true);
  }

  static Future<bool> open(
    String? userId,
    BuildContext context,
    String email,
    String password,
    String appIcon,
    Locale locale, {
    String? domain,
    String? token,
    String? brandCode,
    bool isChatHub = false,
    String? phoneNumber,
    Map<String, dynamic>? notificationData,
    List<Map<String, dynamic>>? addOnModules,
    Function? searchProducts,
    Function? searchOrders,
    Function? createOrder,
    Function? createAppointment,
    Function? createDeal,
    Function? createTask,
    Function? addCustomer,
    Function? addCustomerPotential,
    Function? viewProfileChatHub,
    Function? editCustomerLead,
    Function? openChatGPT,
  }) async {
    bool resultOpen = true;
    showLoading(context);
    await initializeDateFormatting();
    if (domain != null) {
      HTTPConnection.domain = domain;
    }

    ChatConnection.addOnModules = addOnModules;
    ChatConnection.locale = locale;
    ChatConnection.buildContext = context;
    ChatConnection.appIcon = appIcon;
    ChatConnection.brandCode = brandCode;
    ChatConnection.isChatHub = isChatHub;
    ChatConnection.searchProducts = searchProducts;
    ChatConnection.searchOrders = searchOrders;
    ChatConnection.createOrder = createOrder;
    ChatConnection.createAppointment = createAppointment;
    ChatConnection.createDeal = createDeal;
    ChatConnection.createTask = createTask;
    ChatConnection.addCustomer = addCustomer;
    ChatConnection.addCustomerPotential = addCustomerPotential;
    ChatConnection.viewProfileChatHub = viewProfileChatHub;
    ChatConnection.editCustomerLead = editCustomerLead;
    ChatConnection.openChatGPT = openChatGPT;

    if (notificationData != null) {
      ChatConnection.initialData = notificationData;
    }
    AppLocalizations(ChatConnection.locale).load();
    bool result = await connectSocket(context, email, password, appIcon,
        domain: domain, token: token);
    Navigator.of(context).pop();
    ScreenInfo.initialize(MediaQuery.of(context));
    if (result) {
      if (phoneNumber != null) {
        await ChatConnection.checkUserToken();
        resultOpen = await onOpenChatScreen(phoneNumber, context);
        if (resultOpen == false) return false;
      } else {
        await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => AppChat(email: email, password: password),
            settings: const RouteSettings(name: 'home_screen')));

        ChatConnection.dispose(isDispose: true);
      }
    } else {
      loginError(context);
    }
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ $resultOpen');
    return result;
  }

  static Future showLoading(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              )
            ],
          );
        });
  }

  static openNotification(Map<String, dynamic> notificationData) {
    ChatConnection.notificationList();
    try {
      if (ChatConnection.roomId == null) {
        ChatConnection.homeScreenNotificationHandler(notificationData);
      } else {
        ChatConnection.chatScreenNotificationHandler(notificationData);
      }
    } catch (_) {}
  }

  static void loginError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.text(LangKey.warning)),
        content: Text(AppLocalizations.text(LangKey.accountLoginError)),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.text(LangKey.accept)))
        ],
      ),
    );
  }
}

Future<bool> onOpenChatScreen(String phoneNumber, BuildContext context) async {
  try {
    // Gọi API lấy thông tin phòng chat
    final RoomResponse? response =
        await ChatConnection.getRoomByRoomId(phoneNumber);
    if (response!.error == 1) {
      return false;
    } else {
      ChatMessage? chat =
          await ChatConnection.joinRoom(response.data!.room_id!);
      if (chat?.room != null) {
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              data: r.Rooms.mappingFromRoom(chat!.room!),
            ),
            settings: const RouteSettings(name: 'chat_screen'),
          ),
        );
      }
      debugPrintRoom(chat!.room!);
      return true;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
  return false;
}

void debugPrintRoom(Room room) {
  print('#################### ROOM INFO ####################');
  print('sId: ${room.sId}');
  print('isGroup: ${room.isGroup}');
  print('lastUpdate: ${room.lastUpdate}');
  print('lastAuthor: ${room.lastAuthor}');
  print('lastMessage: ${room.lastMessage}');

  // In owner
  if (room.owner != null) {
    print('Owner:');
    print('  isBlocked: ${room.owner!.isBlocked}');
    print(
        '  ...other owner fields...'); // Bạn thêm nếu Owner có nhiều field khác
  } else {
    print('Owner: null');
  }

  // In people
  if (room.people != null && room.people!.isNotEmpty) {
    print('People:');
    for (var p in room.people!) {
      print(
          '  Person: $p'); // Bạn có thể print p.name, p.id nếu People có field cụ thể
    }
  } else {
    print('People: null or empty');
  }

  // In messages
  if (room.messages != null && room.messages!.isNotEmpty) {
    print('Messages:');
    for (var m in room.messages!) {
      print('  Message: $m');
    }
  } else {
    print('Messages: null or empty');
  }

  // In messageSeen
  if (room.messageSeen != null && room.messageSeen!.isNotEmpty) {
    print('MessageSeen:');
    for (var ms in room.messageSeen!) {
      print('  Seen: $ms');
    }
  } else {
    print('MessageSeen: null or empty');
  }

  // In images
  if (room.images != null && room.images!.isNotEmpty) {
    print('Images:');
    for (var img in room.images!) {
      print('  Image: $img');
    }
  } else {
    print('Images: null or empty');
  }

  // In files
  if (room.files != null && room.files!.isNotEmpty) {
    print('Files:');
    for (var f in room.files!) {
      print('  File: $f');
    }
  } else {
    print('Files: null or empty');
  }

  // In links
  if (room.links != null && room.links!.isNotEmpty) {
    print('Links:');
    for (var l in room.links!) {
      print('  Link: $l');
    }
  } else {
    print('Links: null or empty');
  }

  // In pinMessage
  if (room.pinMessage != null) {
    print('PinMessage: ${room.pinMessage}');
  } else {
    print('PinMessage: null');
  }

  print('###################################################');
}

class AppChat extends StatelessWidget {
  final String? email;
  final String? password;
  const AppChat({Key? key, required this.email, required this.password})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
      ));
    }
    return const HomeScreen();
  }
}
