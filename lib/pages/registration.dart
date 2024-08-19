import 'package:ada_bonus_customer/constants.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageRegistration extends StatefulWidget {
  const PageRegistration({super.key});

  @override
  State<PageRegistration> createState() => _PageRegistrationState();
}

class _PageRegistrationState extends State<PageRegistration> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.watch<ProviderAuth>().isLoading ? loader : SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              const Spacer(),
              Text('ДОБРО ПОЖАЛОВАТЬ', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              const Text('Введите ваш номер телефона'),
              const SizedBox(height: 8),
              TextFormField(
                autofocus: true,
                controller: phoneController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefix: Text('+7 ')
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: sendPhone, 
                  child: const Text('Продолжить')
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose(){
    phoneController.dispose();
    super.dispose();
  }

  void sendPhone() {
    String phoneNumber = phoneController.text.trim();
    context.read<ProviderAuth>().singInWithPhone(context, '+7$phoneNumber');
  }
}