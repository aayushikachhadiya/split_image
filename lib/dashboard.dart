import 'dart:io';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:split_image/data_transaction.dart';
import 'package:split_image/password.dart';
import 'package:split_image/transactions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dashboard extends StatefulWidget {
  static Database? database;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  List view = [];
  List views = [];
  List c = [];
  List d = [];
  List credit_sum = [];
  List total = [];
  List dabit_sum = [];
  String set_currency = "";
String name="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    set_currency = password.prefs!.getString("currency") ?? "";
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    dashboard.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute('CREATE TABLE account (id INTEGER PRIMARY KEY, name TEXT)');
      await db.execute(
          'CREATE TABLE entry (id INTEGER PRIMARY KEY, a_id INTEGER,Date Text,credit NUMERIC,dabit NUMERIC,name Text)');
    });
    String sel = "SELECT * FROM account";
    view = await dashboard.database!.rawQuery(sel);
    credit_sum = List.filled(view.length, 0);
    dabit_sum = List.filled(view.length, 0);
    total = List.filled(view.length, 0);
    if (view.length != 0) {
      for (int i = 0; i < view.length; i++) {
        String select = "SELECT * FROM entry where a_id=${view[i]['id']}";
        views = await dashboard.database!.rawQuery(select);
        String credits =
            "SELECT SUM(credit) FROM entry where a_id=${view[i]['id']}";
        c = await dashboard.database!.rawQuery(credits);
        // print(c);
        String debits =
            "SELECT SUM(dabit) FROM entry where a_id=${view[i]['id']}";
        d = await dashboard.database!.rawQuery(debits);
        // credit_sum=c[0]['SUM(credit)'];
        // dabit_sum=d[0]['SUM(dabit)'];
        credit_sum[i] = c[0]['SUM(credit)'];
        dabit_sum[i] = d[0]['SUM(dabit)'];
        // total[i] = credit_sum[i] - dabit_sum[i];
      }
      print(total);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: WillPopScope(
          child: Scaffold(
              drawer: Drawer(
                child: Column(children: [
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 250,
                        child: Column(children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                            height: 50,
                            margin: EdgeInsets.only(top: 50, bottom: 5),
                            width: 50,
                            child: Icon(Icons.my_library_books_rounded,
                                color: Colors.white),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Account Manager",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Container(
                            height: 3,
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 15, right: 15),
                          )
                        ]),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("myasset/sidemenu_bg.png")))),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currency) {
                          print('Select currency: ${currency.symbol}');
                          password.prefs!
                              .setString("currency", currency.symbol);
                          get();
                          setState(() {});
                        },
                      );
                    },
                    child: ListTile(
                      title: Text("change currency"),
                      leading: Icon(Icons.settings),
                    ),
                  ),
                  Expanded(flex: 2, child: Text(""))
                ]),
              ),
              appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.deepPurple,
                  title: Text("Dashboard")),
              body: Column(
                children: [
                  Expanded(
                      child: Container(
                    child: FutureBuilder(
                      future: get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: view.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return data_trasaction(view[index]);
                                    },
                                  ));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Row(children: [
                                      Text("${view[index]["name"]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Container(margin: EdgeInsets.only(left: 180),),
                                      Wrap(children: [
                                        IconButton(onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                actions: [
                                                  Container(
                                                      margin: EdgeInsets.only(bottom: 10),
                                                      child: Text("Add new account",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold)),
                                                      color: Colors.deepPurple,
                                                      height: 50,
                                                      width: double.infinity),
                                                  TextField(
                                                    controller: t1,
                                                    decoration: InputDecoration(
                                                      labelText: "${view[index]['name']}",
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            margin: EdgeInsets.all(5),
                                                            height: 40,
                                                            width: double.infinity,
                                                            child: Text("Cancle",
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors.deepPurple)),
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius:
                                                                BorderRadius.circular(20),
                                                                border: Border.all(
                                                                    color: Colors.deepPurple,
                                                                    width: 2)),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                             // String names=t1.text;
                                                            // if(widget.m!=null)
                                                            // {
                                                              String qry="update account set name='${t1.text}' where id=${view[index]['id']}";
                                                              dashboard.database!.rawUpdate(qry);
                                                              Navigator.pop(context);
                                                              setState(() {

                                                              });
                                                            // }

                                                            // t1.text = "";
                                                          },
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            margin: EdgeInsets.all(5),
                                                            height: 40,
                                                            width: double.infinity,
                                                            child: Text("Save",
                                                                style: TextStyle(
                                                                    fontSize: 20,
                                                                    color: Colors.white)),
                                                            decoration: BoxDecoration(
                                                                color: Colors.deepPurple,
                                                                borderRadius:
                                                                BorderRadius.circular(20),
                                                                border: Border.all(
                                                                    color: Colors.deepPurple,
                                                                    width: 2)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }, icon: Icon(Icons.mode_edit_outline_outlined,color: Colors.deepPurple,)),
                                        IconButton(
                                            onPressed: () {
                                              String del =
                                                  "DELETE FROM account where id=${view[index]['id']}";
                                              String delete = "delete from entry where a_id=${view[index]['id']}";
                                              dashboard.database!.rawDelete(delete);
                                              dashboard.database!.rawDelete(del);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.delete,color: Colors.deepPurple,)),
                                      ]),
                                    ],),
                                    subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          FutureBuilder(
                                            future: get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.active ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 70,
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Text(
                                                        "Credit(↑)\n  $set_currency${(credit_sum[index] != null) ? credit_sum[index] : "0"}",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                            future: get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.active ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 70,
                                                    child: Text(
                                                        "Debit(↓) \n  $set_currency${(dabit_sum[index] != null) ? dabit_sum[index] : "0"}",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                            future: get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.active ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.deepPurple,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 70,
                                                    child: Text(
                                                        "Balance\n $set_currency${(total[index] != null) ? total[index] : "0"}",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
                                          )
                                        ]),
                                    // trailing: Wrap(children: [
                                    //   IconButton(onPressed: () {
                                    //
                                    //   }, icon: Icon(Icons.mode_edit_outline_outlined,color: Colors.deepPurple,)),
                                    //   IconButton(
                                    //       onPressed: () {
                                    //         String del =
                                    //             "DELETE FROM account where id=${view[index]['id']}";
                                    //         String delete = "delete from entry where a_id=${view[index]['id']}";
                                    //         dashboard.database!.rawDelete(delete);
                                    //         dashboard.database!.rawDelete(del);
                                    //         setState(() {});
                                    //       },
                                    //       icon: Icon(Icons.delete,color: Colors.deepPurple,)),
                                    // ]),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text("Add new account",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  color: Colors.deepPurple,
                                  height: 50,
                                  width: double.infinity),
                              TextField(
                                controller: t1,
                                decoration: InputDecoration(
                                  labelText: "Account name",
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: double.infinity,
                                        child: Text("Cancle",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.deepPurple)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.deepPurple,
                                                width: 2)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        get();
                                        String name = t1.text;
                                        String sql =
                                            "INSERT INTO account VALUES(null,'$name')";
                                        print(sql);
                                        dashboard.database!
                                            .rawInsert(sql)
                                            .then((value) {
                                          print(value);
                                        });
                                        Navigator.pop(context);
                                        setState(() {});
                                        t1.text = "";
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: double.infinity,
                                        child: Text("Save",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.deepPurple,
                                                width: 2)),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 300, bottom: 20),
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.orange,
                          image: DecorationImage(
                              image: AssetImage(
                                  "myasset/abc_ic_menu_copy_mtrl_am_alpha.png"))),
                    ),
                  )
                ],
              )),
          onWillPop: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Account manager",
                      style: TextStyle(fontSize: 30, color: Colors.deepPurple)),
                  content: Text("Are you sure want to exit",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  actions: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1, color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("Cancle",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              exit(0);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 100,
                              child: Text("Exit",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            );
            return true;
          },
        ));
  }
}
