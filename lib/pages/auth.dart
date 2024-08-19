import 'package:ada_bonus_customer/constants.dart';
import 'package:ada_bonus_customer/pages/bonus.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:ada_bonus_customer/providers/provider_pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAuth extends StatefulWidget {
  const PageAuth({super.key});

  @override
  State<PageAuth> createState() => _PageAuthState();
}

class _PageAuthState extends State<PageAuth> {
  final ScrollController _scrollController = ScrollController();
  late final List<Widget> screens;
  final List<String> titles = [
    'Быстрее будущего'
  ];
  
  @override
  void initState(){
    super.initState();
    screens = [
      const PageBonus(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<ProviderAuth>().isSignedIn ? screenManager(context) : welcomeScreen(context);
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  Widget welcomeScreen(BuildContext context){
    return Scaffold(
      body: context.watch<ProviderAuth>().isLoading ? loader : Container(
        decoration: gradient,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/imgs/logo_green.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:() => Navigator.pushNamed(context, '/reg'),
                  child: const Text('Начать'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Продолжая вы соглашаетесь с пользовательским соглашением',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                textAlign: TextAlign.center,
              )
            ],
          )
        ),
      ),
    );
  }

  Widget screenManager(BuildContext context){
    int index = context.watch<ProviderPages>().pageIndex;
    return Scaffold(
      appBar: AppBar( 
        centerTitle: false,
        title: Text(titles[index]),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers:[SliverToBoxAdapter(child: screens[index])]
        ),
      )
    );
  }
}