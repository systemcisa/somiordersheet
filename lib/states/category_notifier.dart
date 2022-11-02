import 'package:flutter/material.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEng=> _selectedCategoryInEng;
  String get currentCategoryInKor=>
      categoriesMapEngToKor[_selectedCategoryInEng
      ]!;

  void setNewCategoryWithEng(String newCategory){
    if(categoriesMapEngToKor.keys.contains(newCategory)){
      _selectedCategoryInEng=newCategory;
      notifyListeners();
    }
  }
  void setNewCategoryWithKor(String newCategory){
    if(categoriesMapEngToKor.values.contains(newCategory)){
      _selectedCategoryInEng=categoriesMapKorToEng[newCategory]! ;
      notifyListeners();
    }
  }
}

const Map<String, String> categoriesMapEngToKor = {
  'none': '선택',
  'jeans': '청바지',
  'onepiece': '원피스',
  'top': '상의',
  'bottoms': '하의',
  'jumper': '점퍼',
  'shoes': '신발',
};

//Map<String, String> categoriesMapKorToEng =
//    categoriesMapEngToKor.map((key, value) => MapEntry(value, key));

const Map<String, String> categoriesMapKorToEng = {
  '선택':'none' ,
  '청바지':'jeans' ,
  '원피스':'onepiece' ,
  '상의':'top',
  '하의':'bottoms',
  '점퍼':'jumper',
  '신발':'shoes',
};