


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/pontos_turisticos.dart';
import 'conteudo_form_dialog.dart';
import 'filtro_page.dart';

class ListaPontosTuristicosPage extends StatefulWidget{
  @override
  _ListaPontosTuristicosPageState createState() => _ListaPontosTuristicosPageState();
}

class _ListaPontosTuristicosPageState extends State<ListaPontosTuristicosPage>{

  static const ACAO_EDITAR = 'editar';
  static const ACAO_DELETAR = 'deletar';
  static const ACAO_VISUALIZAR = 'visualizar';

  final pontosTuristicos = <PontosTuristicos>[
    PontosTuristicos(
        id: 1,
        nome: 'Exemplo nome',
        descricao: 'Exemplo descrição',
        diferenciais: 'Exemplo diferenciais',
        dataInclusao: DateTime.now()
    )
  ];
  var _ultimoId = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo ponto turístico',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criarAppBar(){
    return AppBar(
      title: const Text('Pontos Turísticos'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro,
            icon: const Icon(Icons.filter_list)),
      ],
    );
  }

  void _abrirForm({PontosTuristicos? pontoAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                  pontoAtual == null ? 'Novo Ponto Turístico' : 'Ponto ID: ${pontoAtual.id}'
              ),
              content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar')
                ),
                TextButton(
                    onPressed: (){
                      if(key.currentState != null && key.currentState!.dadosValidados()){
                        setState(() {
                          final novoPonto = key.currentState!.novoPonto;
                          if(index == null){
                            novoPonto.id = ++_ultimoId;
                            pontosTuristicos.add(novoPonto);
                          }else{
                            pontosTuristicos[index] = novoPonto;
                          }

                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Salvar')
                )
              ],
            ),
          );
        }
    );

  }

  Widget _criarBody(){
    if(pontosTuristicos.isEmpty){
      return const Center(
        child: Text('Não existem pontos turísticos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );
    }
    return ListView.separated(
      itemCount: pontosTuristicos.length,
      itemBuilder: (BuildContext context, int index){
        final ponto = pontosTuristicos[index];

        return Card(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/img.jpg',
                      fit: BoxFit.fill,
                    ),
                    PopupMenuButton(
                        child: ListTile(
                          title: Text('${ponto.id} - ${ponto.nome}'),
                          subtitle: Text('Descrição: ${ponto.descricao}'),
                        ),
                        itemBuilder: (BuildContext context) => _criarItensMenu(),
                        onSelected: (String valorSelecionado){
                          if (valorSelecionado == ACAO_EDITAR){
                            _abrirForm(pontoAtual: ponto, index: index);
                          }else if(valorSelecionado == ACAO_VISUALIZAR) {
                            print("Visualizar");
                          }else{
                            _excluir(index);
                          }
                        }
                    )
                  ],
                ),
              ),
            ],
          )
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  void _excluir(int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: Text("Esse registro deletado permanentemente!"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      pontosTuristicos.removeAt(indice);
                    });
                  },
                  child: Text('Confirmar'))
            ],
          );
        }
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],
        ),
      ),
      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar'),
            )
          ],
        ),
      ),
      PopupMenuItem(
        value: ACAO_DELETAR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],
        ),
      )
    ];
  }

  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores){
      if(alterouValores == true){
        print("FILTRO");
        ///Filtro
      }
    }

    );

  }


}