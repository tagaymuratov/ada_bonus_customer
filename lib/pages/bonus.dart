import 'package:ada_bonus_customer/constants.dart';
import 'package:ada_bonus_customer/providers/provider_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PageBonus extends StatefulWidget {
  const PageBonus({super.key});

  @override
  State<PageBonus> createState() => _PageBonusState();
}

class _PageBonusState extends State<PageBonus> {
  final db = FirebaseFirestore.instance.collection('users');
  final _getMonth = {
    1 : 'Янв',
    2 : 'Фев',
    3 : 'Мар',
    4 : 'Апр',
    5 : 'Май',
    6 : 'Июн',
    7 : 'Июл',
    8 : 'Авг',
    9 : 'Сен',
    10 : 'Окт',
    11 : 'Ноя',
    12 : 'Дек',
  };
  PageController pageViewController = PageController(
    viewportFraction: 0.9
  );

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double nextLvl = context.watch<ProviderAuth>().nextLvl;
    List carousel = context.read<ProviderAuth>().carousel;
    Size screenSize = MediaQuery.of(context).size;

    return context.watch<ProviderAuth>().isLoading ? loader : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: (screenSize.width - 16) / 2,
          child: PageView.builder(
            controller: pageViewController,
            itemCount: carousel.length,
            itemBuilder: (BuildContext context, int index){
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: carousel[index],
                  placeholder: (context, url) => loader,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ),

        Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.savings),
                title: Text('Баллов: ${context.watch<ProviderAuth>().points}'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.sync),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Кешбэк: ${context.watch<ProviderAuth>().cashback}%',
                        style: const TextStyle(fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      minHeight: 8,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: Colors.green,
                      value: context.watch<ProviderAuth>().cashbackProgress,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
                subtitle: Text(
                  (nextLvl >= 0) ? 'До следующего уровня: $nextLvl' : 'У вас максимальный уровень',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        Card(
          margin: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                QrImageView(
                  data: context.read<ProviderAuth>().uid,
                ),
                const SizedBox(height: 16),
                const Text('Для получения кешбэка покажите QR код перед оплатой'),
              ],
            ),
          ),
        ),
        
        Container(
          padding: const EdgeInsets.only(top: 16, left: 32, right: 16),
          child: Text('История', style: Theme.of(context).textTheme.titleLarge,)
        ),

        Card(
          margin: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: db.doc(context.read<ProviderAuth>().uid).collection('history')
                    .orderBy('time').limit(10).snapshots(), 
            builder: (context, snapshots){
              if(snapshots.hasError) {return const Text('Не удалось полчить историю');}
              if(snapshots.connectionState == ConnectionState.waiting) {return loader;}
          
              return Column(
                children: snapshots.data!.docs.map((DocumentSnapshot doc){
                  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                  DateTime date = (data['time'] as Timestamp).toDate();
                  return ListTile(
                    leading: const Icon(Icons.mobile_friendly),
                    title: Text('Покупка ${data['order']}'),
                    subtitle: Text('Из них баллами ${data['pointsSpend']}'),
                    trailing: Text('${date.day} ${_getMonth[date.month]} ${date.hour}:${date.minute}'),
                  );
                }).toList().cast(),
              );
            }
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: ()async {
              await context.read<ProviderAuth>().signOut();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }, 
            icon: const Icon(Icons.logout),
            label: const Text('Выйти из аккаунта')
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  void dispose(){
    pageViewController.dispose();
    super.dispose();
  }
}