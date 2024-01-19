
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'adapter.dart';


Future<void> main()
async {
      WidgetsFlutterBinding.ensureInitialized();
      final  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentsDir.path);

      var box = await Hive.openBox('add');
      runApp(MaterialApp(home: hive_database(),));
}
class hive_database extends StatefulWidget {
  const hive_database({super.key});

  @override
  State<hive_database> createState() => _hive_databaseState();
}

class _hive_databaseState extends State<hive_database> {
  int a=0;
  Box box=Hive.box('add');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    a=box.get('add')??0;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hice database")
      ),
      body: Column(
        children: [
          Text("A:$a",style: TextStyle(fontSize: 30),),
        TextButton(onPressed: () {
          a++;
          box.put('add', a);
          setState(() {

          });
        }, child: Text("Add"))
        ],
      ),
    );
  }
}
