import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/router/locations.dart';
import 'package:tomato/screen/home/orders_page.dart';
import 'package:tomato/screen/home/records_page.dart';
import 'package:tomato/states/user_provider.dart';
import 'package:tomato/widgets/expandable_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          OrdersPage(),
          RecordsPage(),
          Container(color: Colors.accents[6],)
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90,
        children: [
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_INPUT');
            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_RECORD');
            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('SOMI MALL', style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: [

        IconButton(onPressed: (){
          context.read<UserProvider>().setUserAuth(true);
        }, icon: Icon(Icons.logout,))
      ],),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '재고현황'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '입출고현황'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '설정/데이터'),
        ],
        onTap: (index){
          setState((){
            _bottomSelectedIndex = index;
          });
        }
      ),
    );
  }
}
