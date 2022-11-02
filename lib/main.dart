import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/router/locations.dart';
import 'package:tomato/screen/start_screen.dart';
import 'package:tomato/screen/splash_screen.dart';
import 'package:tomato/states/user_provider.dart';
import 'package:tomato/utils/logger.dart';

final _routerDelegate = BeamerDelegate(
    guards: [
      BeamGuard(
          pathBlueprints: [
            ...HomeLocation().pathBlueprints,
          //  ...InputLocation().pathBlueprints,
          //  ...ItemLocation().pathBlueprints,
          ],
          check: (context, location) {
            return context.watch<UserProvider>().userState;
          },
          showPage: BeamPage(child: startScreen()))
    ],
    locationBuilder: BeamerLocationBuilder(
        beamLocations: [HomeLocation(), InputLocation(), ItemLocation()]));

void main() async {
  logger.d('My first log by logger!!');
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      // print('error occur while loading.');
      return Text(
        'Error occur',
        textDirection: TextDirection.ltr,
      );
    } else if (snapshot.connectionState == ConnectionState.done) {
      return TomatoApp();
    } else {
      return SplashScreen();
    }
  }
}

class TomatoApp extends StatelessWidget {
  const TomatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'DoHyeon',
            hintColor: Colors.grey[350],
            textTheme: TextTheme(button: TextStyle(color: Colors.white)),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    primary: Colors.white,
                    minimumSize: Size(10, 48))),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                titleTextStyle: TextStyle(
                    color: Colors.black87, fontSize: 20, fontFamily: 'DoHyeon'),
                actionsIconTheme: IconThemeData(color: Colors.black87))),
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
