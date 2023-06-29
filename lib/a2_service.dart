import 'dart:io';
import 'package:graphql/client.dart';

class A2Service {
  A2Service({
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

  Future<Map<String, dynamic>?> query(
    String query, [
    Map<String, dynamic> vars = const {},
  ]) async =>
      (await _client.query(QueryOptions(
              onComplete: (data) => stdout.writeln(data.toString()),
              onError: (e) => stdout.writeln(e.toString()),
              document: gql(query),
              variables: vars)))
          .data;

  Future<void> mutate(
    String query, [
    Map<String, dynamic> vars = const {},
  ]) =>
      _client.mutate(MutationOptions(
        onCompleted: (data) => stdout.writeln(data.toString()),
        onError: (e) => stdout.writeln(e.toString()),
        document: gql(query),
        variables: vars,
      ));
}
