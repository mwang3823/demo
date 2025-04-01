import 'dart:convert';
import 'dart:io';

void main() async {
  // Đường dẫn file cần chỉnh sửa
  const filePath = 'assets/AppConfig/app_config.json';

  // Kiểm tra xem file có tồn tại không
  final file = File(filePath);
  if (!file.existsSync()) {
    print(' File không tồn tại: $filePath');
    return;
  }

  // Đọc nội dung file JSON
  String content = await file.readAsString();
  Map<String, dynamic> jsonData = jsonDecode(content);

  // Cập nhật giá trị trong file JSON
  jsonData['app_name'] = 'App Test 1';
  jsonData['primary_color'] = '#FF5733';

  // Ghi lại nội dung mới vào file
  await file.writeAsString(JsonEncoder.withIndent('  ').convert(jsonData));

  print('✅ File đã được cập nhật thành công: $filePath');
}
