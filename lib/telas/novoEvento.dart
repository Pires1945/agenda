import 'package:agenda/models/evento.dart';
import 'package:agenda/models/evento_lista.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class NovoEvento extends StatefulWidget {
  const NovoEvento({super.key});

  @override
  State<NovoEvento> createState() => _NovoEventoState();
}

class _NovoEventoState extends State<NovoEvento> {
  Color corAtual = const Color(0xff443a49);
  Color pickerColor = const Color(0xff443a49);
  late DateTime inicio = DateTime.now();
  late DateTime fim = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  final _mapEvento = <String, Object>{};
  bool _carregando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_mapEvento.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final evento = arg as Evento;
        _mapEvento['id'] = evento.id;
        _mapEvento['titulo'] = evento.titulo;
        _mapEvento['descricao'] = evento.descricao;
        _mapEvento['cor'] = evento.cor;
        _mapEvento['inicio'] = evento.inicio;
        _mapEvento['fim'] = evento.fim;
      }
    }
  }

  Future<void> _submit() async {
    final isValid = _formkey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_mapEvento['inicio'] == null) {
      alertaData(context);
      return;
    }

    if (_mapEvento['cor'] == null) {
      alertaCor(context);
      return;
    }

    _formkey.currentState?.save();

    setState(() => _carregando = true);
    try {
      await Provider.of<EventoLista>(
        context,
        listen: false,
      ).saveEvento(_mapEvento);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        ),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  alertaCor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione uma cor'),
        content: const Text('É necessário selecionar uma cor para seu evento!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  alertaData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione uma data'),
        content: const Text(
            'É necessário selecionar uma data de iniício e fim para seu evento!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  selecionaData(BuildContext context) async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      isShowSeconds: false,
      is24HourMode: true,
    );
    setState(() {
      _mapEvento['inicio'] = dateTimeList![0];
      _mapEvento['fim'] = dateTimeList[1];
    });
  }

  abrirModalColorPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: BlockPicker(
              pickerColor: corAtual,
              onColorChanged: (Color corAtual) {
                setState(() {
                  _mapEvento['cor'] = corAtual;
                });
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  void trocaCor(Color cor) {
    setState(() {
      _mapEvento['cor'] = cor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo evento'),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: TextFormField(
                            initialValue: _mapEvento['titulo']?.toString(),
                            onSaved: (titulo) =>
                                _mapEvento['titulo'] = titulo ?? '',
                            validator: (_titulo) {
                              final titulo = _titulo ?? '';

                              if (titulo.trim().isEmpty) {
                                return 'Titlo é obrigatório';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Titulo:',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: TextFormField(
                            initialValue: _mapEvento['descricao']?.toString(),
                            maxLines: null,
                            onSaved: (descricao) =>
                                _mapEvento['descricao'] = descricao ?? '',
                            decoration: const InputDecoration(
                              labelText: 'Descrição:',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Data:',
                                style: TextStyle(fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: (() => selecionaData(context)),
                                    icon: const Icon(
                                      Icons.alarm,
                                      size: 30,
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Cor: ',
                                style: TextStyle(fontSize: 17),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    onPressed: (() =>
                                        abrirModalColorPicker(context)),
                                    icon: const Icon(
                                      Icons.color_lens,
                                      size: 30,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          child: const Text('Salvar')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 236, 74, 74)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
