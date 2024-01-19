import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class transactions extends StatefulWidget {
// String ?id;
// String ?name;
// transactions([this.id,this.name]);
  static Database? data;

  @override
  State<transactions> createState() => _transactionsState();
}


class _transactionsState extends State<transactions> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  String? dt;
  String Transaction="";
  String T="";
List view=[];
  @override
  initState()  {
    // TODO: implement initState
    super.initState();
   t1.text= "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    print(dt);

    // print(widget.name);
    get();

  }
  get()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    transactions.data = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db
              .execute('CREATE TABLE entry (id INTEGER PRIMARY KEY,account id INTEGER,Date Text,credit INTEGER,dabit INTEGER,name Text)');
        });
    String sel = "SELECT * FROM entry";
    view = await transactions.data!.rawQuery(sel);
    print(view);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text("${widget.name}",style: TextStyle(color: Colors.white,fontSize: 20)),
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
                              child: Text("Add transaction",style: TextStyle(fontSize: 20,color: Colors.white)),
                        )),
                        TextField(
                          controller: t1,
                          decoration: InputDecoration(
                            labelText: "Transaction Date",
                          ),
                        ),
                        Row(children: [
                          Text("type: "),
                          Text(" Credit(+)"),
                          Radio(value: "credit", groupValue: Transaction, onChanged: (value) {
                            Transaction=value!;
                          },),
                          Text("debit(-)"),
                          Radio(value: "debit", groupValue: T, onChanged: (value) {
                            T=value!;
                          },),
                        ],),
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
                                          color: Colors.deepPurple, width: 2)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(onTap: () {
                                String amount = t2.text;
                                String name = t3.text;
                                String sql =
                                "INSERT INTO entry VALUES(null,'0','0','$amount','$amount','$name')".toString();
                                print(sql);
                                transactions.data
                                    ?.rawInsert(sql)
                                    .then((value) {
                                  print(value);
                                });
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
                                          color: Colors.deepPurple, width: 2)),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  },
                );
                setState(() {

                });
              },
              icon: Icon(Icons.add_box_rounded)),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search)
        ],
      ),
      body: Column(children: [
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
              child: Text("Credit(₹)",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            )),
            Expanded(
                child: Container(
              color: Colors.grey.shade200,
              child: Text("Debit(₹)",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            )),
          ],
        )
      ]),
    );
  }
}
