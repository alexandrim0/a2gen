import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_service.dart';

class A2Gen {
  var maxBatchSize = 100;
  var service = A2Service();
  var faker = A2Faker();

  List<String>? _users;
  List<String>? _beacons;
  List<String>? _comments;
  List<String>? _allIds;

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
                          'object': await _getAnyId(),
                          'amount': faker.genAmount(min: -1),
                        },
                    }
                ],
              },
            );

  Future<Object> getEntityCounts() => service
      .query('query {entity_counts { users beacons comments votes}}')
      .then((response) => (response?['entity_counts'] as List).first);

  Future<List<String>> _getIdsOf(A2Query entity) =>
      service.query(entity.query, {'limit': maxBatchSize}).then(
        (response) => (response?[entity.name] as List)
            .map((e) => e['id'] as String)
            .toList(),
      );

  Future<String> _getUserId() async =>
      (_users ??= await _getIdsOf(A2Query.user)).sample(1).single;

  Future<String> _getBeaconId() async =>
      (_beacons ??= await _getIdsOf(A2Query.beacon)).sample(1).single;

  Future<String> _getAnyId() async => (_allIds ??= [
        ...(_users ??= await _getIdsOf(A2Query.user)),
        ...(_beacons ??= await _getIdsOf(A2Query.beacon)),
        ...(_comments ??= await _getIdsOf(A2Query.comment)),
      ])
          .sample(1)
          .single;
}

enum A2Query {
  user(
    r'query ($limit: Int!) { user( limit: $limit) { id}}',
    r'mutation ($objects: [user_insert_input!]!)'
        r'{ insert_user(objects: $objects) { affected_rows}}',
  ),
  beacon(
    r'query ($limit: Int!) { beacon( limit: $limit) { id}}',
    r'mutation ($objects: [beacon_insert_input!]!)'
        r'{ insert_beacon(objects: $objects) { affected_rows}}',
  ),
  comment(
    r'query ($limit: Int!) { comment( limit: $limit) { id}}',
    r'mutation ($objects: [comment_insert_input!]!)'
        r'{ insert_comment(objects: $objects) { affected_rows}}',
  ),
  vote(
    '',
    r'mutation ($objects: [vote_insert_input!]!) { insert_vote(objects: $objects,'
        'on_conflict: { constraint: vote_pkey, update_columns: amount}) { affected_rows}}',
  );

  const A2Query(this.query, this.mutation);

  final String query, mutation;
}
