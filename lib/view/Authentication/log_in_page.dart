import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/view/Authentication/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/ui_components.dart';
import '../../services/google_services.dart';
import 'forgot_pass_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final GoogleServices _googleServices = GoogleServices();
  final UiComponents _uiComponents = UiComponents();
  String? user;
  bool _isVisible = false;

  Future login(email, password) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user!.uid;
    } on FirebaseAuthException {
      _uiComponents.errorDialog('Invalid email or password.Please try again', context);
    }

  }

  Future addUserDetails(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(user).set({'email': email, 'uid': user});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              25.verticalSpace,
              const BigImage(imagePath: 'images/signIn.png'),
              25.verticalSpace,
              TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.alternate_email),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                    hintText: 'enter email',
                    labelText: 'Email',
                    hintStyle: GoogleFonts.abel(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              10.verticalSpace,
              TextFormField(
                controller: passwordcontroller,
                obscureText: !_isVisible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIconColor: !_isVisible?Colors.grey:Colors.grey.shade700,
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        child: _isVisible
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined)),
                    hintText: 'Enter password',
                    labelText: 'Password',
                    hintStyle: GoogleFonts.abel(
                        textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    labelStyle: GoogleFonts.acme(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              NormalTextButton(onPressed:  () {
                Flexify.go(const ForgotPasswordPage(),
                    animation: FlexifyRouteAnimations.slideFromBottom,
                    animationDuration: const Duration(milliseconds: 300));
              },
                  buttonText: 'Forgot Password?', extraText: ''),
              // 5.verticalSpace,
              UniversalButton(
                  onPressed: () {
                    login(emailcontroller.text.trim(),
                        passwordcontroller.text.trim());
                  },
                  buttonText: 'LOG IN'),
              NormalTextButton(
                onPressed: () {
                  Flexify.goRemove(
                      const SignUpPage(),
                      animation: FlexifyRouteAnimations.slideFromBottom,
                      duration: const Duration(milliseconds: 300)
                  );
                },
                buttonText: 'Sign Up',
                extraText: "Don't have an account?",
              ),
              //10.verticalSpace,
              BigOutlineButton(
                  onPressed: () => _googleServices.googleSignIn(),
                  buttonText: 'Continue with Google',
                  image: 'images/google.png',),
            ],
          ),
        ),
      ),
    );
  }
}
