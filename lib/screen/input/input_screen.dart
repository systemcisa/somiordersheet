import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/item_model.dart';
import 'package:tomato/repo/image_storage.dart';
import 'package:tomato/repo/item_service.dart';
import 'package:tomato/screen/input/multi_image_select.dart';
import 'package:tomato/states/category_notifier.dart';
import 'package:tomato/states/select_image_notifier.dart';
import 'package:tomato/utils/logger.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  bool _seuggestPriceSelected = false;

  TextEditingController _priceController = TextEditingController();
  var _border= UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent));



  var _divider = Divider(
    height: common_padding * 2 + 1,
    thickness: 1,
    color: Colors.grey[450],
    indent: common_padding,
    endIndent: common_padding,
  );

  bool isCreatingItem = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    isCreatingItem = true;
    setState(() {});

    final String itemKey = ItemModel.generateItemKey("");
    List<Uint8List> images =
        context
            .read<SelectImageNotifier>()
            .images;

    List<String> downloadUrls =
    await ImageStorage.uploadImages(images, itemKey);

final num? price = num.tryParse(_priceController.text);


    ItemModel itemModel = ItemModel(
        itemKey: itemKey,
        imageDownloadUrls: downloadUrls,
        title: _nameController.text,
        address: _addressController.text,
        category: context
            .read<CategoryNotifier>()
            .currentCategoryInEng,
        price: price??0,
        negotiable: _seuggestPriceSelected,
        detail: _detailController.text,
        createdDate: DateTime.now().toUtc());
    logger.d('upload finished - ${downloadUrls.toString()}');
    
    await ItemService().createNewItem(itemModel.toJson(), itemKey);
    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery
            .of(context)
            .size;
        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: Size(_size.width, 2),
                  child: isCreatingItem
                      ? LinearProgressIndicator(
                    minHeight: 2,
                  )
                      : Container()),
              leading: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.black87,
                    backgroundColor:
                    Theme
                        .of(context)
                        .appBarTheme
                        .backgroundColor),
                child: Text(
                  '뒤로',
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .appBarTheme
                          .foregroundColor),
                ),
                onPressed: () {
                  context.beamBack();
                },
              ),
              title: Text('자재 등록 및 입출고'),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.black87,
                        backgroundColor:
                        Theme
                            .of(context)
                            .appBarTheme
                            .backgroundColor),
                    child: Text(
                      '완료',
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .appBarTheme
                              .foregroundColor),
                    ),
                    onPressed: attemptCreateItem
                ),
              ],
            ),
            body: ListView(
              children: [
                MultiImageSelect(),
                _divider,
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: '손님이름',
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_padding),
                      border:_border, enabledBorder: _border, focusedBorder: _border),
                ),
                _divider,
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: '손님주소',
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_padding),
                      border:_border, enabledBorder: _border, focusedBorder: _border),
                ),
                _divider,
                ListTile(
                  onTap: () {
                    context.beamToNamed('/input/category_input');
                  },
                  dense: true,
                  title: Text(
                      context
                          .watch<CategoryNotifier>()
                          .currentCategoryInKor),
                  trailing: Icon(Icons.navigate_next),
                ),
                _divider,
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '식별코드2',
                              border: _border, enabledBorder: _border, focusedBorder: _border,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: common_padding),
                            ))),
                    TextButton.icon(
                      onPressed: () {
                        setState((){   _seuggestPriceSelected = !_seuggestPriceSelected;});
                      },
                      icon: Icon(
                        _seuggestPriceSelected?Icons.check_circle:Icons.check_circle_outline,
                        color: _seuggestPriceSelected?Colors.red:Colors.black54,
                      ),
                      label: Text(
                        '재고 주위',
                        style: TextStyle(color: _seuggestPriceSelected?Colors.red:Colors.black54),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.black54),
                    ),
                  ],
                ),
                _divider,
                TextFormField(
                  controller: _detailController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: '주문내용',
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_padding),
                      border:_border, enabledBorder: _border, focusedBorder: _border),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
