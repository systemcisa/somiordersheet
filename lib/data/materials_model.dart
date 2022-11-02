import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialsModel{
  late String materialskey;
  late String name;
  late String index1;
  late String index2;
  late DateTime createdDate;
  DocumentReference? reference;

  MaterialsModel( {
  required this.materialskey,
  required this.name,
  required this.index1,
  required this.index2,
  required this.createdDate,
  this.reference,});

  MaterialsModel.fromJson(Map<String, dynamic> json, this. materialskey, this.reference) {
  name = json['name'];
  index1 = json['index1'];
  index2 = json['index2'];
  createdDate = json['createdDate']== null?DateTime.now().toUtc():(json['createdDate'] as Timestamp).toDate();
  
  }

  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['name'] = name;
  map['index1'] = index1;
  map['index2'] = index2;
  map['createdDate'] = createdDate;
  return map;
  }
}