import 'package:flutter/material.dart';
import 'telas/meus_pets.dart'; // tela inicial do app

class PetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),

      home: MeusPets(),
    );
  }
}
