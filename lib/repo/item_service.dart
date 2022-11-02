import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomato/constants/data_keys.dart';
import 'package:tomato/data/item_model.dart';

class ItemService{
  static final ItemService _itemService = ItemService._internal();
  factory ItemService() => _itemService;
  ItemService._internal();

  Future createNewItem(Map<String, dynamic> json, String itemKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
  }
  Future<ItemModel> getItem(String itemKey) async{
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }
  Future<List<ItemModel>> getItems() async{
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionReference.get();
    
    List<ItemModel> items=[];
    
    for(int i=0; i< snapshot.size; i++){
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshot.docs[i]);
      items.add(itemModel);
    }
    return items;
  }
}