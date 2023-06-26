import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:a2gen/utils.dart';
import 'package:a2gen/api_service.dart';

Future<void> main(List<String> args) async {
  final params = parseArgs(args);
  final apiService = ApiService(
    serverUrl: Platform.environment['A2_API_URL']!,
    adminSecret: Platform.environment['A2_API_SECRET']!,
  );

  if (params.numUsers != null) {
    // Add users
    for (int i = 0; i < params.numUsers!; i++) {
      await apiService.createUser();
    }
  }

  if (params.numVotes == null &&
      params.numBeacons == null &&
      params.numComments == null) return;

  // Add beacons. Select authors randomly from existing users.
  final users = await apiService.getUIDs(objType: 'user', objField: 'id');

  if (params.numBeacons != null) {
    for (var i = 0; i < params.numBeacons!; i++) {
      await apiService.createBeacon(users.sample(1).single);
    }
  }

  if (params.numVotes == null || params.numComments == null) return;

  // Add comments. Select authors and beacons randomly from existing ones.
  final beacons = await apiService.getUIDs(objType: 'beacon', objField: 'id');

  if (params.numComments != null) {
    for (var i = 0; i < params.numComments!; i++) {
      await apiService.createComment(
        authorId: users.sample(1).single,
        beaconId: beacons.sample(1).single,
      );
    }
  }

  if (params.numVotes != null) {
    // Add votes. Select the target (beacon or comment)
    // randomly from the concatenated list of target UIDs.
    final targets = beacons + await apiService.getUIDs(objType: 'comments');
    final usersUids = await apiService.getUIDs(objType: 'user');
    final rng = Random();

    for (var i = 0; i < params.numVotes!; i++) {
      // 1 in ten votes on average should be negative
      await apiService.createOrUpdateVote(
        authorUid: usersUids.sample(1).single,
        target: targets.sample(1).single,
        amount: rng.nextInt(10) - 1,
      );
    }
  }
}
