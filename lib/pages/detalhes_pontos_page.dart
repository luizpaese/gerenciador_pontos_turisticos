import 'package:flutter/material.dart';

import '../model/pontos_turisticos.dart';

class DetalhesPontosPage extends StatefulWidget {
  final PontosTuristicos pontos;

  const DetalhesPontosPage({Key? key, required this.pontos}) : super(key: key);

  @override
  _DetalhesPontosPageState createState() => _DetalhesPontosPageState();
}

class _DetalhesPontosPageState extends State<DetalhesPontosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Tarefa'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Campo(descricao: 'Código: '),
            Valor(valor: '${widget.pontos.id}'),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Nome: '),
            Valor(valor: widget.pontos.nome),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Descrição: '),
            Valor(valor: widget.pontos.descricao),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Diferenciais: '),
            Valor(valor: widget.pontos.diferenciais),
          ],
        ),
        Row(
          children: [
            Campo(descricao: 'Data de Inclusão: '),
            Valor(valor: widget.pontos.prazoFormatado),
          ],
        ),
      ],
    ),
  );
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 10, top: 5, bottom: 5),
        child: Expanded(
          flex: 1,
          child: Text(
            descricao,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

    );

  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}
