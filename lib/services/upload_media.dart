import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

class UploadMedia{
  File? newImage ;

  XFile? image ;
  List<XFile>? files = [];

  final picker = ImagePicker();

  Future pickFromGallery ({required bool isSingleImage})async{

    if(isSingleImage){
      image = (await picker.pickImage(source: ImageSource.gallery))!;

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        image!.path,
        targetPath,
        minHeight: 600, //you can play with this to reduce siz
        minWidth: 600,
        quality: 50, // keep this high to get the original quality of image
      );
      // newImage = File(result!.path) ;

      return result;
    }

    files = await picker.pickMultiImage(
      // limit: 4,
    );

    if(files == null || files!.isEmpty) return [];

    final List<XFile> compressedFiles = [] ;

    for( XFile file in files!){
      File originalFile = File(file.path);
      final bytes = await originalFile.readAsBytes();
      final kb = bytes.length / 1024;
      final mb = kb / 1024;

      if (kDebugMode) {
        print('original image size:$mb');
      }
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        minHeight: 600, //you can play with this to reduce siz
        minWidth: 600,
        quality: 50, // keep this high to get the original quality of image
      );
      compressedFiles.add(result!);

      final data = await result.readAsBytes() ;
      final newKb = data.length / 1024;
      final newMb = newKb / 1024;

      print('compress image size:$newMb');
    }
    return compressedFiles;
    }

Future<XFile> openCamera () async {
  ImagePicker picker = ImagePicker();
  image = await picker.pickImage(source: ImageSource.camera);
  final dir = await path_provider.getTemporaryDirectory();
  final targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  final result = await FlutterImageCompress.compressAndGetFile(
    image!.path,
    targetPath,
    minHeight: 600, //you can play with this to reduce siz
    minWidth: 600,
    quality: 50, // keep this high to get the original quality of image
  );
  newImage = File(result!.path) ;

  return result;
}

  Future uploadImageToCloudinary({required bool isSingleImage, XFile? imageFile, List<XFile>? imagesList}) async {
    const cloudName = 'dcycfdhjc'; // replace
    const uploadPreset = 'profile'; // replace
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    if(isSingleImage){
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
        return json['secure_url']; // image URL
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    }

    List<String> urlList= [];
    for(XFile value in imagesList! ) {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', value.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resStr = await response.stream.bytesToString();
        final json = jsonDecode(resStr);
         urlList.add(json['secure_url']); // image URL
      } else {
        print('Upload failed: ${response.statusCode}');
      }
    }
    return urlList;
  }

  // void upload() async {
  //   final imageFile = await imagePickerFromGallery();
  //   // if (imageFile != null) {
  //   //   final url = await uploadImageToCloudinary(imageFile);
  //   //   print("Uploaded Image URL: $url");
  //   // }
  // }


}