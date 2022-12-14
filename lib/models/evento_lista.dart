import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:agenda/models/evento.dart';
import 'package:flutter/cupertino.dart';

class EventoLista with ChangeNotifier {
  final _baseUrl = 'https://agenda-ac797-default-rtdb.firebaseio.com/eventos';
  final List<Evento> _eventos = [];
  List<Evento> get eventos => [..._eventos];

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if (response.body == 'null') return;
    Map<String, dynamic> dados = jsonDecode(response.body);
    _eventos.clear();
    print(dados.values);
    dados.forEach((eventoId, eventoDados) {
      _eventos.add(Evento(
        id: eventoId,
        titulo: eventoDados['titulo'],
        descricao: eventoDados['descricao'],
        cor: colorFromHex(eventoDados['cor'], enableAlpha: true) as Color,
        inicio: DateTime.parse(eventoDados['inicio']),
        fim: DateTime.parse(eventoDados['fim']),
      ));
    });
    notifyListeners();
  }

  Future<void> saveEvento(Map<String, Object> mapEvento) {
    bool temId = mapEvento['id'] != null;

    final evento = Evento(
      id: temId ? mapEvento['id'] as String : Random().nextDouble().toString(),
      titulo: mapEvento['titulo'] as String,
      descricao: mapEvento['descricao'] as String,
      cor: mapEvento['cor'] as Color,
      inicio: mapEvento['inicio'] as DateTime,
      fim: mapEvento['fim'] as DateTime,
    );

    if (temId) {
      return updateEvento(evento);
    } else {
      return addEvento(evento);
    }
  }

  Future<void> addEvento(Evento evento) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode(
        {
          "titulo": evento.titulo,
          "descricao": evento.descricao,
          "cor": evento.cor.value.toRadixString(16),
          "inicio": evento.inicio.toString(),
          "fim": evento.fim.toString(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _eventos.add(Evento(
      id: id,
      titulo: evento.titulo,
      descricao: evento.descricao,
      cor: evento.cor,
      inicio: evento.inicio,
      fim: evento.fim,
    ));
    notifyListeners();
  }

  Future<void> updateEvento(Evento evento) async {
    int index = _eventos.indexWhere((ev) => ev.id == evento.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${evento.id}.json'),
        body: jsonEncode(
          {
            "titulo": evento.titulo,
            "descricao": evento.descricao,
            "cor": evento.cor.value.toRadixString(16),
            "inicio": evento.inicio.toString(),
            "fim": evento.fim.toString(),
          },
        ),
      );
      _eventos[index] = evento;
      notifyListeners();
    }
  }

  void removeEvento(Evento evento) async {
    int index = _eventos.indexWhere((e) => e.id == evento.id);

    if (index >= 0) {
      final evento = _eventos[index];
      _eventos.remove(evento);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${evento.id}.json'),
      );
    }

    notifyListeners();
  }
}
