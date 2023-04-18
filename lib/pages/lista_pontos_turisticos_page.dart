


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_pontos_turisticos/pages/detalhes_pontos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dao/pontosturisticos_dao.dart';
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

  final _pontos = <PontosTuristicos>[];
  final _dao = PontosTuristicosDao();
  var _carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

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
                      if (key.currentState?.dadosValidados() != true) {
                        return;
                      }
                      Navigator.of(context).pop();
                      final novaTarefa = key.currentState!.novoPonto;
                      _dao.salvar(novaTarefa).then((success) {
                        if (success) {
                          _atualizarLista();
                        }
                      });
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
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando seus pontos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if(_pontos.isEmpty){
      return const Center(
        child: Text('Não existem pontos turísticos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      );
    }
    return ListView.separated(
      itemCount: _pontos.length,
      itemBuilder: (BuildContext context, int index){
        final ponto = _pontos[index];

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
                            _abrirPaginaDetalhesPontos(ponto);
                          }else{
                            _excluir(ponto);
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

  void _excluir(PontosTuristicos ponto){
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
                    Navigator.pop(context);
                    if (ponto.id == null) {
                      return;
                    }
                    _dao.remover(ponto.id!).then((success) {
                      if (success) {
                        _atualizarLista();
                      }
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

  void _abrirPaginaFiltro() async {
    final navigator = Navigator.of(context);
    final alterouValores = await navigator.pushNamed(FiltroPage.routeName);
    if (alterouValores == true) {
      _atualizarLista();
    }
  }

  void _abrirPaginaDetalhesPontos(PontosTuristicos pontos) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesPontosPage(
            pontos: pontos,
          ),
        ));
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    // Carregar os valores do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? PontosTuristicos.CAMPO_ID;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.chaveUsarOrdemDecresecente) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.chaveCampoDescricao) ?? '';
    final pontos = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _carregando = false;
      _pontos.clear();
      if (pontos.isNotEmpty) {
        _pontos.addAll(pontos);
      }
    });
  }

}