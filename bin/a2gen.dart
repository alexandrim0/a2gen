import 'dart:io';

import 'package:a2gen/parse_args.dart';
import 'package:a2gen/a2_api_repository.dart';

Future<void> main(List<String> args) async {
  final count = parseArgs(args);
  final repository = A2ApiRepository();

  await repository.createUsers(count.users);
  await repository.createBeacons(count.beacons);
  await repository.createComments(count.comments);
  await repository.createOrUpdateVotes(count.votes);

  print('Done!');
  exit(0);
}
