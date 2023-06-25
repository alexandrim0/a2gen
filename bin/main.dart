import 'dart:io';
import 'package:a2gen/a2gen.dart';
import 'package:yaml/yaml.dart';
import 'package:graphql/client.dart';

Future<void> main(List<String> arguments) async {
  final configFile = File('credentials.yaml');
  final yamlString = await configFile.readAsString();
  final dynamic yamlMap = loadYaml(yamlString);
  final adminSecret = yamlMap['admin secret'];
  final serverUrl = yamlMap['server url'];


  final link = HttpLink(serverUrl, defaultHeaders: {'x-hasura-admin-secret': adminSecret} );


  // Create a GraphQL client
  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );

  final gen = FakeGenerator(DbWriter(client));

  gen.generateContent(
      numUsers: 2, numBeacons: 1, numComments: 4, numVotes: 10);

  final _httpLink = HttpLink(
    'https://api.github.com/graphql',
  );

}
