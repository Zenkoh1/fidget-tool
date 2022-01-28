import 'package:fidget_tool/services/stored-data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/nav.dart';
import 'models/settings-model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StoredData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Nav.route,
      routes: {
        Nav.route: (_) => Nav(),
      },
    );
  }
}
