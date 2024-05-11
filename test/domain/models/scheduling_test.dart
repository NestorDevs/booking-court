import 'package:booking/domain/models/scheduling.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Scheduling', () {
    test('Scheduling constructor creates instance with correct values', () {
      final scheduling = Scheduling(
        id: 1,
        court: 'Court A',
        date: '2024-05-10',
        user: 'User123',
      );

      expect(scheduling.id, 1);
      expect(scheduling.court, 'Court A');
      expect(scheduling.date, '2024-05-10');
      expect(scheduling.user, 'User123');
    });

    test('Scheduling.fromMap creates instance with correct values', () {
      final map = {
        'id': 1,
        'court': 'Court A',
        'date': '2024-05-10',
        'user': 'User123',
      };

      final scheduling = Scheduling.fromMap(map);

      expect(scheduling.id, 1);
      expect(scheduling.court, 'Court A');
      expect(scheduling.date, '2024-05-10');
      expect(scheduling.user, 'User123');
    });
  });
}
