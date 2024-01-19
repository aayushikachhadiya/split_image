import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: demo(), debugShowCheckedModeBanner: false,));
}

class demo extends StatefulWidget {
  const demo({super.key});

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  List myList = [];

  List<img.Image> splitImage(img.Image inputImage, int horizontalPieceCount,
      int verticalPieceCount) {
    img.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<img.Image>.empty(growable: true);
    var x = 0,
        y = 0;
    for (var y = 0; y < horizontalPieceCount; y++) {
      for (var x = 0; x < verticalPieceCount; x++) {
        pieceList.add(img.copyCrop(
            image, x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      y = y + pieceHeight;
    }

    return pieceList;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFileFromAssets("myasset/nature.jpg").then((value) {
      final image = img.decodeJpg(File('test.jpg').readAsBytesSync());
      myList = splitImage(image!, 3, 3);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double tot_width=MediaQuery.of(context).size.width;
    double con_width=(tot_width-20)/3;
    return Scaffold(appBar:
    AppBar(title: Text("demo image"),),
        body: GridView.builder(itemCount: myList.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount
        : 3, crossAxisSpacing: 5, mainAxisSpacing: 5), itemBuilder
    :
    (context, index) {
      Uint8List test=img.encodeJpg(myList[index]);
      return Container(
        width: con_width,
        height: con_width,
        alignment: Alignment.center,
        decoration: BoxDecoration( color: Colors.green,
            image: DecorationImage(
                image: MemoryImage(test),fit: BoxFit.fill
            )
        ),
      );
    },
    )
    ,
    );
  }
}
