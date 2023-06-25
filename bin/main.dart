import 'dart:io';
import 'package:a2gen/a2gen.dart';
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:graphql/client.dart';

Future<void> main(List<String> args) async {
  // Read the credentials file
  final configFile = File('credentials.yaml');
  final yamlString = await configFile.readAsString();
  final dynamic yamlMap = loadYaml(yamlString);
  final adminSecret = yamlMap['admin secret'];
  final serverUrl = yamlMap['server url'];

  // Parse the command line arguments
  var parser = ArgParser()
    ..addOption('users', abbr: 'u', help: "The number of users to create")
    ..addOption('beacons', abbr: 'b', help: "The number of beacons to create")
    ..addOption('comments', abbr: 'c', help: "The number of comments to create")
    ..addOption('votes', abbr: 'v', help: "The number of votes to create");
  final parsed = parser.parse(args);

  final users = int.tryParse(parsed['users'] ?? '') ?? 0;
  final beacons = int.tryParse(parsed['beacons'] ?? '') ?? 0;
  final comments = int.tryParse(parsed['comments'] ?? '') ?? 0;
  final votes = int.tryParse(parsed['votes'] ?? '') ?? 0;

  // Create the GraphQL client
  final link = HttpLink(serverUrl,
      defaultHeaders: {'x-hasura-admin-secret': adminSecret});
  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );

  // Generate the fake content
  final gen = FakeGenerator(DbWriter(client));
  gen.generateContent(
      numUsers: users,
      numBeacons: beacons,
      numComments: comments,
      numVotes: votes);
}
