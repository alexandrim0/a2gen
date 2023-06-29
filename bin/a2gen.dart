import 'dart:io';

import 'package:a2gen/a2_query.dart';
import 'package:a2gen/parse_args.dart';
import 'package:a2gen/a2_repository.dart';

Future<void> main(List<String> args) async {
  final count = parseArgs(args);
  final repository = A2Repository()..maxBatchSize = count.max;

  await repository.createEntity(A2Query.user, count.users);
  await repository.createEntity(A2Query.beacon, count.beacons);
  await repository.createEntity(A2Query.comment, count.comments);
  await repository.createEntity(A2Query.vote, count.votes);

  print('Done!');
  exit(0);
}
