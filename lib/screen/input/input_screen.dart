import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/order_model.dart';
import 'package:tomato/repo/image_storage.dart';
import 'package:tomato/repo/order_service.dart';
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
  TextEditingController _priceController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  void attemptCreateItem() async {
    isCreatingItem = true;
    setState(() {});

    final String orderKey = OrderModel.generateItemKey("");
    List<Uint8List> images =
        context
            .read<SelectImageNotifier>()
            .images;

    List<String> downloadUrls =
    await ImageStorage.uploadImages(images, orderKey);

final num? price = num.tryParse(_priceController.text);

    OrderModel orderModel = OrderModel(
        orderKey: orderKey,
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
    
    await OrderService().createNewOrder(orderModel.toJson(), orderKey);
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
              title: Text('SOMI MALL 주문서'),
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
                   Row(
                     children: [
                       Expanded(
                         child: TextFormField(
                           textAlign: TextAlign.end,
                           keyboardType: TextInputType.number,
                           controller: _priceController,
                           onChanged: (value) {
                             if (value == '0원') {
                               _priceController.clear();
                             }

                             setState(() {});
                           },
                           decoration: InputDecoration(
                               hintText: '주문가격',
                               contentPadding:
                               EdgeInsets.symmetric(horizontal: common_padding),
                               border:_border, enabledBorder: _border, focusedBorder: _border),
                         ),
                       ),
                       Text(',000원 '),
                       Container(width: 200,)
                     ],
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
