import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_flu/pages/home_page.dart';

import 'data/database.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ToDoDatabase(box),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}
