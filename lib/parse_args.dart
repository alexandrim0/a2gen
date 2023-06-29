import 'package:args/args.dart';

({
  int? max,
  int? users,
  int? beacons,
  int? comments,
  int? votes,
}) parseArgs(List<String> args) {
  final params = (ArgParser()
        ..addOption(
          'users',
          abbr: 'u',
          help: 'The number of users to create',
        )
        ..addOption(
          'beacons',
          abbr: 'b',
          help: 'The number of beacons to create',
        )
        ..addOption(
          'comments',
          abbr: 'c',
          help: 'The number of comments to create',
        )
        ..addOption(
          'votes',
          abbr: 'v',
          help: 'The number of votes to create',
        )
        ..addOption(
          'max',
          abbr: 'm',
          help: 'The maxximum size of batch to get and to put (100)',
        ))
      .parse(args);
  return (
    max: int.tryParse(params['max'] ?? ''),
    users: int.tryParse(params['users'] ?? ''),
    beacons: int.tryParse(params['beacons'] ?? ''),
    comments: int.tryParse(params['comments'] ?? ''),
    votes: int.tryParse(params['votes'] ?? ''),
  );
}
