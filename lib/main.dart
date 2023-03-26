import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
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
  // File? _pickedImage;
  String outputText = "";
  XFile? imageFile;

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      imageFile = null;
      outputText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    outputText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        outputText = "$outputText${line.text}\n";
      }
    }
    setState(() {});
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
        spaceBetweenChildren: 10,
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
              getImage(ImageSource.gallery);
            },
          ),
          SpeedDialChild(
            child: const Icon(FontAwesomeIcons.camera),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () {
              getImage(ImageSource.camera);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(children: [
            8.h.heightBox,
            if (imageFile == null)
              Container()
            else
              Image.file(
                File(imageFile!.path),
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
