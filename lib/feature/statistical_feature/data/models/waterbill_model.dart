
import '../../domain/entities/warterbill.dart';

class WaterBillModel extends WaterBill {
  WaterBillModel({required super.id,
    required super.name,
    required super.address,
    required super.category,
    required super.date});

  factory WaterBillModel.fromJson(Map<String, dynamic> json){
    return WaterBillModel(id: json['id'],
        name: json['name'],
        address: json['address'],
        category: json['category'],
        date: json['date']);
  }
}
