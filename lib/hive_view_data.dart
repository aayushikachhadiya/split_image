import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:split_image/adapter.dart';
import 'package:split_image/add_hive.dart';

class view_data extends StatefulWidget {
  const view_data({super.key});

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  Box box = Hive.box('cdmi');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("view data")),
      body: ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          controller c = box.getAt(index);
          return Card(
            child: ListTile(
              title: Text("${c.name}"),
              subtitle: Text("${c.contect}"),
              trailing: Wrap(children: [
                IconButton(onPressed: () {
                  box.deleteAt(index);
                  setState(() {
                  });
                }, icon: Icon(Icons.delete)),
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return add_hive(c);
                  },));
                  setState(() {
                  });
                }, icon: Icon(Icons.edit))
              ]),
            ),
          );
        },
      ),
    );
  }
}
