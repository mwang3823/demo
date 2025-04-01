import 'dart:convert';
import 'dart:io';

void main() async {
  //_____________________________Đọc file cấu hình JSON + decode________________
  final configFile = File('assets/AppConfig/app_config.json');
  if (!configFile.existsSync()) {
    print(' File config.json không tồn tại!');
    return;
  }

  final config = jsonDecode(await configFile.readAsString());

  //_____________________________Lấy dữ liệu cấu hình___________________________
  final iconPath = config['app_icon'] ?? 'assets/icon/app_icon.png';
  final String appName = config['app_name'] ?? 'My Flutter App';

  //________________________Tạo file `flutter_launcher_icons.yaml`_______________
  final yamlConfig = '''
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "$iconPath"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "$iconPath"
  min_sdk_android: 21
''';

  final yamlFile = File('flutter_launcher_icons.yaml');
  await yamlFile.writeAsString(yamlConfig);
  print(' Đã tạo file flutter_launcher_icons.yaml');

  //____________________________Cập nhật icon____________________________________
  print(' Đang cập nhật icon...');
  final result = await Process.run('dart', ['run', 'flutter_launcher_icons']);

  print(result.stdout);
  print(result.stderr);

  if (result.exitCode == 0) {
    print(' Cập nhật icon thành công!');
  } else {
    print(' Có lỗi xảy ra khi cập nhật icon.');
  }

  //_________________________Cập nhật tên ứng dụng trên Android_________________
  print(' Đang cập nhật tên ứng dụng trên Android...');
  final androidManifest = File('android/app/src/main/AndroidManifest.xml');

  if (androidManifest.existsSync()) {
    String manifestContent = await androidManifest.readAsString();

    // Debug xem tên ứng dụng trước khi cập nhật
    final oldAppNameMatch = RegExp(r'android:label="([^"]+)"').firstMatch(manifestContent);
    final oldAppName = oldAppNameMatch?.group(1) ?? 'Không tìm thấy';

    manifestContent = manifestContent.replaceAllMapped(
      RegExp(r'android:label="([^"]+)"'),
          (match) => 'android:label="$appName"',
    );

    await androidManifest.writeAsString(manifestContent);

    // Debug xem tên ứng dụng sau khi cập nhật
    print(' Tên cũ: $oldAppName');
    print(' Tên mới: $appName');
    print(' Đã cập nhật tên ứng dụng trên Android.');
  } else {
    print(' Không tìm thấy AndroidManifest.xml!');
  }

  //_________________________Cập nhật tên ứng dụng trên iOS_____________________
  print(' Đang cập nhật tên ứng dụng trên iOS...');
  final iosPlist = File('ios/Runner/Info.plist');

  if (iosPlist.existsSync()) {
    String plistContent = await iosPlist.readAsString();

    plistContent = plistContent.replaceAllMapped(
      RegExp(r'<key>CFBundleDisplayName<\/key>\s*<string>([^<]+)<\/string>'),
          (match) => '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
    );

    await iosPlist.writeAsString(plistContent);
    print(' Đã cập nhật tên ứng dụng trên iOS.');
  } else {
    print(' Không tìm thấy Info.plist!');
  }
}
