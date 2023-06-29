import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_query.dart';
import 'a2_service.dart';

class A2Repository {
  int? maxBatchSize;
  List<String>? _users;
  List<String>? _beacons;
  List<String>? _comments;

  var faker = A2Faker();
  var service = A2Service();

  Future<void> createEntity(A2Query query, int? count) async =>
      count == null || count < 1 || count > (maxBatchSize ?? 100)
          ? null
          : service.mutate(
              query.mutation,
              {
                'objects': [
                  for (var i = 0; i < count; i++)
                    switch (query) {
                      A2Query.user => {
                          'id': faker.genUserId(),
                          'display_name': faker.genName(),
                          'description': faker.genText(),
                        },
                      A2Query.beacon => {
                          'title': faker.genTitle(),
                          'description': faker.genText(),
                          'user_id': await _getUserId(),
                          'place': faker.genCoords(),
                          'timerange': faker.genTimerange(),
                        },
                      A2Query.comment => {
                          'beacon_id': await _getBeaconId(),
                          'user_id': await _getUserId(),
                          'content': faker.genText(),
                        },
                      A2Query.vote => {
                          'subject': await _getUserId(),
                          // TBD: vote for comment and user also
                          'object': await _getBeaconId(),
                          'amount': faker.genAmount(min: -1),
                        },
                    }
                ],
              },
            );

  Future<List<String>> _getIdsOf(A2Query entity) => service.query(
        entity.query,
        {'limit': maxBatchSize},
      ).then(
        (response) => (response?[entity.name] as List)
            .map((e) => e['id'] as String)
            .toList(),
      );

  Future<String> _getUserId() async =>
      (_users ??= await _getIdsOf(A2Query.user)).sample(1).single;

  Future<String> _getBeaconId() async =>
      (_beacons ??= await _getIdsOf(A2Query.beacon)).sample(1).single;

  // ignore: unused_element
  Future<String> _getComments() async =>
      (_comments ??= await _getIdsOf(A2Query.comment)).sample(1).single;
}
