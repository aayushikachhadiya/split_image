import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:split_image/adapter.dart';
import 'package:split_image/hive_view_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  Hive.registerAdapter(controllerAdapter());
  var box = await Hive.openBox('cdmi');
  runApp(MaterialApp(
    home: add_hive(),
  ));
}

class add_hive extends StatefulWidget {
  controller? c;
  add_hive([this.c]);

  @override
  State<add_hive> createState() => _add_hiveState();
}

class _add_hiveState extends State<add_hive>
{
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  Box box=Hive.box('cdmi');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.c!=null)
      {
        t1.text=widget.c!.name;
        t2.text=widget.c!.contect;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.c!=null)?Text("update data"):Text("add data"),
      ),
      body:Column(
        children: [
          TextField(
          controller: t1,
          ),
          TextField(
            controller: t2,
          ),
          ElevatedButton(onPressed: () {
            String name =t1.text;
            String contact=t2.text;
          if(widget.c!=null)
            {
              widget.c!.name=name;
              widget.c!.contect=contact;
              widget.c!.save();
            }else
              {
                controller c=controller(name, contact);
                box.add(c);
                setState(() {
                });
                print(c);
              }
            t1.text="";
            t2.text="";
          }, child:Text("add") ),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return view_data();
            },));
          }, child: Text("view"))
        ],
      ) ,
    );
  }
}
