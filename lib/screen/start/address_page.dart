import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/address_model.dart';
import 'package:tomato/data/address_model2.dart';
import 'package:tomato/screen/start/address_service.dart';
import 'package:tomato/utils/logger.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;
  List<AddressModel2> _addressModel2List =[];
  bool _isGettingLocation = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: common_padding, right: common_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _addressModel2List.clear();
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {});
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: '내 학과 또는 관심학과 검색',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 24, maxHeight: 24)),
          ),
          TextButton.icon(
            onPressed: () async {
              _addressModel=null;
              _addressModel2List.clear();
              setState(() {
                _isGettingLocation = true;
              });

              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }
              _locationData = await location.getLocation();
              logger.d(_locationData);
              List<AddressModel2> addresses = await AddressService().findAddressByCoordinate(
                  log: _locationData.longitude!, lat: _locationData.latitude!);

              _addressModel2List.addAll(addresses);

              setState((){
                _isGettingLocation = false;
              });

            },
            icon: _isGettingLocation?CircularProgressIndicator(color: Colors.white,):Icon(
              CupertinoIcons.antenna_radiowaves_left_right,
              color: Colors.white,
            ),
            label: Text(_isGettingLocation?'위치 찾는중':'학과 찾기', style: Theme.of(context).textTheme.button),
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(10, 48)),
          ),
          if(_addressModel !=null)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: common_padding),
              itemBuilder: (context, index) {
                if (_addressModel == null ||
                    _addressModel!.result == null ||
                    _addressModel!.result!.items == null ||
                    _addressModel!.result!.items![index].address == null)
                  return Container();
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  trailing: ExtendedImage.asset('assets/imgs/tomato.png'),
                  title: Text(
                      _addressModel!.result!.items![index].address!.road ?? ""),
                  subtitle: Text(
                      _addressModel!.result!.items![index].address!.parcel ??
                          ""),
                );
              },
              itemCount: (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null)
                  ? 0
                  : _addressModel!.result!.items!.length,
            ),
          ),
          if(_addressModel2List.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: common_padding),
                itemBuilder: (context, index) {
                  if (
                      _addressModel2List[index].result == null ||
                          _addressModel2List[index].result!.isNotEmpty)
                    return Container();
                  return ListTile(
                    leading: Icon(Icons.account_circle),
                    trailing: ExtendedImage.asset('assets/imgs/tomato.png'),
                    title: Text(
                        _addressModel2List[index].result![0].text ?? ""),
                    subtitle: Text(
                        _addressModel2List[index].result![0].zipcode ?? ""
                            ""),
                  );
                },
                itemCount: _addressModel2List.length
              ),
            ),
        ],
      ),
    );
  }
}
