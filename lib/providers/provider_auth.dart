import 'package:ada_bonus_customer/pages/otp.dart';
import 'package:ada_bonus_customer/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderAuth extends ChangeNotifier{
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ProviderAuth(){
    checkSignIn();
  }
  
  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('is_signedin') ?? false;
    notifyListeners();
  }

  void singInWithPhone(BuildContext context, String phoneNumber) async {
    try{
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async{
          await _firebaseAuth.signInWithCredential(credential);
        }, 
        verificationFailed: (error) => throw Exception(error.message), 
        codeSent: (verificationId, forceResendingToken){
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=> PageOTP(verificationId: verificationId))
          );
        }, 
        codeAutoRetrievalTimeout: (verificationId){}
      );
    } on FirebaseAuthException catch(e){showSnackBar(context, e.message.toString());}
  }
}