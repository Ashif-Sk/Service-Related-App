import 'dart:io';

import 'package:contrador/models/user_model.dart';
import 'package:contrador/services/upload_media.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../components/ui_components.dart';
import '../../provider/user_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UiComponents _uiComponents = UiComponents();
  final UploadMedia _uploadMedia = UploadMedia();
  final UserProvider _userProvider = UserProvider();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _userId = FirebaseAuth.instance.currentUser!.uid;

  Position? _contractorPosition;
  String? _contactorAddress;
  XFile? _profileImage;
  String? _uploadedImageUrl;
  final List<String> _genderList = ['Male', 'Female', 'Others'];
  String _gender = 'Male';

  Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 100));
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      setState(() {
        _contactorAddress =
            "${place.locality}, ${place.postalCode}, ${place.administrativeArea}";
        _uiComponents.confirmationDialog(
            context, 'Confirm your address: $_contactorAddress', 'Yes', 'Retry',
            () {
          _addressController.text = _contactorAddress!;
          Flexify.back();
        }, () {
          _getAddressFromLatLng(position);
          Flexify.back();
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _userProvider.getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if (userProvider.userData != null) {
      final userData = userProvider.userData;
      nameController.text = userData!.name;
      phoneNumberController.text = userData.phone;
      _addressController.text = 'Get your location';
      emailController.text = userData.email;
      _gender = userData.gender;
      _uploadedImageUrl = userData.imagePath;
    }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: _uiComponents.headline2(
              'Edit Profile', Theme.of(context).colorScheme.tertiary),
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
                10.verticalSpace,
                if (_profileImage == null && _uploadedImageUrl!.isEmpty)
                  Container(
                    height: height * 0.12,
                    width: width * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.35),
                    ),
                    child: const Icon(Icons.add_photo_alternate_outlined,size: 35,),
                  ),
                if (_profileImage != null)
                  Center(
                    child: ClipOval(
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: height * 0.12,
                        width: width * 0.25,
                        color: Colors.blueGrey,
                        child: Image.file(
                          File(_profileImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (_uploadedImageUrl!.isNotEmpty)
                  Center(
                    child: ClipOval(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: height * 0.12,
                        width: width * 0.25,
                        color: Colors.blueGrey,
                        child: Image.network(
                          _uploadedImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                10.verticalSpace,
                NormalMaterialButton(
                    text: 'Change picture',
                    onPressed: () {
                      _uiComponents.confirmationDialog(
                          context,
                          "Note: You can only change your profile picture 2 times in a month",
                          "Cancel",
                          "OK", () {
                        Flexify.back();
                      }, () {
                        Flexify.back();
                        _uiComponents
                            .mediaBottomSheet(context, height * 0.17, null, () async {
                          _profileImage = await _uploadMedia.openCamera();
                          setState(() {
                          });
                          Flexify.back();
                        }, () async {
                          // _pickImages();
                          _profileImage = await _uploadMedia
                              .pickFromGallery(isSingleImage: true);
                          setState(() {});
                          Flexify.back();
                        }, () {});
                      });
                    }),
                20.verticalSpace,
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator: (name) {
                    if (name!.trim().isEmpty) {
                      return 'Enter username';
                    } else if (name.trim().length <= 6) {
                      return 'Must be more then 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter your username',
                      labelText: 'Username*',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.name,
                ),
                8.verticalSpace,
                TextFormField(
                  controller: phoneNumberController,
                  textInputAction: TextInputAction.next,
                  validator: (number) {
                    if (number!.trim().isEmpty) {
                      return 'Enter mobile number';
                    } else if (number.trim().length < 10) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter a valid mobile number',
                      labelText: 'Mobile number*',
                      hintStyle: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 35.rt, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt, fontWeight: FontWeight.normal)),
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
                              fontSize: 35.rt, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.emailAddress,
                ),
                8.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        validator: (address) {
                          if (address!.isEmpty) {
                            return 'Get current location';
                          } else if (address == 'Get current location') {
                            return 'Get current location';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: '',
                            labelText: 'Address*',
                            hintStyle: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    fontSize: 35.rt,
                                    fontWeight: FontWeight.w500)),
                            labelStyle: GoogleFonts.acme(
                                textStyle: TextStyle(
                                    fontSize: 36.rt,
                                    fontWeight: FontWeight.normal)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    30.horizontalSpace,
                    Expanded(
                      child: IconTextButton(
                        buttonText: 'Get location',
                        onPressed: () {
                          getUserLocation().then((position) {
                            setState(() {
                              _contractorPosition = position;
                            });
                            _getAddressFromLatLng(_contractorPosition!);
                          });
                        },
                        height: height * 0.065,
                        width: 0.4,
                        icon: Icons.location_on,
                      ),
                    ),
                    8.verticalSpace,
                  ],
                ),
                8.verticalSpace,
                DropdownButtonFormField(
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    dropdownColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                        labelText: 'Gender*',
                        labelStyle: GoogleFonts.acme(
                            textStyle: TextStyle(
                                fontSize: 36.rt,
                                fontWeight: FontWeight.normal)),
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
                      if (_formKey.currentState!.validate()) {
                        userProvider
                            .updateUserDetails(
                                UserModel(
                                    userId: _userId,
                                    name: nameController.text,
                                    phone: phoneNumberController.text,
                                    email: emailController.text,
                                    imagePath: _uploadedImageUrl!,
                                    gender: _gender,
                                    address: _addressController.text,
                                    latitude: _contractorPosition!.latitude,
                                    longitude: _contractorPosition!.longitude),
                                _userId)
                            .then((_) {
                          Flexify.back();
                        });
                      }
                    },
                    buttonText: "SAVE"),
              ],
            ),
          ),
        ));
  }
}
