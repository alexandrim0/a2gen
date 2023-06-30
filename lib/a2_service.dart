import 'dart:io';
import 'package:graphql/client.dart';

class A2Service {
  final client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(
      Platform.environment['A2_API_URL'] ?? '',
      defaultHeaders: {
        'x-hasura-admin-secret': Platform.environment['A2_API_SECRET'] ?? '',
      },
    ),
  );

  Future<Map<String, dynamic>?> query(
    String query, [
    Map<String, dynamic> vars = const {},
  ]) async =>
      (await client.query(QueryOptions(
        onComplete: stdout.writeln,
        onError: stdout.writeln,
        document: gql(query),
        variables: vars,
      )))
          .data;

  Future<void> mutate(
    String query, [
    Map<String, dynamic> vars = const {},
  ]) =>
      client.mutate(MutationOptions(
        onCompleted: stdout.writeln,
        onError: stdout.writeln,
        document: gql(query),
        variables: vars,
      ));
}
