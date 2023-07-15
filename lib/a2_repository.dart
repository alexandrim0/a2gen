import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_service.dart';

part 'a2_query.dart';

class A2Repository {
  var maxBatchSize = 100;
  var service = A2Service();
  var faker = A2Faker();

  List<String>? _users;
  List<String>? _beacons;
  List<String>? _comments;

  Future<void> createGeneratedEntity(A2Query? query, int? count) async =>
      query == null || count == null || count < 1 || count > maxBatchSize
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
                      A2Query.voteUser => {
                          'subject': await _getUserId(),
                          'object': await _getUserId(),
                          'amount': faker.genInt(10, -1),
                        },
                      A2Query.voteBeacon => {
                          'subject': await _getUserId(),
                          'object': await _getBeaconId(),
                          'amount': faker.genInt(10, -1),
                        },
                      A2Query.voteComment => {
                          'subject': await _getUserId(),
                          'object': await _getCommentId(),
                          'amount': faker.genInt(10, -1),
                        },
                    }
                ],
              },
            );

  Future<Map?> getEntityCounts() => service.query(_entityCounts).then(
        (data) {
          if (data == null) return null;
          data.removeWhere((key, _) => key == '__typename');
          return data.map((k, v) => MapEntry(
                k.replaceFirst('_aggregate', ''),
                v['aggregate']['count'],
              ));
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
}
