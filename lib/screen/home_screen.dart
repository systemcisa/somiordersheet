import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/screen/home/items_page.dart';
import 'package:tomato/states/user_provider.dart';

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
          ItemsPage(),
          Container(color: Colors.accents[3],),
          Container(color: Colors.accents[6],)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one_outlined),
        onPressed: () {
          context.beamToNamed('/input');

      },

      ),
      appBar: AppBar(
        title: Text('재고 관리', style: Theme.of(context).appBarTheme.titleTextStyle,),
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
