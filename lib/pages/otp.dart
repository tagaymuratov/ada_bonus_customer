import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PageOTP extends StatefulWidget {
  final String verificationId;
  const PageOTP({super.key, required this.verificationId});

  @override
  State<PageOTP> createState() => _PageOTPState();
}

class _PageOTPState extends State<PageOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          const Text('Введите код верификации'),
          const Pinput(
            length: 6,
            showCursor: true,
          ),
          FilledButton(
            onPressed: (){}, 
            child: const Text('Готово')
          )
        ],
      )),
    );
  }
}