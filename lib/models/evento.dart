import 'package:flutter/material.dart';

class Evento with ChangeNotifier {
  final String id;
  final String descricao;
  final String titulo;
  Color cor;
  final DateTime inicio;
  final DateTime fim;

  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.inicio,
    required this.fim,
  });
}
