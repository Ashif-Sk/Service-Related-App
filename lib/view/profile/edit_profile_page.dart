import 'dart:io';

import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/ui_components.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UiComponents uiComponents = UiComponents();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  String _profileImage = '';
  final List<String> _genderList = ['Male','Female','Others'];
  String _gender = 'Male';

  Future<XFile?> _pickImages() async {
    ImagePicker picker = ImagePicker();
    XFile? images = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = images!.path;
    });
    return images;
  }
  Future<XFile?> _openCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _profileImage = image!.path;
    });
    return image;
  }

  @override
  void initState() {

    super.initState();
    // final database = Provider.of<Databasemodel>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    // if (database.userData != null) {
    //   nameController.text = database.userData!['name'] ?? '';
    //   phoneNumberController.text = database.userData!['number']?? '';
    //   pinCodeController.text = database.userData!['pin']?? '';
    //   stateController.text = database.userData!['state']?? '';
    //   emailController.text = database.userData!['email']?? '';
    //   genderController.text = database.userData!['gender']?? '';
    // }
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: uiComponents.headline2('Edit Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Divider(
                  thickness: 0.4,
                  color: Theme.of(context).colorScheme.primary,
                ),
                4.verticalSpace,
                _profileImage == ''? Container(
                  height: height * 0.12,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.35)),
                  child: const Icon(Icons.photo_outlined,size: 30,),
                ):Container(
                  height: height * 0.12,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(_profileImage),),
                          fit: BoxFit.cover,),
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.35),),
                ),
                4.verticalSpace,
                uiComponents.headline2('Sk Ashif Mostafa'),
                8.verticalSpace,
                NormalMaterialButton(text: 'Change picture',
                    onPressed: (){
                      uiComponents.mediaBottomSheet(
                          context,
                          height * 0.17,
                              null,
                              (){
                            _openCamera();
                            Flexify.back();
                          },
                              (){
                            _pickImages();
                            Flexify.back();
                          },
                          (){}
                      );
                    }),
                20.verticalSpace,
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator: (name){
                    if(name!.trim().isEmpty){
                      return 'Enter username';
                    } else if(name.trim().length <= 6){
                      return 'Must be more then 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'enter your username',
                      labelText: 'Username*',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt,
                              fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt,
                              fontWeight: FontWeight.normal
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.name,
                ),
                8.verticalSpace,
                TextFormField(
                  controller: phoneNumberController,
                  textInputAction: TextInputAction.next,
                  validator: (number){
                    if(number!.trim().isEmpty){
                      return 'Enter mobile number';
                    } else if(number.trim().length < 10){
                      return 'Enter valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'enter a valid mobile number',
                      labelText: 'Mobile number*',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt,
                              fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt,
                              fontWeight: FontWeight.normal
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.number,
                ),
                8.verticalSpace,
                TextFormField(
                  readOnly: true,
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'enter a valid email',
                      labelText: 'Email*',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt,
                              fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt,
                              fontWeight: FontWeight.normal
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.emailAddress,
                ),
                8.verticalSpace,
                TextFormField(
                  controller: cityController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'enter city',
                      labelText: 'City',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt,
                              fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt,
                              fontWeight: FontWeight.normal
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.text,
                ),
                8.verticalSpace,
                TextFormField(
                  controller: stateController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'enter state',
                      labelText: 'State',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt,
                              fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt,
                              fontWeight: FontWeight.normal
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.number,
                ),
                8.verticalSpace,
                DropdownButtonFormField(
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 35.rt,
                            fontWeight: FontWeight.bold)),
                    dropdownColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                        labelText: 'Gender*',
                        labelStyle: GoogleFonts.acme(
                            textStyle: TextStyle(
                                fontSize: 36.rt, fontWeight: FontWeight.normal)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    value: _gender,
                    items: _genderList.map<DropdownMenuItem>((value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                // const Spacer(),
                UniversalButton(
                    onPressed: () {
                      // database.updateUserData(
                      //     nameController.text,
                      //     phoneNumberController.text.trim(),
                      //     emailController.text.trim(),
                      //     stateController.text,
                      //     pinCodeController.text.trim(),
                      //     genderController.text.trim());
                      if(_formKey.currentState!.validate()){
                        Flexify.back();
                      }
                    },
                    buttonText: "SAVE"),

              ],
            ),
          )
        ,),
    );
  }
}