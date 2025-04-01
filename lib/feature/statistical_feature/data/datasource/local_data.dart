
import '../../domain/entities/Statistical.dart';
import '../../domain/entities/warterbill.dart';

class LocalData{
  final List<Statistical> listStatistical=[
    Statistical(name: 'Gửi SMS', quantity: 17),
    Statistical(name: 'Gọi điện', quantity: 11),
    Statistical(name: 'Đóng nước', quantity: 21),
    Statistical(name: 'Mở nước', quantity: 25),
  ];
  final List<WaterBill> listWaterBill=[
    WaterBill(id: "10142353085", name: "Nguyen Van A", address: "Quan 7", category: "Gửi SMS", date: "12/12/2022"),
    WaterBill(id: "10142353086", name: "Nguyen Van B", address: "Quan 8", category: "Gọi điện", date: "12/12/2022"),
    WaterBill(id: "10142353087", name: "Nguyen Van C", address: "Quan 9", category: "Đóng nước", date: "12/12/2022"),
    WaterBill(id: "10142353088", name: "Nguyen Van D", address: "Quan 10", category: "Mở nước", date: "12/12/2022"),
    WaterBill(id: "10142353089", name: "Nguyen Van E", address: "Quan 11", category: "Gửi SMS", date: "12/12/2022"),
    WaterBill(id: "10142353090", name: "Nguyen Van F", address: "Quan 12", category: "Gửi SMS", date: "12/12/2022"),
    WaterBill(id: "10142353091", name: "Nguyen Van G", address: "Quan 1", category: "Gửi SMS", date: "12/12/2022"),
    WaterBill(id: "10142353092", name: "Nguyen Van H", address: "Quan 2", category: "Gọi điện", date: "12/12/2022"),
    WaterBill(id: "10142353093", name: "Nguyen Van I", address: "Quan 3", category: "Đóng nước", date: "12/12/2022"),
    WaterBill(id: "10142353094", name: "Nguyen Van J", address: "Quan 4", category: "Mở nước", date: "12/12/2022"),
    WaterBill(id: "10142353095", name: "Nguyen Van K", address: "Quan 5", category: "Gửi SMS", date: "12/12/2022"),
    WaterBill(id: "10142353096", name: "Nguyen Van L", address: "Quan 6", category: "Gửi SMS", date: "12/12/2022"),
  ];
}