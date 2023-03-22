import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  processImageForConversion(inputImage) async {
    setState(() {
      outputText = "";
    });

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    for (TextBlock block in recognizedText.blocks) {
      setState(() {
        outputText += block.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image to Text")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage(ImageSource.gallery, pickedImage);
        },
        child: const Icon(Icons.image),
      ),
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
          ]),
        ),
      ),
    );
  }
}
