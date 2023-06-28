import 'dart:io';
import 'package:graphql/client.dart';

class A2ApiService {
  A2ApiService({
    String? serverUrl,
    String? adminSecret,
  }) : _client = GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink(
            serverUrl ?? Platform.environment['A2_API_URL']!,
            defaultHeaders: {
              'x-hasura-admin-secret':
                  adminSecret ?? Platform.environment['A2_API_SECRET']!,
            },
          ),
        );

  final GraphQLClient _client;

  Future<Map<String, Object?>?> query(String query) async =>
      (await _client.query(QueryOptions(
        onComplete: (data) => stdout.writeln(data.toString()),
        onError: (e) => stdout.writeln(e.toString()),
        document: gql(query),
      )))
          .data;

  Future<void> mutate(String query, [Map<String, Object?>? vars]) =>
      _client.mutate(MutationOptions(
        onCompleted: (data) => stdout.writeln(data.toString()),
        onError: (e) => stdout.writeln(e.toString()),
        document: gql(query),
        variables: vars ?? const {},
      ));
}
