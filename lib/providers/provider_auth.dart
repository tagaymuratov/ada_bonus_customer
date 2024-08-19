import 'dart:developer';
import 'package:ada_bonus_customer/pages/otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderAuth extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late final SharedPreferences sp;
  late final List<dynamic> _levels;
  late final List<dynamic> _percents;
  bool _isListening = false;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  String? _phone;
  String get phone => _phone!;
  double _points = 0;
  double get points => _points;
  int _cashback = 1;
  int get cashback => _cashback;
  double _spent = 0;
  double get spent => _spent;
  double nextLvl = 100000;
  int? forceResendingToken;
  double _cashbackProgress = 0;
  double get cashbackProgress => _cashbackProgress;
  List carousel = [];
  
  ProviderAuth(){
    getAppConstants();
  }

  void getAppConstants() async{
    await db.collection('app').get().then((v){
      for(var item in v.docs){
        var data = item.data();
        if(item.id == 'constants'){
          _levels = data['levels'];
          _percents = data['percents'];
        }else if(item.id == 'advertising'){
          carousel = data['carousel'];
        }
      }
    });
    
    await checkSignIn();
    await updateCashback();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkSignIn() async {
    sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('is_signedin') ?? false;
    if(_isSignedIn){
      await readLocalData();
    }
  }

  void singInWithPhone(BuildContext context, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        _phone = phoneNumber;
        singInWithCreds(credential);
      }, 
      verificationFailed: (error){
        log('error code = ${error.code}');
        _isLoading = false;
        notifyListeners();
      }, 
      codeSent: (verificationId, forceResendingToken){
        _isLoading = false;
        _phone = phoneNumber;
        Navigator.push(context, MaterialPageRoute(builder: (context) => 
          PageOTP(verificationId: verificationId)));
      }, 
      codeAutoRetrievalTimeout: (verificationId){},
      timeout: const Duration(seconds: 60)
    );
  }

  void resendOTP(){
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: _phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        singInWithCreds(credential);
      }, 
      verificationFailed: (error){}, 
      codeSent: (verificationId, token){
        forceResendingToken = token;
      },
      forceResendingToken: forceResendingToken,
      codeAutoRetrievalTimeout: (verificationId){},
      timeout: const Duration(seconds: 60)
    );
  }

  Future<bool> singInWithCreds(AuthCredential creds) async {
    _isLoading = true;
    notifyListeners();

    User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
    if(user != null){
      _uid = user.uid;
      await db.collection('users').doc(_uid).get().then((e) async{
        if(e.exists){
          var data = e.data()!;
          _phone = data['phone'];
          _spent = data['spent'];
          _cashback = data['cashback'];
          _points = data['points'];
        }else{
          Map<String, dynamic> sendData = {
            'phone' : _phone,
            'spent' : _spent,
            'cashback' : _cashback,
            'points' : _points,
          };
          await db.collection('users').doc(_uid).set(sendData);
        }
        await saveLocalData();
        setListener();
      });
      _isSignedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    }else{
      return false;
      // TODO signin fall
    }
  }

  void setListener(){
    if(!_isListening){
      _isListening = true;
      db.collection('users').doc(_uid).snapshots().listen((event) {
        var data = event.data();
        _spent = data?['spent'];
        _cashback = data?['cashback'];
        _points = data?['points'];
        updateCashback();
        saveLocalData();
      });
    }
  }

  Future<void> saveLocalData() async {
    await sp.setBool('is_signedin', true);
    await sp.setString('phone', _phone!);
    await sp.setString('uid', _uid!);
    await sp.setDouble('spent', _spent);
    await sp.setInt('cashback', _cashback);
    await sp.setDouble('points', _points);
  }

  Future<void> readLocalData() async {
    _uid = sp.getString('uid');
    _phone = sp.getString('phone');
    _spent = sp.getDouble('spent') ?? 0.0;
    _cashback = sp.getInt('cashback') ?? 1;
    _points = sp.getDouble('points') ?? 0.0;
    setListener();
  }

  Future<void> updateCashback() async {
    int newCashback = 1;
    for (int i = 0; i < _levels.length; i++){
      if(_spent > _levels[i]){
        newCashback = _percents[i+1];
        if(i == _levels.length - 1){
          _cashbackProgress = 1;
          nextLvl = -1;
        }else{
          _cashbackProgress = (_spent - _levels[i]) / 100000;
          nextLvl = _levels[i+1] - _spent;
        }
      }
    }

    if(newCashback != _cashback) {
      _cashback = newCashback;
      db.collection('users').doc(_uid).update({'cashbeck' : _cashback});
      sp.setInt('cashbeck', _cashback);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await sp.clear();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    _isLoading = false;
    notifyListeners();
  }
}