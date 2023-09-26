import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_entity.dart';
import 'a2_service.dart';

class A2Repository {
  var maxBatchSize = 100;
  var faker = A2Faker();
  var service = A2Service();
  var cache = <A2Entity, List<String>>{};

  Future<void> createGeneratedEntity(A2Entity? query, int? count) async =>
      query == null || count == null || count < 1 || count > maxBatchSize
          ? null
          : service.mutate(
              query.mutation,
              {
                'objects': [
                  for (var i = 0; i < count; i++)
                    switch (query) {
                      A2Entity.user => {
                          'public_key': faker.genUserId(),
                          'title': faker.genName(),
                          'description': faker.genText(),
                        },
                      A2Entity.beacon => {
                          'title': faker.genTitle(),
                          'description': faker.genText(),
                          'user_id': await _getEntityId(A2Entity.user),
                          'timerange': faker.genTimerange(),
                          'place': faker.genPlace(),
                        },
                      A2Entity.comment => {
                          'beacon_id': await _getEntityId(A2Entity.beacon),
                          'user_id': await _getEntityId(A2Entity.user),
                          'content': faker.genText(notEmpty: true),
                        },
                      A2Entity.voteUser => {
                          'subject': await _getEntityId(A2Entity.user),
                          'object': await _getEntityId(A2Entity.user),
                          'amount': faker.genInt(10, -1),
                        },
                      A2Entity.voteBeacon => {
                          'subject': await _getEntityId(A2Entity.user),
                          'object': await _getEntityId(A2Entity.beacon),
                          'amount': faker.genInt(10, -1),
                        },
                      A2Entity.voteComment => {
                          'subject': await _getEntityId(A2Entity.user),
                          'object': await _getEntityId(A2Entity.comment),
                          'amount': faker.genInt(10, -1),
                        },
                    }
                ],
              },
            );

  Future<Map?> getEntityCounts() => service.query('''
query {
  user_aggregate { aggregate { count}}
  beacon_aggregate { aggregate { count}}
  comment_aggregate { aggregate { count}}
  vote_user_aggregate { aggregate { count}}
  vote_beacon_aggregate { aggregate { count}}
  vote_comment_aggregate { aggregate { count}}
}
''').then(
        (data) {
          if (data == null) return null;
          data.removeWhere((key, _) => key == '__typename');
          return data.map((k, v) => MapEntry(
                k.replaceFirst('_aggregate', ''),
                v['aggregate']['count'],
              ));
        },
      );

  Future<String> _getEntityId(A2Entity entity) async =>
      (cache[entity] ??= await _getIdsOf(entity)).sample(1).single;

  Future<List<String>> _getIdsOf(A2Entity entity) =>
      service.query(entity.query, {'limit': maxBatchSize}).then(
        (response) => (response![entity.name] as List)
            .map((e) => e['id'] as String)
            .toList(),
      );
}
