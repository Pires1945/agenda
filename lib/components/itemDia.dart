import 'package:agenda/models/evento.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/dia.dart';
import 'itemEvento.dart';

class ItemDia extends StatelessWidget {
  Dia dia;

  ItemDia(this.dia, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventoLista>(context);
    final List<Evento> todosEventos = provider.eventos;
    final List<Evento> eventosDoMes = todosEventos
        .where((element) => element.inicio.month == dia.data.month)
        .toList();

    final List<Evento> eventos = eventosDoMes
        .where((element) => element.inicio.day == dia.data.day)
        .toList();

    eventos.sort(
      (a, b) => a.inicio.hour.compareTo(b.inicio.hour),
    );

    return Column(
      children: [
        Text(
          dia.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(
          DateFormat('dd/MM').format(dia.data),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const Divider(),
        SizedBox(
          width: 150,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: eventos.length,
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: eventos[index],
              child: ItemEvento(),
            ),
          ),
        ),
      ],
    );
  }
}
