
import 'package:demo_architecture/feature/statistical_feature/domain/entities/Statistical.dart';
import '../repositories/statistical_repository.dart';

class GetStatisticalUseCase{
  final StatisticalRepository repository;

  GetStatisticalUseCase({required this.repository});

  List<Statistical> getStatistical(){
    return repository.getStatistical();
  }
}