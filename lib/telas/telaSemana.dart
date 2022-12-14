import 'dart:math';

import 'package:agenda/components/semana.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:agenda/utils/appRotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/evento.dart';
import 'novoEvento.dart';

class TelaSemana extends StatefulWidget {
  const TelaSemana({super.key});

  @override
  State<TelaSemana> createState() => _TelaSemanaState();
}

class _TelaSemanaState extends State<TelaSemana> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventoLista>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          Semana(),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRotas.NOVOEVENTO);
            },
            child: Icon(Icons.add),
            elevation: 10,
          )
        ],
      ),
    );
  }
}
