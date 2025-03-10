import 'dart:io';
import 'package:args/args.dart';
import 'package:collection/collection.dart';

import 'package:a2gen/a2_entity.dart';
import 'package:a2gen/a2_repository.dart';

Future<void> main(List<String> args) async {
  final params = (ArgParser()
        ..addOption(A2Entity.user.name, abbr: 'u')
        ..addOption(A2Entity.beacon.name, abbr: 'b')
        ..addOption(A2Entity.comment.name, abbr: 'c')
        ..addOption(A2Entity.voteUser.name, abbr: 'U')
        ..addOption(A2Entity.voteBeacon.name, abbr: 'B')
        ..addOption(A2Entity.voteComment.name, abbr: 'C')
        ..addOption('max', abbr: 'm'))
      .parse(args);

  if (params.rest.isNotEmpty) {
    stdout.writeln('''
  - (u)ser        : The number of users to create
  - (b)eacon      : The number of beacons to create
  - (c)omment     : The number of comments to create
  - vote(U)ser    : The number of votes for user to create
  - vote(B)eacon  : The number of votes for beacon to create
  - vote(C)omment : The number of votes for comment to create
  - (m)ax         : The maxximum size of batch to get and to put (100)
''');
  } else {
    final generator = A2Repository()
      ..maxBatchSize = int.parse(params['max'] ?? '100');

    for (final option in params.options) {
      await generator.createGeneratedEntity(
        A2Entity.values.singleWhereOrNull((e) => e.name == option),
        int.tryParse(params[option]),
      );
    }
    stdout.writeln(await generator.getEntityCounts());
  }
  exit(0);
}
