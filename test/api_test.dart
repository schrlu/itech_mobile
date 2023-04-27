import 'package:test/test.dart';
import 'package:itech_mobile/ownapi.dart';

void main() {
  group('OwnApi', () {
    test('getTimetable returns a string', () async {
      final result = await OwnApi.getTimetable();
      expect(result, isA<String>());
    });

    test('getHoliday returns a string', () async {
      final result = await OwnApi.getHoliday();
      expect(result, isA<String>());
    });

    test('getNews returns a string', () async {
      final result = await OwnApi.getNews();
      expect(result, isA<String>());
    });

    test('signUp returns a boolean', () async {
      final result =
          await OwnApi.signUp('it0-test', 'testpassword', 'email@example.com');
      expect(result, isA<bool>());
    });
  });
}
