
import '../entities/warterbill.dart';
import '../repositories/warterbill_repository.dart';

class WaterBillUseCase{
  final WaterBillRepository repository;

  const WaterBillUseCase({required this.repository});

  List<WaterBill> call(){
    return repository.getAllWaterBill();
  }
}