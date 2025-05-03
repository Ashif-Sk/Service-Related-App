import 'dart:io';
import 'dart:math';

import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/contractor_model.dart';
import 'package:contrador/models/user_model.dart';
import 'package:contrador/services/contractor_services.dart';
import 'package:contrador/services/user_services.dart';
import 'package:contrador/view/Publish%20Job/upload_photo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class JobPublishPage extends StatefulWidget {
  final String categoryName;
  final List<String> subCategoryList;

  const JobPublishPage(
      {super.key, required this.categoryName, required this.subCategoryList});

  @override
  State<JobPublishPage> createState() => _JobPublishPageState();
}

class _JobPublishPageState extends State<JobPublishPage> {
  final UiComponents _uiComponents = UiComponents();
  final ContractorServices _contractorServices = ContractorServices();
  final UserServices _userServices = UserServices();
  // late UserModel? _userModel;
  final Random _random = Random();
  final String _userID = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController nameController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<String> _list = [];
  String _subcategoryValue = 'Select';
  final List<String> _pricingModelList = ['Hour', 'Day', 'Fixed', 'Not Fixed'];
  String _pricingModelValue = 'Hour';
  final List<String> optionsList = ['Door', 'Away'];
  String optionValue = 'Door';
  String _profileImage = '';
  Position? _contractorPosition;
  String? _contactorAddress;
  final  _formKey = GlobalKey<FormState>();

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
  void initState()  {
    _list = widget.subCategoryList;
    _subcategoryValue = _list[0];
    _addressController.text = 'Get current location';
    // _userModel =  _userServices.getUserDetails(_userID) as UserModel?;
    // _profileImage = _userModel!.imagePath;
    // nameController.text = _userModel!.name;
    // phoneNumberController.text = _userModel!.phone;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    serviceNameController.dispose();
    phoneNumberController.dispose();
    priceController.dispose();
    _addressController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: _uiComponents.headline2(widget.categoryName),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
              10.verticalSpace,
              Row(
                children: [
                  _profileImage == ''?Container(
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
                            image: FileImage(File(_profileImage)),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.35)),
                  ),
                  30.horizontalSpace,
                  NormalMaterialButton(
                      text: 'Change picture',
                      onPressed: () {
                        _uiComponents.mediaBottomSheet(
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
                ],
              ),
              10.verticalSpace,
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (name){
                  if(name!.trim().isEmpty){
                    return 'Enter username';
                  } else if(name.trim().length <= 6){
                    return 'Must be more then 6 char';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'change your username',
                    labelText: 'Username*',
                    hintStyle: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 35.rt, fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: TextStyle(
                            fontSize: 36.rt, fontWeight: FontWeight.normal)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),

              ),
              8.verticalSpace,
              TextFormField(
                maxLength: 10,
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
                            fontSize: 35.rt, fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: TextStyle(
                            fontSize: 36.rt, fontWeight: FontWeight.normal)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.number,
              ),
              3.verticalSpace,
              TextFormField(
                maxLength: 60,
                controller: serviceNameController,
                validator: (serviceName){
                  if(serviceName!.trim().isEmpty){
                    return 'Enter business name';
                  } else if(serviceName.trim().length <= 6){
                    return 'Must be more then 6 char';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'enter valid business name',
                    labelText: 'Business name*',
                    hintStyle: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 35.rt, fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: TextStyle(
                            fontSize: 36.rt, fontWeight: FontWeight.normal)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.text,
              ),
              3.verticalSpace,
              DropdownButtonFormField(
                  style: GoogleFonts.abel(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 35.rt,
                          fontWeight: FontWeight.bold)),
                  dropdownColor: Theme.of(context).colorScheme.tertiary,
                  decoration: InputDecoration(
                      labelText: 'Subcategory*',
                      labelStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                              fontSize: 36.rt, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  value: _subcategoryValue,
                  items: _list.map<DropdownMenuItem>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _subcategoryValue = newValue;
                    });
                  }),
              8.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      textInputAction: TextInputAction.next,
                      validator: (cost){
                        if(cost!.trim().isEmpty){
                          return 'Enter service cost';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'enter estimated cost',
                          labelText: 'Service cost*',
                          hintStyle: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  fontSize: 35.rt, fontWeight: FontWeight.w500)),
                          labelStyle: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  fontSize: 36.rt,
                                  fontWeight: FontWeight.normal)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  30.horizontalSpace,
                  Expanded(
                    child: DropdownButtonFormField(
                        style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 35.rt,
                                fontWeight: FontWeight.bold)),
                        dropdownColor: Theme.of(context).colorScheme.tertiary,
                        decoration: InputDecoration(
                            labelText: 'Per*',
                            labelStyle: GoogleFonts.acme(
                                textStyle: TextStyle(
                                    fontSize: 36.rt,
                                    fontWeight: FontWeight.normal)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        value: _pricingModelValue,
                        items: _pricingModelList.map<DropdownMenuItem>((value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _pricingModelValue = newValue;
                          });
                        }),
                  ),
                ],
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
                      validator: (address){
                        if(address!.isEmpty){
                          return 'Get current location';
                        } else if(address == 'Get current location'){
                          return 'Get current location';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: '',
                          labelText: 'Address*',
                          hintStyle: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  fontSize: 35.rt, fontWeight: FontWeight.w500)),
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
                    // width: double.maxFinite,
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
                      height: height * 0.065, width: 0.4, icon: Icons.location_on,),
                  ),
                  8.verticalSpace,
                ],
              ),
              8.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLength: 2,
                      controller: experienceController,
                      textInputAction: TextInputAction.next,
                      validator: (experience){
                        if(experience!.trim().isEmpty){
                          return 'Enter experience';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'enter your experience',
                          labelText: 'Experience(years)*',
                          hintStyle: GoogleFonts.abel(
                              textStyle: TextStyle(
                                  fontSize: 35.rt, fontWeight: FontWeight.w500)),
                          labelStyle: GoogleFonts.acme(
                              textStyle: TextStyle(
                                  fontSize: 36.rt,
                                  fontWeight: FontWeight.normal)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  30.horizontalSpace,
                  Expanded(
                    child: DropdownButtonFormField(
                        style: GoogleFonts.abel(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 35.rt,
                                fontWeight: FontWeight.bold)),
                        dropdownColor: Theme.of(context).colorScheme.tertiary,
                        decoration: InputDecoration(
                            labelText: 'Options*',
                            labelStyle: GoogleFonts.acme(
                                textStyle: TextStyle(
                                    fontSize: 36.rt,
                                    fontWeight: FontWeight.normal)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                        value: optionValue,
                        items: optionsList.map<DropdownMenuItem>((value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            optionValue = newValue;
                          });
                        }),
                  ),
                ],
              ),
              3.verticalSpace,
              TextFormField(
                maxLines: 3,
                maxLength: 1000,
                controller: descriptionController,
                // textInputAction: TextInputAction.next,
                validator: (description){
                  if(description!.trim().isEmpty){
                    return 'Enter service description';
                  } else if(description.trim().length <= 10){
                    return 'Must be more than 10 char';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'clearly describe your service',
                    labelText: 'Description*',
                    hintStyle: GoogleFonts.abel(
                        textStyle: TextStyle(
                            fontSize: 35.rt, fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: TextStyle(
                            fontSize: 36.rt, fontWeight: FontWeight.normal)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 20,
              ),
              // const Spacer(),
              UniversalButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await _contractorServices.addServiceDetails(ContractorModel(
                          contractorId: _userID,
                          serviceId: _random.nextInt(100000000).toString(),
                          name: nameController.text.toString(),
                          phone: phoneNumberController.text.toString(),
                          businessName: serviceNameController.text.toString(),
                          subcategory: _subcategoryValue.toLowerCase(),
                          cost: priceController.text.toString(),
                          pricingModel: _pricingModelValue,
                          address: _addressController.text.toString(),
                          latitude: _contractorPosition!.latitude,
                          longitude: _contractorPosition!.longitude,
                          experience: experienceController.text.toString(),
                          option: optionValue,
                          description: descriptionController.text.toString(),
                          profileImage: _profileImage,
                          imagePaths: [],
                          rating: 0,
                          totalRatings: 0,
                          timeStamp: DateTime.now()));
                      Flexify.go(const UploadPhotoPage(),
                          animation: FlexifyRouteAnimations.slide,
                          animationDuration: const Duration(milliseconds: 500));
                    }
                  },
                  buttonText: "NEXT"),
              10.verticalSpace
            ],
          ),
        ));
  }
}
