import 'dart:html';

import 'package:agenda/components/detalheEvento.dart';
import 'package:agenda/models/evento.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemEvento extends StatelessWidget {
  //final Evento evento;
  const ItemEvento({super.key});

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<EventoLista>(context);
    final evento = Provider.of<Evento>(context);

    return Card(
      color: evento.cor,
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: const Color.fromARGB(255, 241, 242, 243),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DetalheEvento(evento),
          );
        },
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            ListTile(
              title: Text(
                evento.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
