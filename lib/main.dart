import 'package:agenda/components/detalheEvento.dart';
import 'package:agenda/components/semana.dart';
import 'package:agenda/models/diaLista.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:agenda/telas/calendario.dart';
import 'package:agenda/telas/novoEvento.dart';
import 'package:agenda/telas/telaSemana.dart';
import 'package:agenda/utils/appRotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventoLista()),
        ChangeNotifierProvider(create: (_) => DiaLista()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Calendario(),
        routes: {
          AppRotas.SEMANA: (context) => Semana(),
          AppRotas.NOVOEVENTO: (context) => NovoEvento(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
