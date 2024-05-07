// ignore_for_file: use_build_context_synchronously

import 'package:booking/presentation/controllers/sheduling_controller.dart';
import 'package:booking/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/database_provider.dart';
import '../../domain/models/scheduling.dart';

class AddSchedulingScreen extends StatefulWidget {
  const AddSchedulingScreen({super.key});

  @override
  State<AddSchedulingScreen> createState() => _AddSchedulingScreenState();
}

class _AddSchedulingScreenState extends State<AddSchedulingScreen> {
  int? selectedCancha;
  DateTime? selectedDate;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  SchedulingController? _schedulingProvider;
  final DatabaseProvider dbProvider = DatabaseProvider.instance;

  //Controller
  final TextEditingController nombreController = TextEditingController();

  final Map<int, String> canchas = {
    0: 'A',
    1: 'B',
    2: 'C',
  };

  //Metodos

  //Guardar
  void saveSchedule() async {
    if (selectedCancha == null || selectedDate == null) {
      return;
    }

    final schedule = Scheduling(
      id: 0,
      court: canchas[selectedCancha!]!,
      date: selectedDate.toString(),
      user: nombreController.text,
    );

    final schedulingProvider =
        Provider.of<SchedulingController>(context, listen: false);
    final scheduleSave = await schedulingProvider.insertScheduling(schedule);

    if (scheduleSave) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No hay disponibilidad'),
            content: const Text(
                'Ya se han agendado tres veces para esa cancha en ese día.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  //Obtener
  Future<List<Scheduling>> getScheduling() async {
    return await dbProvider.getScheduling();
  }

  //Delete
  void deleteScheduling(int id) async {
    await dbProvider.deleteScheduling(id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseProvider;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _schedulingProvider ??= Provider.of<SchedulingController>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nombreController.dispose();
    _schedulingProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Agendamiento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/cancha.jpg'),
              DropdownButtonFormField<int>(
                value: selectedCancha,
                onChanged: (value) {
                  setState(() {
                    selectedCancha = value;
                  });
                },
                items: canchas.entries.map<DropdownMenuItem<int>>(
                  (entry) {
                    final int index = entry.key;
                    final String value = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text('Cancha $value'),
                    );
                  },
                ).toList(),
                decoration: const InputDecoration(
                  labelText: 'Cancha',
                ),
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Icon(Icons.calendar_month, size: 30),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  });
                },
              ),
              // Aquí puedes añadir el campo para el nombre de la persona realizando el agendamiento
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(350, 80)),
                  elevation: MaterialStateProperty.all(5),
                ),
                onPressed: () {
                  saveSchedule();
                  // Aquí debes implementar la lógica para guardar el agendamiento localmente
                  //Navigator.pop(context);
                },
                child: const Text('Guardar Agendamiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
