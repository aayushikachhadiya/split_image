import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgpic;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: image_puzzel(),
    debugShowCheckedModeBanner: false,
  ));
}

class image_puzzel extends StatefulWidget {
  const image_puzzel({super.key});

  @override
  State<image_puzzel> createState() => _image_puzzelState();
}

class _image_puzzelState extends State<image_puzzel> {
  List<imgpic.Image> mylist = [];
  List mylist1 = [];
  List l = [];
  List temp = List.filled(9, true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFileFromAssets("myasset/nature.jpg").then((value) {
      final image = imgpic.decodeJpg(value.readAsBytesSync());
      mylist = splitImage(image!, 3, 3);

      for (int i = 0; i < mylist.length; i++) {
        mylist1.add(imgpic.encodeJpg(mylist[i]));
      }
      l.addAll(mylist1);
      print(l);
      print(mylist1);
      mylist1.shuffle();
      setState(() {});
    });
  }

  List<imgpic.Image> splitImage(imgpic.Image inputImage,
      int horizontalPieceCount, int verticalPieceCount) {
    imgpic.Image image = inputImage;
    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<imgpic.Image>.empty(growable: true);
    var x = 0, y = 0;
    for (int i = 0; i < horizontalPieceCount; i++) {
      for (int j = 0; j < verticalPieceCount; j++) {
        pieceList.add(imgpic.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      x = 0;
      y = y + pieceHeight;
    }
    return pieceList;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  Widget build(BuildContext context) {
    double tot_width = MediaQuery.of(context).size.width;
    double con_width = (tot_width - 20) / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text("image puzzel game"),
        backgroundColor: Colors.pink.shade50,
      ),
      body: GridView.builder(
        itemCount: mylist.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          // Uint8List test=img.encodeJpg(mylist[index]);
          return (temp[index])
              ? Draggable(
                  data: index,
                  onDraggableCanceled: (velocity, offset) {
                    temp = List.filled(9, true);
                    setState(() {});
                  },
                  onDragStarted: () {
                    temp = List.filled(9, false);
                    temp[index] = true;
                    setState(() {});
                  },
                  child: Container(
                    height: con_width,
                    width: con_width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: MemoryImage(mylist1[index]))),
                  ),
                  feedback: Container(
                    height: con_width,
                    width: con_width,
                    decoration: BoxDecoration(
                        image:
                            DecorationImage(fit: BoxFit.fill,image: MemoryImage(mylist1[index]))),
                  ))
              : DragTarget(
                  onAccept: (data) {
                    temp = List.filled(9, true);
                    var c = mylist1[data as int];
                    mylist1[data as int] = mylist1[index];
                    mylist1[index] = c;
                    print(l);
                    print(mylist1);
                    if (listEquals(mylist1, l)) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("You ar win"),
                          );
                        },
                      );
                      print("heloo");
                    }
                    setState(() {});
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: con_width,
                      width: con_width,
                      decoration: BoxDecoration(image: DecorationImage(image: MemoryImage((mylist1[index])))),
                    );
                  },
                );
        },
      ),
    );
  }
}
