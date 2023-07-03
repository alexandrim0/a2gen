import 'package:faker/faker.dart';

class A2Faker {
  static const _alphabet =
      'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  final _now = DateTime.now();

  String genName() => faker.person.name().padRight(64).trimRight();

  String genTitle() => faker.lorem.sentence().padRight(64).trimRight();

  String genText() => faker.randomGenerator.boolean()
      ? faker.lorem
          .sentences(faker.randomGenerator.integer(5, min: 1))
          .join('\n')
      : '';

  String genUserId() =>
      'Generated${faker.randomGenerator.fromCharSet(_alphabet, 19)}';

  int genAmount({int min = 1}) => faker.randomGenerator.integer(10, min: min);

  String? genTimerange() => faker.randomGenerator.boolean()
      ? '["$_now","${_now.add(Duration(days: genAmount()))}"]'
      : null;

  Map<String, Object> genPlace() => faker.randomGenerator.boolean()
      ? {'place_name': ''}
      : {
          'place': {
            'type': 'Point',
            'coordinates': [faker.geo.latitude(), faker.geo.longitude()],
          },
          'place_name': '${faker.address.city()}, ${faker.address.country()}',
        };
}
