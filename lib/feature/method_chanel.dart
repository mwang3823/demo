import 'package:flutter/services.dart';

class DeviceInfo{
  static const MethodChannel _methodChannel=MethodChannel('com.example.get_id_device');

  static Future<String> getUniqueId() async{
    try{
      final String uniqueId= await _methodChannel.invokeMethod('getUniqueId');
      print('____________________unique Id: $uniqueId __________________________');
      return uniqueId;
    }catch(e){
      throw Exception(e);
    }
  }

}