import 'dart:math';

import 'dart:io';
import 'package:gdatagen/gdatagen.dart';
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

  ///final _authLink = AuthLink(getToken: () async => 'Bearer $YOUR_PERSONAL_ACCESS_TOKEN',);

  ///Link _link = _authLink.concat(_httpLink);

  /// subscriptions must be split otherwise `HttpLink` will. swallow them
  /*
  if (websocketEndpoint != null){
    final _wsLink = WebSocketLink(websockeEndpoint);
    _link = Link.split((request) => request.isSubscription, _wsLink, _link);
  }

  final GraphQLClient client = GraphQLClient(
    /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(),
    link: _link,
  );
   */
}
