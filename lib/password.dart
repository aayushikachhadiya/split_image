import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:split_image/dashboard.dart';
void main()
{
  runApp(MaterialApp(home: password(),debugShowCheckedModeBanner: false,));
}

class password extends StatefulWidget {
  static SharedPreferences ?prefs;

  const password({super.key});

  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  TextEditingController t1 = TextEditingController();
  String set_password="";
  String set_currency="";
  PinInputController pinInputController = PinInputController(length: 4);
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get()
  async {
    password.prefs = await SharedPreferences.getInstance();
   set_password=password.prefs!.getString("set") ?? "";
   set_currency=password.prefs!.getString("currency") ?? "";
    print(set_password);
    new Future.delayed(Duration.zero, () {
      if(set_password=="")
      {
        showDialog(barrierDismissible: false,barrierColor: Colors.transparent,context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Set password", style: TextStyle(fontSize: 20)),
                actions: [
                  TextField(
                    controller: t1,
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                      Container(alignment: Alignment.center,
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
                      ),
                      InkWell(onTap: () {
                        // Navigator.pop(context);
                        password.prefs!.setString("set", t1.text);
                        if(t1.text!="")
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return password();
                          },));
                          showCurrencyPicker(
                            context: context,
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                            onSelect: (Currency currency) {
                              print('Select currency: ${currency.symbol}');
                              password.prefs!.setString("currency", currency.symbol);
                              setState(() {

                              });
                            },
                          );

                        }else
                        {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(title: Text("pelese set password"),);
                          },);
                        }
                        setState(() {
                        });
                      },
                        child: Container(alignment: Alignment.center,
                          height: 50,
                          width: 70,
                          child: Text("Set",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold)),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],),
                  )

                ],
              );
            });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(child:  Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage("myasset/splash.png"))),
            child: Container(alignment: Alignment.center,
              decoration: BoxDecoration( color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.only(top: 70, bottom: 70,right: 20,left: 20),
              child: (set_password!="")?Text(""):PinPlusKeyBoardPackage(
                keyboardButtonShape: KeyboardButtonShape.circular,
                inputShape: InputShape.circular,
                keyboardMaxWidth: 70,
                inputHasBorder: false,
                inputFillColor: Colors.grey.shade50,
                inputElevation: 3,
                buttonFillColor: Colors.black,
                btnTextColor: Colors.white,
                spacing: 10,
                pinInputController: pinInputController,
                onSubmit: () {
                  /// ignore: avoid_print
                  print("Text is : " + pinInputController.text);
                  if(set_password==pinInputController.text)
                  {

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return dashboard();
                    },));
                    // showCurrencyPicker(
                    //   context: context,
                    //   showFlag: true,
                    //   showCurrencyName: true,
                    //   showCurrencyCode: true,
                    //   onSelect: (Currency currency) {
                    //     print('Select currency: ${currency.symbol}');
                    //     password.prefs!.setString("currency", currency.symbol);
                    //     get();
                    //     setState(() {
                    //
                    //     });
                    //   },
                    // );
                    print("currency");
                  }else
                  {
                    showDialog(barrierColor: Colors.transparent,context: context, builder: (context) {
                      return AlertDialog(
                        title: Text("wrong paasowrd"),
                      );
                    },);
                  }
                },
                keyboardFontFamily: '',
              ),
            )),)
    );
  }
}
