import 'package:flutter/material.dart';
import 'package:split_image/dashboard.dart';
import 'package:split_image/password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class data_trasaction extends StatefulWidget {
  Map m;
  data_trasaction(this.m);

  static Database? data;

  @override
  State<data_trasaction> createState() => _data_trasactionState();
}

class _data_trasactionState extends State<data_trasaction> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  String Transaction = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get();
    t1.text =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  }

  List view = [];
  List c = [];
  List d = [];
  var total;
  String type = "";
  String set_currency = "";

  get() async {
    set_currency=password.prefs!.getString("currency") ?? "";
    String sel = "SELECT * FROM entry where a_id=${widget.m['id']}";
    view =await dashboard.database!.rawQuery(sel);
    print(view);
    String credits = " SELECT SUM(credit) FROM entry where a_id=${widget.m['id']}";
    c = await dashboard.database!.rawQuery(credits);
    String debits = " SELECT SUM(dabit) FROM entry where a_id=${widget.m['id']} ";
    d = await dashboard.database!.rawQuery(debits);
    total = c[0]['SUM(credit)'] - d[0]['SUM(dabit)'];

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(
        appBar: AppBar(
          title: Text("${widget.m['name']}",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          Expanded(
                              child: Container(
                                color: Colors.deepPurple,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text("Add transaction",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              )),
                          TextField(
                            controller: t1,
                            decoration: InputDecoration(
                              labelText: "Transaction Date",
                            ),
                          ),
                          StatefulBuilder(builder: (context, setState1) {
                            return           Row(
                              children: [
                                Text("type: "),
                                Text(" Credit(+)"),
                                Expanded(child: Radio(
                                  value: "credit",
                                  groupValue: Transaction,
                                  onChanged: (value) {
                                    Transaction = value!;
                                    type = "credit";
                                    setState(() {});
                                    setState1(() {});
                                  },
                                )),
                                Text("debit(-)"),
                                Expanded(child: Radio(
                                  value: "debit",
                                  groupValue: Transaction,
                                  onChanged: (value) {
                                    Transaction = value!;
                                    type = "debit";
                                    setState(() {});
                                    setState1(() {});

                                  },
                                ))
                              ],
                            );
                          },),
                          TextField(
                            controller: t2,
                            decoration: InputDecoration(
                              labelText: "Amount",
                            ),
                          ),
                          TextField(
                            controller: t3,
                            decoration: InputDecoration(
                              labelText: "Particular",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.deepPurple,
                                            width: 2)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    String credit;
                                    String debit;
                                    if (type == "credit") {
                                      credit = t2.text;
                                      debit = "-";
                                    } else {
                                      debit = t2.text;
                                      credit = "-";
                                    }
                                    String name = t3.text;
                                    String sql =
                                        "INSERT INTO entry VALUES(null,'${widget.m['id']}','${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}','$credit','$debit','$name')";
                                    dashboard.database
                                        ?.rawInsert(sql)
                                        .then((value) {
                                    });
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    height: 40,
                                    width: double.infinity,
                                    child: Text("Save",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(20),
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
                  setState(() {});
                },
                icon: Icon(Icons.add_box_rounded)),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.search)
          ],
        ),
        body: FutureBuilder(
          future: get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              print(view);
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Text("Date",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                    Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Text("Particular",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                    Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Text("Credit($set_currency)",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                    Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Text("Debit($set_currency)",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ],
                ),
                Expanded(
                    flex: 6,
                    child: Container(
                      child: FutureBuilder(
                        future: get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done||snapshot.connectionState == ConnectionState.active) {
                            return ListView.builder(
                              itemCount: view.length,
                              itemBuilder: (context, index) {
                                print(view);
                                return Card(
                                  child: ListTile(
                                    title: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("${view[index]["Date"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                          Text("${view[index]["name"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                          Text("${view[index]["credit"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                          Text("${view[index]["dabit"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                        ]),
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                    "Credit(↑)\n  $set_currency${(c[0]['SUM(credit)']!=null)?c[0]['SUM(credit)']:"0"}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black)),
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
                              ConnectionState.done) {
                            return Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 70,
                                child: Text(
                                    "Debit(↓) \n  $set_currency${(d[0]['SUM(dabit)']!=null)?d[0]['SUM(dabit)']:"0"}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
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
                              ConnectionState.done) {
                            return Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 70,
                                child: Text("Balance\n $set_currency${(total!=null)?total:"0"}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    ]),
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )), onWillPop: ()async {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return dashboard();
      },));
          return true;
        },);
  }
}
//credit[0]['sum(credit)']!=null &&debit[0]['sum(debit)']!=null ?
//credit[0]['sum(credit)']-debit[0]['sum(debit)']
