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
  'none': '건물이름',
  'THEOT': 'THEOT',
  'NUZZONE': 'NUZZONE',
  'APM': 'APM',
  'SHOEA': '신발A',
  'SHOEB': '신발B',
  'SHOEC': '신발C',
  'SHOED': '신발D',
  'NPH': '남평화',
  'DPH': '동평화',
  'CPH': '청평화',
  'TECHNO': '테크노',
  'STUDIOW':'스튜디오W',
  'DWP':'DWP',
};

//Map<String, String> categoriesMapKorToEng =
//    categoriesMapEngToKor.map((key, value) => MapEntry(value, key));

const Map<String, String> categoriesMapKorToEng = {
  '건물이름':'none',
  'THEOT':'THEOT',
  'NUZZON':'NUZZON',
  'APM':'APM',
  '신발A':'SHOEA',
  '신발B':'SHOEB',
  '신발C':'SHOEC',
  '신발D':'SHOED',
  '남평화':'NPH',
  '동평화':'DPH',
  '청평화':'CPH',
  '테크노':'TECHNO',
  '스튜디오W':'STUDIOW',
  'DWP':'DWP',
};