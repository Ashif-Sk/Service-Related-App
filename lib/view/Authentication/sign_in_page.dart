import 'package:contrador/models/user_model.dart';
import 'package:contrador/services/user_services.dart';
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
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final GoogleServices _googleServices = GoogleServices();
  final UiComponents _uiComponents = UiComponents();
  final UserServices _userServices = UserServices();
  String userId = '';
  bool _isConditionChecked = true;
  bool _isVisible = false;

  final _formKey = GlobalKey<FormState>();

  Future signup(email, password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userId = userCredential.user!.uid;
      _userServices.addUserDetails(
          UserModel(
              userId: userId,
              name: _namecontroller.text.trim(),
              phone: '',
              email: _emailcontroller.text.trim(),
              imagePath: '',
              address: '',
              latitude: 0.0,
              longitude: 0.0,
              gender: ''),
          userId);
    } on FirebaseAuthException catch (e) {
      _uiComponents.errorDialog(e.message.toString(), context);
    }

    Flexify.goRemoveAll(
        const BottomNavBar(
          initialPage: 0,
        ),
        animation: FlexifyRouteAnimations.slide,
        duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _namecontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
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
                  controller: _namecontroller,
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Enter username';
                    } else if (name.trim().length <= 6) {
                      return 'Must be more than 6 char';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.primary,
                      hintText: 'Enter username',
                      labelText: 'Username',
                      hintStyle: GoogleFonts.abel(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.text,
                ),
                5.verticalSpace,
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.alternate_email_outlined),
                      prefixIconColor: Theme.of(context).colorScheme.primary,
                      hintText: 'Enter a valid email',
                      labelText: 'Email',
                      hintStyle: GoogleFonts.abel(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  keyboardType: TextInputType.emailAddress,
                ),
                5.verticalSpace,
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _passwordcontroller,
                  obscureText: !_isVisible,
                  validator: (pass) {
                    if (pass!.isEmpty) {
                      return 'Enter a password';
                    } else if (pass.trim().length <= 6) {
                      return 'Must be more than 6 char';
                    }
                    return null;
                  },
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
                      hintText: 'Enter strong password',
                      labelText: 'Password',
                      hintStyle: GoogleFonts.abel(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                5.verticalSpace,
                TextFormField(
                  controller: _confirmpasswordcontroller,
                  obscureText: true,
                  validator: (pass) {
                    if (pass != _passwordcontroller.text) {
                      return 'Not matched';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      prefixIconColor: Theme.of(context).colorScheme.primary,
                      hintText: 'Re-enter password',
                      labelText: 'Confirm',
                      hintStyle: GoogleFonts.abel(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      labelStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                5.verticalSpace,
                FittedBox(
                  child: SizedBox(
                    height: height * 0.05,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: _isConditionChecked,
                            onChanged: (value) {
                              setState(() {
                                _isConditionChecked = value!;
                              });
                            }),
                        _uiComponents.normalText('I agree to the '),
                        InkWell(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "terms & conditions",
                              textScaler: const TextScaler.linear(1.0),
                              style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.blue.shade900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                        _uiComponents.normalText(' and '),
                        InkWell(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "privacy policies",
                              // textAlign: TextAlign.right,
                              textScaler: const TextScaler.linear(1.0),
                              style: GoogleFonts.abel(
                                textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.blue.shade900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                8.verticalSpace,
                UniversalButton(
                    onPressed: () {
                      if (!_isConditionChecked) {
                        _uiComponents.errorDialog(
                            "Please agree to the terms & conditions and privacy policies",
                            context);
                      }
                      if (_formKey.currentState!.validate()) {
                        signup(_emailcontroller.text.trim(),
                            _passwordcontroller.text.trim(), context);
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
