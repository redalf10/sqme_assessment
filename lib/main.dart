import 'package:assessment/app.dart';
import 'package:assessment/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/shop_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize sqflite database factory
  await DatabaseHelper().database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Shop()),
      ],
      child: const MyAssessment(),
    ),
  );
}
