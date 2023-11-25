import 'package:flutter/material.dart';

class PageBonus extends StatefulWidget {
  const PageBonus({super.key});

  @override
  State<PageBonus> createState() => _PageBonusState();
}

class _PageBonusState extends State<PageBonus> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // QR code
          // loader
          Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Text('Ваша скидка: 5%'),
                LinearProgressIndicator(
                  //backgroundColor: ,
                  value: 0.5,
                ),
                Text('100500 тенге до следующего уровня')
              ],
            ),
          ),
          // history
          const SizedBox(height: 48)
        ],
      ),
    );
  }
}