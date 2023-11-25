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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Введите ваш номер телефона',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
               const Text(
                'Мы отправим вам код верификации'
              ),
              const SizedBox(height: 16),
              TextFormField(
                autofocus: true,
                controller: phoneController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefix: Text('+7 ')
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: sendPhone, 
                      child: const Text('Получить код')
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  void sendPhone(){
    //final pa = Provider.of(context)
    String phoneNumber = phoneController.text.trim();
    context.read<ProviderAuth>().singInWithPhone(context, '+7$phoneNumber');
  }
}