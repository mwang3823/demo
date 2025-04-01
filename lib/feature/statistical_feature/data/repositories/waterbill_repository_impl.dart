
import '../../domain/entities/warterbill.dart';
import '../../domain/repositories/warterbill_repository.dart';
import '../datasource/local_data.dart';

class WaterBillRepositoryImpl extends WaterBillRepository{
  final LocalData localData;

  WaterBillRepositoryImpl({required this.localData});

  @override
  List<WaterBill> getAllWaterBill() {
    return localData.listWaterBill;
  }
}