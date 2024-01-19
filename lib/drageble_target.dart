import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: image_split(),
    debugShowCheckedModeBanner: false,
  ));
}

class image_split extends StatefulWidget {
  const image_split({super.key});

  @override
  State<image_split> createState() => _image_splitState();
}

class _image_splitState extends State<image_split> {
  List l=['A','B','C','D','E','F','G','H','I'];
  List  temp=List.filled(9, true);
  List list1=[];
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    list1.addAll(l);
    l.shuffle();
  }
  @override
  Widget build(BuildContext context) {
    double tot_width=MediaQuery.of(context).size.width;
    double con_width=(tot_width-20)/3;
    return Scaffold(
      appBar: AppBar(
        title: Text("puzzel game"),
        backgroundColor: Colors.pink.shade50,
      ),
      body: GridView.builder(itemCount: l.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            return (temp[index])?Draggable(data: index,onDraggableCanceled: (velocity, offset) {
              temp=List.filled(9, true);
              setState(() {

              });
            },onDragStarted: () {
              temp=List.filled(9, false);
              temp[index]=true;
              setState(() {
              });
            },child:  Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Text("${l[index]}",style: TextStyle(fontSize: 30)),
            ), feedback:  Container(
              width: con_width,
              height: con_width,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text("${l[index]}",style: TextStyle(fontSize: 30)),
            )):DragTarget(onAccept: (data) {
              temp=List.filled(9, true);
              var c=l[data as int];
              l[data as int]=l[index];
              l[index]=c;
              if(listEquals(l, list1))
                {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(title: Text("You ar win"),);
                  },);
                }
              setState(() {
              });
            }, builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                return Container(
                  width: con_width,
                  height: con_width,
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: Text("${l[index]}",style: TextStyle(fontSize: 30)),
                );
            },);
          },),
    );
  }
}
