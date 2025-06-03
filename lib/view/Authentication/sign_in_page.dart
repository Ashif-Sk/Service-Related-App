import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/user_model.dart';
import 'package:contrador/services/user_services.dart';
import 'package:contrador/view/Authentication/forgot_pass_page.dart';
import 'package:contrador/view/Authentication/log_in_page.dart';
import 'package:contrador/view/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/ui_components.dart';
import '../../services/google_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final GoogleServices _googleServices = GoogleServices();
  final UiComponents _uiComponents = UiComponents();
  final UserServices _userServices = UserServices();
  String userId = '';

  final _formKey = GlobalKey<FormState>();

  Future signup(email, password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userId = userCredential.user!.uid;
      _userServices.addUserDetails(UserModel(
          userId: userId,
          name: namecontroller.text.trim(),
          phone: '',
          email: emailcontroller.text.trim(),
          imagePath: '',
          address: '',
          latitude: 0.0,
          longitude: 0.0,
          gender: ''), userId);
    } on FirebaseAuthException catch (e) {
      _uiComponents.errorDialog(e.message.toString(), context);
    }

    Flexify.goRemoveAll(
        const BottomNavBar(initialPage: 0,),
      animation: FlexifyRouteAnimations.slide,
      duration: const Duration(milliseconds: 500)
    );
    }

  // Future addUserDetails(String email, String name) async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   await users.doc(userId).set({'email': email, 'name': name, 'uid': userId});
  // }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                25.verticalSpace,
                const BigImage(imagePath: 'images/signIn.png'),
                20.verticalSpace,
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: namecontroller,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Enter username';
                    } else if (name.trim().length <= 6){
                      return 'Must be more than 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person,),
                      hintText: 'enter username',
                      labelText: 'Username',
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
                10.verticalSpace,
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_rounded),
                      hintText: 'enter valid email',
                      labelText: 'Email',
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
                10.verticalSpace,
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: passwordcontroller,
                  obscureText: true,
                  validator: (pass){
                    if(pass!.isEmpty){
                      return 'Enter a password';
                    } else if (pass.trim().length <= 6){
                      return 'Must be more than 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'enter strong password',
                      labelText: 'Password',
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
                ),
                10.verticalSpace,
                TextFormField(
                  controller: confirmpasswordcontroller,
                  obscureText: true,
                  validator: (pass) {
                    if (pass != passwordcontroller.text) {
                      return 'Not matched';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 're-enter password',
                      labelText: 'Confirm',
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
                ),
                NormalTextButton(
                    onPressed: () {
                      Flexify.go(const ForgotPasswordPage(),
                          animation: FlexifyRouteAnimations.slideFromBottom,
                          animationDuration: const Duration(milliseconds: 300));
                    },
                    buttonText: 'Forgot Password?',
                    extraText: ''),
                UniversalButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signup(emailcontroller.text.trim(),
                            passwordcontroller.text.trim(), context);
                      }
                    },
                    buttonText: 'SIGN UP'),
                NormalTextButton(
                  onPressed: () {
                    Flexify.go(const LogInPage(),
                        animation: FlexifyRouteAnimations.slideFromBottom,
                        animationDuration: const Duration(milliseconds: 300));
                  },
                  buttonText: 'Log in',
                  extraText: "Already have an account?",
                ),
                BigOutlineButton(
                  onPressed: () => _googleServices.googleSignIn(),
                  buttonText: 'Continue with Google',
                  image: 'images/google.png',
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
