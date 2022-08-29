import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todoapp/homePage.dart';
import 'package:todoapp/models/user.dart';
import 'package:todoapp/reponsive/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const MyLogin();
    } else {
      return const MyHomePage();
    }
  }
}
