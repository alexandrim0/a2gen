import 'package:faker/faker.dart';

class A2Faker {
  static const _alphabet =
      'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  final _now = DateTime.now();

  int genInt(int max, [int min = 0]) =>
      faker.randomGenerator.integer(max, min: min);

  String genName() => faker.person.name().padRight(64).trimRight();

  String genTitle() => faker.lorem.sentence().padRight(64).trimRight();

  String genText({bool? notEmpty}) =>
      notEmpty ?? faker.randomGenerator.boolean()
          ? faker.lorem
              .sentences(faker.randomGenerator.integer(5, min: 1))
              .join('\n')
          : '';

  String genUserId() =>
      'Generated${faker.randomGenerator.fromCharSet(_alphabet, 19)}';

  String? genTimerange() => faker.randomGenerator.boolean()
      ? '["$_now","${_now.add(Duration(days: genInt(30, 1)))}"]'
      : null;

  Map<String, Object>? genPlace() => faker.randomGenerator.boolean()
      ? null
      : {
          'type': 'Point',
          'coordinates': [faker.geo.latitude(), faker.geo.longitude()],
        };
}
