import 'dart:io';

import 'package:contrador/components/ui_components.dart';
import 'package:contrador/services/upload_media.dart';
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
  final UploadMedia _uploadMedia = UploadMedia();
   List<XFile?> _imagesList = [];

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
              _imagesList.isEmpty
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
                          children: _imagesList.map((image) {
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
                    onPressed: () async {
                      // _openCamera();
                      _imagesList.add(await _uploadMedia.openCamera());
                      setState(() {
                      });
                    }),
              ),
              8.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: NormalMaterialButton(
                    text: 'Upload images',
                    onPressed: () async {
                      // _pickImages();
                      _imagesList = await _uploadMedia.pickFromGallery(isSingleImage: false);
                      setState(() {

                      });
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

}
