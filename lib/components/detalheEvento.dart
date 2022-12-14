import 'package:agenda/models/diaLista.dart';
import 'package:agenda/models/evento.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:agenda/utils/appRotas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalheEvento extends StatelessWidget {
  final Evento evento;
  const DetalheEvento(this.evento, {super.key});

  @override
  Widget build(BuildContext context) {
    const Color corIcon = Colors.black54;
    final provider = Provider.of<EventoLista>(context);
    final dias = Provider.of<DiaLista>(context);

    return Dialog(
      child: SizedBox(
        width: 450,
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6, top: 3, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    icon: const Icon(
                      Icons.edit,
                      color: corIcon,
                      size: 20,
                    ),
                    onPressed: (() {
                      Navigator.of(context).popAndPushNamed(AppRotas.NOVOEVENTO,
                          arguments: evento);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: IconButton(
                      tooltip: 'Deletar',
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: corIcon,
                        size: 20,
                      ),
                      onPressed: () {
                        provider.removeEvento(evento);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    icon: const Icon(
                      Icons.close,
                      color: corIcon,
                      size: 20,
                    ),
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.bookmark,
                color: evento.cor,
              ),
              title: Column(
                children: [
                  Text(evento.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 19)),
                  Text(
                    '${dias.nomeDiasCompleto[evento.inicio.weekday]}, ${evento.inicio.day} de ${dias.nomeMes[evento.inicio.month - 1]}  -  ${DateFormat('hh:mm').format(evento.inicio)} até ${DateFormat('hh:mm').format(evento.fim)}',
                    style: const TextStyle(fontSize: 14, color: corIcon),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                height: 14,
                width: 14,
                child: const Icon(Icons.description),
              ),
              title: Column(
                children: [
                  Text(
                    evento.descricao,
                    style: const TextStyle(fontSize: 16, color: corIcon),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
