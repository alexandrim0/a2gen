import 'package:collection/collection.dart';

import 'a2_faker.dart';
import 'a2_entity.dart';
import 'a2_api_service.dart';

class A2ApiRepository {
  List<String>? users;
  List<String>? beacons;
  List<String>? comments;

  A2ApiRepository({
    A2Faker? faker,
    A2ApiService? repository,
  })  : _faker = faker ?? A2Faker(),
        _repository = A2ApiService();

  final A2Faker _faker;
  final A2ApiService _repository;

  Future<void> createUsers(int count) async => count < 1 || count > 100
      ? null
      : _repository.mutate(
          A2Entity.user.mutation,
          {
            'objects': [
              for (var i = 0; i < count; i++)
                {
                  'id': _faker.genUserId(),
                  'display_name': _faker.genName(),
                  'description': _faker.genText(),
                }
            ],
          },
        );

  Future<void> createBeacons(int count) async => count < 1 || count > 100
      ? null
      : _repository.mutate(
          A2Entity.beacon.mutation,
          {
            'objects': [
              for (var i = 0; i < count; i++)
                {
                  'title': _faker.genTitle(),
                  'description': _faker.genText(),
                  'user_id': await _getUserId(),
                  'place': _faker.genCoords(),
                  'timerange': _faker.genTimerange(),
                }
            ],
          },
        );

  Future<void> createComments(int count) async => count < 1 || count > 100
      ? null
      : _repository.mutate(
          A2Entity.comment.mutation,
          {
            'objects': [
              for (var i = 0; i < count; i++)
                {
                  'beacon_id': await _getBeaconId(),
                  'user_id': await _getUserId(),
                  'content': _faker.genText(),
                }
            ],
          },
        );

  /// Add votes. Select the target (user, beacon or comment)
  /// randomly from the concatenated list of target UIDs.
  /// 1 in ten votes on average should be negative
  Future<void> createOrUpdateVotes(int count) async => count < 1 || count > 100
      ? null
      : _repository.mutate(
          A2Entity.vote.mutation,
          {
            'objects': [
              // TBD: make them unique for this bunch
              for (var i = 0; i < count; i++)
                {
                  'subject': await _getUserId(),
                  // TBD: vote for comment and user also
                  'object': await _getBeaconId(),
                  'amount': _faker.genAmount(min: -1),
                }
            ],
          },
        );

  Future<String> _getUserId() async =>
      (users ??= await _getIdsOf(A2Entity.user)).sample(1).single;

  Future<String> _getBeaconId() async =>
      (beacons ??= await _getIdsOf(A2Entity.beacon)).sample(1).single;

  // ignore: unused_element
  Future<List<String>> _getComments() async =>
      comments ??= await _getIdsOf(A2Entity.comment);

  Future<List<String>> _getIdsOf(A2Entity entity) async =>
      ((await _repository.query(entity.query))?[entity.name] as List)
          .map((e) => e['id'] as String)
          .toList();
}
