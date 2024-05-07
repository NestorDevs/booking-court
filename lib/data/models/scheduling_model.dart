import 'package:booking/domain/models/scheduling.dart';

class SchedulingModel extends Scheduling {
  SchedulingModel(
      {required super.id,
      required super.court,
      required super.date,
      required super.user});

  factory SchedulingModel.fromJson(Map<String, dynamic> json) {
    return SchedulingModel(
      id: json['id'] as int,
      court: json['court'] as String,
      date: json['date'] as String,
      user: json['user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "court": court,
      'date': date,
      'user': user,
    };
  }
}
