import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_service.dart';

part 'a2_query.dart';

class A2Gen {
  var maxBatchSize = 100;
  var service = A2Service();
  var faker = A2Faker();

  List<String>? _users;
  List<String>? _beacons;
  List<String>? _comments;

  Future<void> createEntity(A2Query query, int? count) async =>
      count == null || count < 1 || count > maxBatchSize
          ? null
          : service.mutate(
              query.mutation,
              {
                'objects': [
                  for (var i = 0; i < count; i++)
                    switch (query) {
                      A2Query.user => {
                          'id': faker.genUserId(),
                          'title': faker.genName(),
                          'description': faker.genText(),
                        },
                      A2Query.beacon => {
                          'title': faker.genTitle(),
                          'description': faker.genText(),
                          'user_id': await _getUserId(),
                          'timerange': faker.genTimerange(),
                          'place': faker.genPlace(),
                        },
                      A2Query.comment => {
                          'beacon_id': await _getBeaconId(),
                          'user_id': await _getUserId(),
                          'content': faker.genText(notEmpty: true),
                        },
                      A2Query.vote => {
                          'subject': await _getUserId(),
                          'amount': faker.genInt(10, -1),
                          ...await _getObjectId(),
                        },
                    }
                ],
              },
            );

  Future<Object> getEntityCounts() => service.query(_entityCounts).then(
        (data) => {
          'users': data?['user_aggregate']['aggregate']['count'],
          'beacons': data?['beacon_aggregate']['aggregate']['count'],
          'comments': data?['comment_aggregate']['aggregate']['count'],
          'votes': data?['vote_aggregate']['aggregate']['count'],
        },
      );

  Future<List<String>> _getIdsOf(A2Query entity) =>
      service.query(entity.query, {'limit': maxBatchSize}).then(
        (response) => (response![entity.name] as List)
            .map((e) => e['id'] as String)
            .toList(),
      );

  Future<String> _getUserId() async =>
      (_users ??= await _getIdsOf(A2Query.user)).sample(1).single;

  Future<String> _getBeaconId() async =>
      (_beacons ??= await _getIdsOf(A2Query.beacon)).sample(1).single;

  Future<String> _getCommentId() async =>
      (_comments ??= await _getIdsOf(A2Query.comment)).sample(1).single;

  Future<Map<String, String>> _getObjectId() async => switch (faker.genInt(3)) {
        0 => {'user_id': await _getUserId()},
        1 => {'beacon_id': await _getBeaconId()},
        2 => {'comment_id': await _getCommentId()},
        _ => {},
      };
}
