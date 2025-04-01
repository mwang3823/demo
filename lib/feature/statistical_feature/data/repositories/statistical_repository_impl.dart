
import '../../domain/entities/Statistical.dart';
import '../../domain/repositories/statistical_repository.dart';
import '../datasource/local_data.dart';

class StatisticalRepositoryImpl extends StatisticalRepository{
  final LocalData localData;

  StatisticalRepositoryImpl({required this.localData});

  @override
  List<Statistical> getStatistical() {
    return localData.listStatistical;
  }

}