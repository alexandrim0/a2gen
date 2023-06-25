import 'dart:math';

import 'package:faker/faker.dart';
import 'package:graphql/client.dart';
import 'package:collection/collection.dart';

final Random rng = Random();

String generateRandomId([int len = 28]) {
  const base62Alphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final buffer = StringBuffer();
  for (var i = 0; i < len; i++) {
    buffer.write(base62Alphabet[rng.nextInt(base62Alphabet.length)]);
  }
  return buffer.toString();
}

class DbWriter {
  final GraphQLClient client;

  DbWriter(this.client) {}

  Future<List<String>> getUIDs(String objType,
      [String objField = "uid"]) async {
    // Read the list of uids for the given object type
    final queryResult = await client.query(QueryOptions(
      document: gql('''
      query {
        $objType{
        $objField
        }
      }
    '''),
    ));

    if (queryResult.hasException) {
      throw Exception('Error: ${queryResult.exception.toString()}');
    }
    return queryResult.data?[objType]
            .map<String>((x) => x[objField] as String)
            .toList() ??
        [];
  }

  Future<String> createBeacon(String creatorUid) async {
    final result = await mutate(r'''
    mutation ($author_id: String, $description: String, $title: String) {
    insert_beacon_one(object: {author_id: $author_id, description: $description, title: $title}) {
    id }}
    ''', <String, String>{
      "author_id": creatorUid,
      "title": faker.lorem.sentence(),
      "description": faker.lorem.sentences(3).join(' ')
    });
    return result.data?['insert_beacon_one']?['id'] as String;
  }

  Future createOrUpdateVote(
      String creatorUid, String target, int amount) async {
    final result = await mutate(r'''
    mutation ($src: uuid, $dst: uuid, $amount: Int) {
    insert_votes_one(object: {src: $src, dst: $dst, amount: $amount}, 
     on_conflict: {
      constraint: votes_pkey,
      update_columns: [amount]
    }
    
    ) {}}
    ''', <String, String>{
      "src": creatorUid,
      "dst": target,
      "amount": amount.toString()
    });

    //return result.data?['insert_votes_one']?['uid'] as String;
  }

  Future<QueryResult> mutate(String txt, Map<String, String> vars) async {
    final result = await client
        .mutate(MutationOptions(document: gql(txt), variables: vars));
    if (result.hasException) {
      throw ('Error: ${result.exception.toString()}');
    }
    return result;
  }

  Future<String> createComment(String creatorId, String parentPost) async {
    final result = await mutate(r'''
    mutation ($author: String, $content: String, $parent: uuid) {
    insert_comment_one(object: {author: $author, content: $content, parent: $parent}) {
    uid }}
    ''', <String, String>{
      "author": creatorId,
      "content": faker.lorem.sentences(1).join(' '),
      "parent": parentPost
    });
    return result.data?['insert_comment_one']?['uid'] as String;
  }

  Future<String> createUser() async {
    // Add a new user
    final result = await mutate(r'''
      mutation ($id: String!, $display_name: String!, $description: String) {
        insert_user_one(object: {id: $id, display_name: $display_name, description: $description}){uid}
      }
    ''', <String, String>{
      "display_name": "${faker.person.firstName()} ${faker.person.lastName()}",
      "id": generateRandomId(),
      "description": faker.lorem.sentences(1).join(' '),
    });

    return result.data?['insert_user_one']?['uid'] as String;
  }
}

class FakeGenerator {
  final DbWriter dbWriter;

  FakeGenerator(this.dbWriter);

  void generateContent(
      {int numUsers = 0,
      int numBeacons = 0,
      int numComments = 0,
      int numVotes = 0}) async {
    // Add users
    for (int i = 0; i < numUsers; i++) {
      await dbWriter.createUser();
    }

    // Add beacons. Select authors randomly from existing users.
    final users = await dbWriter.getUIDs("user", "id");
    for (int i = 0; i < numBeacons; i++) {
      await dbWriter.createBeacon(users.sample(1).single);
    }

    // Add comments. Select authors and beacons randomly from existing ones.
    final beacons = await dbWriter.getUIDs("beacon", "id");
    for (int i = 0; i < numComments; i++) {
      final author = users.sample(1).single;
      final beacon = beacons.sample(1).single;
      await dbWriter.createComment(author, beacon);
    }

    // Add votes. Select the target (beacon or comment)
    // randomly from the concatenated list of target UIDs.
    final comments = await dbWriter.getUIDs("comments");
    final targets = comments + beacons;
    final usersUids = await dbWriter.getUIDs("user");
    for (int i = 0; i < numVotes; i++) {
      final author = usersUids.sample(1).single;
      final tgt = targets.sample(1).single;
      // 1 in ten votes on average should be negative
      final voteAmount = rng.nextInt(10) - 1;
      await dbWriter.createOrUpdateVote(author, tgt, voteAmount);
    }
  }
}
