// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:split_image/password.dart';
//
// void main() {
//   runApp(MaterialApp(debugShowCheckedModeBanner: false,
//     home: account_manager(),
//   ));
// }
//
// class account_manager extends StatefulWidget {
//   static SharedPreferences ?prefs;
//
//   @override
//   State<account_manager> createState() => _account_managerState();
// }
//
// class _account_managerState extends State<account_manager> {
//   TextEditingController t1 = TextEditingController();
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     new Future.delayed(Duration.zero, () {
//       showDialog(barrierColor: Colors.transparent,context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("Set password", style: TextStyle(fontSize: 20)),
//               actions: [
//                 TextField(
//                   controller: t1,
//                 ),
//                 SizedBox(height: 10,),
//                 Expanded(
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
//                     Container(alignment: Alignment.center,
//                       height: 50,
//                       width: 70,
//                       decoration: BoxDecoration(
//                           color: Colors.deepPurple,
//                           border: Border.all(width: 1),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Text("Cancle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
//                     ),
//                     InkWell(onTap: () {
//                       account_manager.prefs!.setString("set", t1.text);
//                       if(t1.text!="")
//                         {
//                           Navigator.push(context, MaterialPageRoute(builder: (context) {
//                             return password();
//                           },));
//                         }else
//                           {
//                             showDialog(context: context, builder: (context) {
//                               return AlertDialog(title: Text("pelese set password"),);
//                             },);
//                           }
//                       setState(() {
//                       });
//                     },
//                       child: Container(alignment: Alignment.center,
//                         height: 50,
//                         width: 70,
//                         child: Text("Set",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
//                         decoration: BoxDecoration(
//                             color: Colors.deepPurple,
//                             border: Border.all(width: 1),
//                             borderRadius: BorderRadius.circular(10)),
//                       ),
//                     )
//                   ],),
//                 )
//
//               ],
//             );
//           });
//     });
//     get();
//   }
// get()
// async {
//   account_manager.prefs = await SharedPreferences.getInstance();
//   String set_password=account_manager.prefs!.getString("set") ?? "";
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Account manager"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.fill, image: AssetImage("myasset/splash.png"))),
//       ),
//     );
//   }
// }
