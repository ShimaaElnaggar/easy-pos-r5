import 'package:easy_pos_r5/helpers/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'views/home_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var sqlHelper = SqlHelper();
  await sqlHelper.init();
  if(sqlHelper.db != null){
    GetIt.I.registerSingleton(sqlHelper);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Pos',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff0157db),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white  ,
          cardColor: Colors.blue.shade100,
          errorColor: Colors.red,
          primarySwatch: getMaterialColor(
            const Color(0xff0157db),
          ),
        ),
      ),
      home: const HomeView(),
    );
  }
  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final int alpha = color.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      // Add more shades as needed (e.g., 200, 300, etc.)
    };

    return MaterialColor(color.value, shades);
  }
}

