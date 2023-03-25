import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Image To Text',
            builder: EasyLoading.init(),
            home: const ImageToText(),
          );
        });
  }
}

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToTextState();
}

class _ImageToTextState extends State<ImageToText> {
  File? _pickedImage;
  String outputText = "";

  pickedImage(File file) {
    setState(() {
      _pickedImage = file;
    });

    InputImage inputImage = InputImage.fromFile(file);
    //code to recognize image
    processImageForConversion(inputImage);
  }

//   processImageForConversion(inputImage) async {
//   setState(() {
//     outputText = "";
//   });

//   final textRecognizer = TextRecognizer();
//   final RecognizedText recognizedText =
//       await textRecognizer.processImage(inputImage);

//   for (TextBlock block in recognizedText.blocks) {
//     final List<Point<int>> cornerPoints = block.cornerPoints;
//     final String blockText = block.text;
//     final List<String> languages = block.recognizedLanguages;

//     for (TextLine line in block.lines) {
//       // Same getters as TextBlock
//       String lineText = line.text;

//       // Check for whitespace characters before and after the line
//       String prefix = blockText.substring(0, line.rect.left.toInt() - block.rect.left.toInt());
//       String suffix = blockText.substring(line.rect.right.toInt() - block.rect.left.toInt());

//       // Append the prefix, line text, and suffix to the output text
//       setState(() {
//         outputText += prefix + lineText + suffix;
//       });
//     }
//   }

//   print(outputText);
// }

  processImageForConversion(inputImage) async {
    setState(() {
      outputText = "";
    });

    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      setState(() {
        // print(block.text);
        outputText += "${block.text}\n";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image to Text")),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.deepPurpleAccent,
        activeForegroundColor: Colors.white,
        spacing: 15,
        spaceBetweenChildren: 8,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes

        elevation: 8.0, //shadow elevation of button
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.image),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,

            onTap: () {
              pickImage(ImageSource.gallery, pickedImage);
            },
            // onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.qrcode),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     pickImage(ImageSource.gallery, pickedImage);
      //   },
      //   child: const Icon(Icons.image),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(children: [
            8.h.heightBox,
            if (_pickedImage == null)
              Container()
            else
              Image.file(
                _pickedImage!,
                fit: BoxFit.fill,
              ),
            8.h.heightBox,
            const Divider(),
            10.h.heightBox,
            Text(
              outputText,
              softWrap: true,
              style: TextStyle(fontFamily: 'Times New Roman', fontSize: 16.sp),
            ),
            80.h.heightBox,
          ]),
        ),
      ),
    );
  }
}
