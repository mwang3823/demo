import 'dart:math';
import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/waterbill_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/config/size_config.dart';
import '../../../../core/constant/app_constant.dart';
import '../../domain/entities/Statistical.dart';
import '../bloc/statistical_bloc.dart';
import '../bloc/statistical_event.dart';
import '../bloc/statistical_state.dart';
import '../bloc/waterbill_bloc.dart';
import '../bloc/waterbill_event.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StatisticalBloc>().add(GetStatistical());
    context.read<WaterBillBloc>().add(GetAllWaterBill());
  }

  final colors = [
    Color.fromRGBO(24, 74, 180, 1),
    Color.fromRGBO(247, 148, 30, 1),
    Color.fromRGBO(62, 64, 149, 1),
    Color.fromRGBO(0, 161, 228, 1)
  ];
  List<Map<String, String>> list = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.textColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                translate('statistical_screen.task_statistics'),
                // 'Thống kê công tác',
                style: TextStyle(
                    fontSize: min(SizeConfig.textSize(5), 24),
                    color: Colors.white),
              )),
          centerTitle: true,
        ),
        body: SizedBox(
          height: height,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppConstant.backgroundWaterBill,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 50,
                right: -75,
                child: Opacity(
                    opacity: 0.15,
                    child: Image.asset(
                      AppConstant.backgroundIcon,
                      fit: BoxFit.none,
                    )),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<StatisticalBloc, StatisticalState>(
                      builder: (context, state) {
                        if (state is OnSuccess) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 700),
                            child: SfCartesianChart(
                              title: ChartTitle(
                                  text: translate('statistical_screen.quantity'),
                                  // 'Số lượng',
                                  alignment: ChartAlignment.near,
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              primaryXAxis: CategoryAxis(
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                majorGridLines: MajorGridLines(width: 0),
                                majorTickLines: MajorTickLines(width: 0),
                                axisLabelFormatter: (axisLabelRenderArgs) {
                                  int index = state.statisticals!.indexWhere(
                                    (element) =>
                                        element.name ==
                                        axisLabelRenderArgs.text,
                                  );
                                  Color color = colors[index % colors.length];

                                  String iconText =
                                      "\u25CF ${axisLabelRenderArgs.text}";

                                  return ChartAxisLabel(
                                      iconText,
                                      TextStyle(
                                          color: color,
                                          fontSize:
                                              min(SizeConfig.textSize(2), 12)));
                                },
                              ),
                              primaryYAxis: NumericAxis(
                                minimum: 5,
                                maximum: 25,
                                interval: 5,
                                majorTickLines: MajorTickLines(width: 0),
                                minorTickLines: MinorTickLines(width: 0),
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                axisLine: AxisLine(width: 0),
                              ),
                              series: [
                                ColumnSeries<Statistical, String>(
                                  dataSource: state.statisticals,
                                  xValueMapper: (datum, index) => datum.name,
                                  yValueMapper: (datum, index) =>
                                      datum.quantity,
                                  pointColorMapper: (datum, index) {
                                    return colors[index % colors.length];
                                  },
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      labelAlignment:
                                          ChartDataLabelAlignment.middle,
                                      textStyle: TextStyle(
                                          fontSize:
                                              min(SizeConfig.textSize(2.5), 15),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(translate('statistical_screen.no_data'),//'Không có dữ liệu',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: min(SizeConfig.textSize(3), 24))),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(translate('statistical_screen.impl_list'),//'Danh sách thực hiện',
                              style: TextStyle(
                                  color: AppConstant.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: min(SizeConfig.textSize(3), 24))),
                        ),
                      ),
                    ),
                    BlocListener<WaterBillBloc, WaterBillState>(
                        listener: (context, state) {
                          if (state is OnWaterBillSuccess) {
                            final List<Map<String, String>> listWaterBill =
                                state.list
                                    .map((e) => {
                                          'id': e.id,
                                          'name': e.name,
                                          'address': e.address,
                                          'category': e.category,
                                          'date': e.date
                                        })
                                    .toList();
                            setState(() {
                              list = listWaterBill;
                            });
                          }
                        },
                        child:
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: SizeConfig.screenWidth),
                          child: DataTable(
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            headingRowColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return AppConstant.textColor;
                              },
                            ),
                            columnSpacing:
                                SizeConfig.screenWidth < 600 ? 8 : 10,
                            columns: [
                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      translate('statistical_screen.list_of_household'),
                                      style: TextStyle(
                                        fontSize: min(SizeConfig.textSize(3), 24),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      translate('statistical_screen.household_name'),
                                      style: TextStyle(
                                        fontSize: min(SizeConfig.textSize(3), 24),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      translate('statistical_screen.address'),
                                      style: TextStyle(
                                        fontSize: min(SizeConfig.textSize(3), 24),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      translate('statistical_screen.type'),
                                      style: TextStyle(
                                        fontSize: min(SizeConfig.textSize(3), 24),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              DataColumn(
                                label: Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      translate('statistical_screen.date'),
                                      style: TextStyle(
                                        fontSize: min(SizeConfig.textSize(3), 24),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // DataColumn(
                              //     label: Text(translate('statistical_screen.list_of_household'),//'Danh bộ',
                              //         style: TextStyle(
                              //           overflow: TextOverflow.ellipsis,
                              //             fontSize:
                              //                 min(SizeConfig.textSize(3), 24),
                              //             color: Colors.white))),
                              // DataColumn(
                              //     label: Text(translate('statistical_screen.household_name'),//'Tên chủ hộ',
                              //         style: TextStyle(
                              //             overflow: TextOverflow.ellipsis,
                              //             fontSize:
                              //                 min(SizeConfig.textSize(3), 24),
                              //             color: Colors.white))),
                              // DataColumn(
                              //     label: Text(translate('statistical_screen.address'),//'Địa chỉ',
                              //         style: TextStyle(
                              //             overflow: TextOverflow.ellipsis,
                              //             fontSize:
                              //                 min(SizeConfig.textSize(3), 24),
                              //             color: Colors.white))),
                              // DataColumn(
                              //     label: Text(translate('statistical_screen.type'),//'Loại',
                              //         style: TextStyle(
                              //             overflow: TextOverflow.ellipsis,
                              //             fontSize:
                              //                 min(SizeConfig.textSize(3), 24),
                              //             color: Colors.white))),
                              // DataColumn(
                              //     label: Text(translate('statistical_screen.date'),//'Ngày',
                              //         style: TextStyle(
                              //             overflow: TextOverflow.ellipsis,
                              //             fontSize:
                              //                 min(SizeConfig.textSize(3), 24),
                              //             color: Colors.white))),
                            ],
                            rows: list.asMap().entries.map((entry) {
                              int index = entry.key;
                              var e = entry.value;

                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return index.isEven
                                        ? null
                                        : Color.fromRGBO(0, 90, 128, 0.21);
                                  },
                                ),
                                cells: [
                                  DataCell(Text(e['id']!,
                                      style: TextStyle(
                                          fontSize: min(
                                              SizeConfig.textSize(2.5), 24)))),
                                  DataCell(Text(e['name']!,
                                      style: TextStyle(
                                          fontSize: min(
                                              SizeConfig.textSize(2.5), 24)))),
                                  DataCell(Text(e['address']!,
                                      style: TextStyle(
                                          fontSize: min(
                                              SizeConfig.textSize(2.5), 24)))),
                                  DataCell(Text(e['category']!,
                                      style: TextStyle(
                                          fontSize: min(
                                              SizeConfig.textSize(2.5), 24)))),
                                  DataCell(Text(e['date']!,
                                      style: TextStyle(
                                          fontSize: min(
                                              SizeConfig.textSize(2.5), 24)))),
                                ],
                              );
                            }).toList(),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CustomColumn extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomColumn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text( translate('statistical_screen.impl_list'),//'Danh sách thực hiện',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: min(SizeConfig.textSize(3), 24))),
        ),
        SizedBox(
          width: 2,
        ),
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_up_outlined,
                  size: 15, color: Colors.grey),
              Icon(Icons.keyboard_arrow_down_outlined,
                  size: 15, color: Colors.grey),
            ],
          ),
        )
      ],
    );
  }
}
