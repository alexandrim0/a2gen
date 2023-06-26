import 'dart:math';
import 'package:faker/faker.dart';
import 'package:graphql/client.dart';

part 'gql_queries.dart';

class ApiService {
  ApiService({
    required String serverUrl,
    required String adminSecret,
  }) : _client = GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink(
            serverUrl,
            defaultHeaders: {'x-hasura-admin-secret': adminSecret},
          ),
        );

  final GraphQLClient _client;
  final _rng = Random();

  Future<List<String>> getUIDs({
    required String objType,
    String objField = 'uid',
  }) async {
    // Read the list of uids for the given object type
    final queryResult = await _client.query(
      QueryOptions(document: gql('query {$objType{$objField}}')),
    );
    if (queryResult.hasException) {
      throw Exception('Error: ${queryResult.exception.toString()}');
    }
    return queryResult.data?[objType]
            .map<String>((x) => x[objField] as String)
            .toList() ??
        [];
  }

  Future<void> createBeacon(String creatorUid) => _mutate(
        query: _createBeaconMutate,
        vars: {
          'author_id': creatorUid,
          'title': faker.lorem.sentence(),
          'description': faker.lorem.sentences(3).join(' ')
        },
      );

  Future<void> createOrUpdateVote({
    required String authorUid,
    required String target,
    required int amount,
  }) =>
      _mutate(
        query: _createOrUpdateVoteMutate,
        vars: {
          'src': authorUid,
          'dst': target,
          'amount': amount.toString(),
        },
      );

  Future<void> createComment({
    required String authorId,
    required String beaconId,
  }) =>
      _mutate(
        query: _createUserMutate,
        vars: {
          'author': authorId,
          'content': faker.lorem.sentences(1).join(' '),
          'parent': beaconId
        },
      );

  Future<void> createUser() => _mutate(
        query: _createUserQuery,
        vars: {
          'display_name':
              '${faker.person.firstName()} ${faker.person.lastName()}',
          'id': _generateRandomId(),
          'description': faker.lorem.sentences(1).join(' '),
        },
      );

  Future<void> _mutate({
    required String query,
    required Map<String, String> vars,
  }) =>
      _client.mutate(
        MutationOptions(document: gql(query), variables: vars),
      );

  String _generateRandomId([int len = 28]) {
    const alphabet =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final buffer = StringBuffer();
    for (var i = 0; i < len; i++) {
      buffer.write(alphabet[_rng.nextInt(alphabet.length)]);
    }
    return buffer.toString();
  }
}
