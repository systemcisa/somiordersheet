import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato/constants/data_keys.dart';
import 'package:tomato/data/record_model.dart';

class RecordService{
  static final RecordService _recordService = RecordService._internal();
  factory RecordService() => _recordService;
  RecordService._internal();

  Future createNewRecord(Map<String, dynamic> json, String recordKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_RECORDS).doc(recordKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
  }
  Future<RecordModel> getRecord(String recordKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_RECORDS).doc(recordKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    RecordModel recordModel = RecordModel.fromSnapshot(documentSnapshot);
    return recordModel;
  }
  Future<List<RecordModel>> getRecords() async{
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection(COL_ORDERS);
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionReference.orderBy("createDate", descending: true).get();
    
    List<RecordModel> records=[];
    
    for(int i=0; i< snapshot.size; i++){
      RecordModel recordModel = RecordModel.fromQuerySnapshot(snapshot.docs[i]);
      records.add(recordModel);
    }
    return records;
  }
}