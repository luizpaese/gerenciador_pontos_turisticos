import 'package:intl/intl.dart';

class PontosTuristicos{
  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';
  static const CAMPO_INCLUSAO = 'inclusao';

  int id;
  String nome;
  String descricao;
  String diferenciais;
  DateTime? dataInclusao;

  PontosTuristicos({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.diferenciais,
    this.dataInclusao});

  String get prazoFormatado{
    if (dataInclusao == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(dataInclusao!);
  }
}