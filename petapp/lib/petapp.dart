import 'package:flutter/material.dart';
// Importa a tela inicial da aplicação
import 'telas/meus_pets.dart';

//Aqui a classe PetAp herda de StatelessWidget, por que o seu estado não vai mudar
class PetApp extends StatelessWidget {
  // Sobrescreve o método build
  @override
  Widget build(BuildContext context) {
    // Retorna um MaterialApp, fornece a estrutura básica para uma aplicação Material Design.
    return MaterialApp(
      // Define se o banner de "Debug" será exibido no canto superior direito da tela, esta como falso para não exibir
      debugShowCheckedModeBanner: false,
      //Aqui fica o titulo da aplicação
      title: 'Pet App',
      //Aqui definimos qual o visual da aplicação
      theme: ThemeData(
        //Define o esquema de cores da aplicação, com uma cor semente para ter uma paleta de cores
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        //Aqui habilitamos o uso do Material Desing para os componentes visuais
        useMaterial3: true,
      ),
      //Define o widget que vai ser exibido como a tela inicial
      home: MeusPets(),
    );
  }
}
