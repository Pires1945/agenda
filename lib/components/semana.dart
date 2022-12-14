import 'package:agenda/models/diaLista.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/dia.dart';
import '../utils/appRotas.dart';
import 'itemDia.dart';

class Semana extends StatefulWidget {
  const Semana({super.key});

  @override
  State<Semana> createState() => _SemanaState();
}

class _SemanaState extends State<Semana> {
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    Provider.of<EventoLista>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _carregando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dataSemana =
        ModalRoute.of(context)?.settings.arguments as DateTime;

    final provider = Provider.of<DiaLista>(context);
    final nomeDias = provider.nomeDias;
    List<Dia> dias = [];

    for (int i = 0; i < nomeDias.length; i++) {
      DateTime data = dataSemana.toLocal();
      int diaSemana = dataSemana.weekday;
      int domingo = dataSemana.day - diaSemana;
      int dia = domingo + i;

      data = DateTime(
        data.year,
        data.month,
        dia,
        data.hour,
        data.minute,
        data.second,
        data.millisecond,
        data.microsecond,
      );

      dias.add(Dia(nomeDias[i], data));
    }

    List<Widget> itemDia = [];

    for (int i = 0; i < dias.length; i++) {
      itemDia.add(
        Flexible(
          child: SizedBox(
            width: 150,
            child: ItemDia(dias[i]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Semana'),
        centerTitle: true,
        toolbarHeight: 35,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 17),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _carregando ? [CircularProgressIndicator()] : itemDia,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRotas.NOVOEVENTO);
              },
              tooltip: 'Novo Evento',
              child: Icon(Icons.add),
              elevation: 10,
            )
          ],
        ),
      ),
    );
  }
}
