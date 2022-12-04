import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:hotel_database_app/provider/hotel_service.dart';
import 'package:hotel_database_app/screens/auth/auth_service.dart';

import 'package:hotel_database_app/screens/widget_tree.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HotelModel()),
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: Widgettree(),
      ),
    );
  }
}
