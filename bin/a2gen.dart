import 'dart:io';
import 'package:args/args.dart';

import 'package:a2gen/a2_gen.dart';

Future<void> main(List<String> args) async {
  final params = (ArgParser()
        ..addOption('users', abbr: 'u')
        ..addOption('beacons', abbr: 'b')
        ..addOption('comments', abbr: 'c')
        ..addOption('votes', abbr: 'v')
        ..addOption('max', abbr: 'm'))
      .parse(args);

  if (args.isEmpty || params.rest.isNotEmpty) {
    stdout.writeln('''
  - (u)sers    : The number of users to create
  - (b)eacons  : The number of beacons to create
  - (c)omments : The number of comments to create
  - (v)otes    : The number of votes to create
  - (m)ax      : The maxximum size of batch to get and to put (100)
''');
  }

  final count = (
    max: int.tryParse(params['max'] ?? '100')!,
    users: int.tryParse(params['users'] ?? '0')!,
    beacons: int.tryParse(params['beacons'] ?? '0')!,
    comments: int.tryParse(params['comments'] ?? '0')!,
    votes: int.tryParse(params['votes'] ?? '0')!,
  );

  final generator = A2Gen()..maxBatchSize = count.max;

  await generator.createEntity(A2Query.user, count.users);
  await generator.createEntity(A2Query.beacon, count.beacons);
  await generator.createEntity(A2Query.comment, count.comments);
  await generator.createEntity(A2Query.vote, count.votes);

  stdout.writeln(await generator.getEntityCounts());
  exit(0);
}
