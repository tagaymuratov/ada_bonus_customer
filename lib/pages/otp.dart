import 'dart:async';
import 'package:ada_bonus_customer/constants.dart';
import 'package:ada_bonus_customer/utils/utils.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PageOTP extends StatefulWidget {
  final String verificationId;
  const PageOTP({
    super.key, 
    required this.verificationId, 
  });

  @override
  State<PageOTP> createState() => _PageOTPState();
}

class _PageOTPState extends State<PageOTP> {
  late Timer timer;
  String? otpCode;
  int timerCounter = 61;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), timerTick);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.watch<ProviderAuth>().isLoading ? loader : SafeArea(
        child: Padding( 
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Введите код', 
                style: Theme.of(context).textTheme.headlineSmall
              ),
              const SizedBox(height: 4),
              const Text('Мы отправили его на ваш телефона'),
              const SizedBox(height: 16),
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green)
                  )
                ),
                onCompleted: (value){
                  otpCode = value;
                },
              ),
              const SizedBox(height: 16),

              Center(
                child: (timerCounter <= 0) ? TextButton(
                  onPressed: (){
                    timerCounter = 61;
                  }, 
                  child: const Text('Отправить код заново')
                ) 
                : Text('Отправить код заново через $timerCounter'),
              ),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(  
                  onPressed: (){
                    if(otpCode != null && otpCode?.length == 6){
                      verifyOtp(context, otpCode!);
                    }else{
                      showSnackBar(context, 'Введите код');
                    }
                  }, 
                  child: const Text('Продолжить')
                ),
              ),
            ],
        ),
      )),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) async {
    PhoneAuthCredential creds = PhoneAuthProvider.credential(
      verificationId: widget.verificationId, 
      smsCode: userOtp
    );

    bool b = await context.read<ProviderAuth>().singInWithCreds(creds);
    if(b){
      gotoStart();
    }else{
      
    }
  }

  void gotoStart() => Navigator.popUntil(context, ModalRoute.withName('/'));

  void timerTick(Timer timer) => setState(() => timerCounter--);
}