import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleServices {

 Future googleSignIn () async{
  // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
  //
  // final GoogleSignInAuthentication gAuth = await gUser!.authentication;
  //
  // final credential = GoogleAuthProvider.credential(
  //   idToken: gAuth.idToken,
  //   accessToken: gAuth.accessToken
  // );
  //
  // FirebaseAuth.instance.signInWithCredential(credential);
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  final credential = GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
      accessToken: gAuth.accessToken
  );

  FirebaseAuth.instance.signInWithCredential(credential);
 }
}