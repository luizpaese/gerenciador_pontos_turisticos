import 'package:flutter/material.dart';
import 'package:gerenciador_pontos_turisticos/pages/filtro_page.dart';
import 'package:gerenciador_pontos_turisticos/pages/lista_pontos_turisticos_page.dart';

void main() {
  runApp(const AppPontosTuristicos());
}

class AppPontosTuristicos extends StatelessWidget {
  const AppPontosTuristicos({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Pontos Turísticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ListaPontosTuristicosPage(),
      routes: {
        FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      },
    );
  }
}
