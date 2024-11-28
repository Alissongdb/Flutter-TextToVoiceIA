import 'package:flutter/material.dart';
import 'package:flutter_textvoice/views/cards_view.dart';
import 'package:flutter_textvoice/views/home_view.dart';
import 'package:flutter_textvoice/views/splash_view.dart';

class TextToVoiceIA extends StatelessWidget {
  const TextToVoiceIA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashView(),
        '/home': (context) => HomeView(),
        '/cards': (context) => CardsView(
              savedTexts: [],
              onDelete: (int index) {}, onEdit: (int ) {  },
            ),
      },
    );
  }
}
