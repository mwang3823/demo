
import '../../domain/entities/Statistical.dart';

class StatisticalModel extends Statistical {
  StatisticalModel({
    required super.name,
    required super.quantity,
  });

  factory StatisticalModel.fromJson(Map<String, dynamic> json) {
    return StatisticalModel(
      name: json['id'],
      quantity: json['category'],
    );
  }
}
