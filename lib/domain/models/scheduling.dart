class Scheduling {
  final int id;
  final String court;
  final String date;
  final String user;

  Scheduling({
    required this.id,
    required this.court,
    required this.date,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'court': court,
      'date': date,
      'user': user,
    };
  }

  factory Scheduling.fromMap(Map<String, dynamic> map) {
    return Scheduling(
      id: map['id'] as int,
      court: map['court'] as String,
      date: map['date'] as String,
      user: map['user'] as String,
    );
  }
}
