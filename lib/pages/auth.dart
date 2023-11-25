import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAuth extends StatefulWidget {
  const PageAuth({super.key});

  @override
  State<PageAuth> createState() => _PageAuthState();
}

class _PageAuthState extends State<PageAuth> {
  @override
  Widget build(BuildContext context) {
    //final pa = Provider.of<ProviderAuth>(context, listen: false);
    return context.read<ProviderAuth>().isSignedIn ? 
      Container() : welcomeScreen(context);
  }

  Widget welcomeScreen(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 1),
            Column(
              children: [
                Image.asset(
                  'assets/imgs/logo_green.png',
                  width: MediaQuery.of(context).size.width - 128,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  child: Text(
                    'Cкидки на каждую покупку или доставку',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/reg');
                          }, 
                          child: const Text('Начать'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Продолжая вы соглашаетесь с пользовательским соглашением',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        )
      ),
    );
  }

  Widget screen(){
    return Scaffold(
      body: ListView(
        children: [
          Container(color: Colors.pink,width: 200,height: 200,),
          Container(color: Colors.amber,width: 200,height: 200,),
        ],
      ),
    );
  }
}