import 'package:flutter/material.dart';
import 'package:hotel_database_app/provider/hotel_service.dart';
import 'package:hotel_database_app/screens/auth/auth.dart';
import 'package:hotel_database_app/screens/auth/auth_service.dart';

import 'package:hotel_database_app/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

class Widgettree extends StatefulWidget {
  Widgettree({Key? key}) : super(key: key);

  @override
  State<Widgettree> createState() => _WidgettreeState();
}

class _WidgettreeState extends State<Widgettree> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthService>(context);
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SearchScreen();
        } else {
          return AuthEnter();
        }
      },
      stream: model.authChanges,
    );
  }
}
