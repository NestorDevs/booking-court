import 'package:booking/data/database/database_provider.dart';
import 'package:booking/domain/models/scheduling.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('DatabaseProvider', () {
    late DatabaseProvider databaseProvider;

    setUp(() async {
      sqfliteFfiInit();
      databaseFactoryOrNull = databaseFactoryFfi;
      databaseProvider = DatabaseProvider.instance;
      await databaseProvider.initializeDatabaseProvider();
    });

    test('insertScheduling inserts scheduling correctly', () async {
      final scheduling = Scheduling(
        court: 'Court B',
        date: '2024-05-11',
        user: 'User B',
        id: 2,
      );

      await databaseProvider.insertScheduling(scheduling);
      final retrievedScheduling = await databaseProvider.getSchedulingById(2);
      expect(retrievedScheduling.court, equals('Court A'));
      expect(retrievedScheduling.date, equals('2024-05-10'));
      expect(retrievedScheduling.user, equals('User A'));
    });

    test('deleteScheduling deletes scheduling correctly', () async {
      final scheduling = Scheduling(
        court: 'Court A',
        date: '2024-05-10',
        user: 'User A',
        id: 1,
      );

      await databaseProvider.insertScheduling(scheduling);
      await databaseProvider.deleteScheduling(1);

      expect(
        () async => await databaseProvider.getSchedulingById(1),
        throwsA(isA<Exception>()),
      );
    });
  });
}
