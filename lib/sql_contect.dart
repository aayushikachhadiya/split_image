import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:split_image/contect_view.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  static Database? database;
  List ?view;
Home([this.view]);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  get() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    Home.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Con (id INTEGER PRIMARY KEY, name TEXT, contact TEXT)');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(controller: t1),
          TextField(
            controller: t2,
          ),
          ElevatedButton(
              onPressed: () {
                String name = t1.text;
                String contact = t2.text;
                if (widget.view != null)
              {
                String up="UPDATE Con SET name ='$name',contect='$contact'";
                Home.database!.rawUpdate(up);
              }else
                {
                  String sql = "INSERT INTO Con VALUES(null,'$name','$contact')".toString();
                  print(sql);
                  Home.database?.rawInsert(sql).then((value) {
                    print(value);
                  });
                }

              },
              child: Text("add")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return contect_view();
            },));
          }, child: Text("View"))
        ],
      ),
    );
  }
}
