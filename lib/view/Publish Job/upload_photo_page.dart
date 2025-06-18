import 'dart:io';

import 'package:contrador/components/ui_components.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final UiComponents _uiComponents = UiComponents();
  List<XFile?> file = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: _uiComponents.headline2('Upload Images',Theme.of(context).colorScheme.tertiary),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              file.isEmpty
                  ? Container(
                alignment: Alignment.center,
                      height: 250,
                      width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Icon(Icons.photo_library_outlined,size: 45,)
                    )
                  : SizedBox(
                      height: 250,
                      child: CarouselView(
                          itemSnapping: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.black,
                          itemExtent: 400,
                          children: file.map((image) {
                            return SizedBox(
                              height: 200,
                              width: double.maxFinite,
                              child:Image.file(
                                      File(image!.path),
                                      fit: BoxFit.contain,
                                    ),
                            );
                          }).toList()),
                    ),
              8.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: NormalMaterialButton(
                    text: 'Open Camera',
                    onPressed: () {
                      _openCamera();
                    }),
              ),
              8.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: NormalMaterialButton(
                    text: 'Upload images',
                    onPressed: () {
                      _pickImages();
                    }),
              ),
              10.verticalSpace,
              const Spacer(),
              UniversalButton(onPressed: () {}, buttonText: 'Publish'),
              10.verticalSpace,
            ],
          ),
        ));
  }

  Future<List<XFile?>> _pickImages() async {
    ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage(
      limit: 4,
    );
    setState(() {
      file.addAll(images);
    });
    return file;
  }

  Future<List<XFile?>> _openCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      file.add(image);
    });
    return file;
  }


}
