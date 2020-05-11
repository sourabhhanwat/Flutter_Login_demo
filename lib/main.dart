import 'package:flutter/material.dart';
import 'sharedloginregister.dart';
//import 'backup.dart';

//void main() => runApp(Login());

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Login(),
    ));
