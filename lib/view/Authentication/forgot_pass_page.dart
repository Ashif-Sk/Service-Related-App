import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/ui_components.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailcontroller = TextEditingController();
  final UiComponents _uiComponents =UiComponents();

  Future passwordReset(BuildContext context) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text.trim());
      _uiComponents.errorDialog('Password reset link sent,check your email', context);
    } on FirebaseAuthException {
      _uiComponents.errorDialog('Invalid email', context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        // title: const Text('Forgot Password?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
           const BigImage(imagePath: 'images/reset-password.png'),
          const SizedBox(height: 40,),
           Divider(thickness: 0.3,color: Theme.of(context).colorScheme.secondary),
          _uiComponents.headline2('Enter your email and we will send you password reset link'),
           Divider(thickness: 0.3,color: Theme.of(context).colorScheme.secondary,),
          const SizedBox(height: 30,),
          TextFormField(
            controller: emailcontroller,
            decoration: InputDecoration(
                prefixIcon:  Icon(Icons.email_rounded,color: Theme.of(context).colorScheme.primary,),
                hintText: 'Enter email',
                labelText: 'Email',
                hintStyle: GoogleFonts.abel(
                    textStyle: TextStyle(
                        fontSize: 35.rt,
                        fontWeight: FontWeight.w500)),
                labelStyle: GoogleFonts.abel(
                    textStyle: TextStyle(
                        fontSize: 36.rt,
                        fontWeight: FontWeight.w500
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5))),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30,),
          UniversalButton(onPressed: ()=>passwordReset(context),
              buttonText: 'Reset Password'),
          const SizedBox(height: 15,),
          BigOutlineButton(onPressed: ()=>Flexify.back(), buttonText: 'Go Back', image: 'images/arrow.png')
        ],
      ),
    );
  }
}
