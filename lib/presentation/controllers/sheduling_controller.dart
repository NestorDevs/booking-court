import 'package:flutter/material.dart';

import '../../data/database/database_provider.dart';
import '../../domain/models/scheduling.dart';

class SchedulingController extends ChangeNotifier {
  List<Scheduling> _sheduling = [];

  List<Scheduling> get sheduling => _sheduling;

  final Map<String, dynamic> schedulingPerDay = {};

  Future<void> loadScheduling() async {
    _sheduling = await DatabaseProvider.instance
        .getScheduling(); // Método para obtener los agendamientos desde la base de datos o cualquier otra fuente
    notifyListeners();
  }

  Future<void> fetchScheduling() async {
    _sheduling = await DatabaseProvider.instance.getScheduling();
    notifyListeners();
  }

  Future<bool> insertScheduling(Scheduling scheduling) async {
    // Obtener la clave del mapa para la fecha y la cancha seleccionadas
    final key = '${scheduling.date}-${scheduling.court}';
    // Verificar si ya se han agendado tres veces para la cancha en el día seleccionado
    if (schedulingPerDay[key] != null && schedulingPerDay[key]! >= 3) {
      return false;
      // O mostrar un mensaje de error en lugar de lanzar una excepción
      // y manejarlo adecuadamente en el código que llama a insertAgendamiento.
    }
    await DatabaseProvider.instance.insertScheduling(scheduling);
    await fetchScheduling();
    // Incrementar la cantidad de agendamientos para la cancha y día correspondientes
    schedulingPerDay.update(key, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
    return true;
  }

  Future<void> deleteScheduling(int id) async {
    await DatabaseProvider.instance.deleteScheduling(id);
    await fetchScheduling();
  }
}
