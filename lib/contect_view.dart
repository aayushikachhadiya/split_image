import 'package:flutter/material.dart';
import 'package:split_image/sql_contect.dart';
import 'package:sqflite/sqflite.dart';

class contect_view extends StatefulWidget {
  const contect_view({super.key});

  @override
  State<contect_view> createState() => _contect_viewState();
}

class _contect_viewState extends State<contect_view> {
  // Database? database;
  List view=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  get();
  }
  get()
  async {
    String sel="SELECT * FROM Con";
    view= await Home.database!.rawQuery(sel);
    print(view);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View data")
      ),
      body:  FutureBuilder(future: get(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
          {
            return ListView.builder(itemCount: view.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title:  Text("${view[index]["name"]}"),
                    subtitle: Text("${view[index]["contact"]}"),
                    trailing: Wrap(children: [

                      IconButton(onPressed: () {
                        String del="DELETE FROM Con where id=${view[index]['id']}";
                        Home.database!.rawDelete(del);
                        setState(() {

                        });

                      }, icon: Icon(Icons.delete)),
                      IconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Home(view);
                        },));
                        setState(() {
                        });
                      }, icon: Icon(Icons.edit))
                    ]),
                  ),
                );
              },
            );
          }else
            {
              return CircularProgressIndicator();
            }

      },)
    );
  }
}
