import 'package:args/args.dart';

({
  int users,
  int beacons,
  int comments,
  int votes,
}) parseArgs(List<String> args) {
  final params = (ArgParser()
        ..addOption(
          'users',
          abbr: 'u',
          help: 'The number of users to create (0 to 100)',
        )
        ..addOption(
          'beacons',
          abbr: 'b',
          help: 'The number of beacons to create (0 to 100)',
        )
        ..addOption(
          'comments',
          abbr: 'c',
          help: 'The number of comments to create (0 to 100)',
        )
        ..addOption(
          'votes',
          abbr: 'v',
          help: 'The number of votes to create (0 to 100)',
        ))
      .parse(args);
  return (
    users: int.tryParse(params['users'] ?? '') ?? 0,
    beacons: int.tryParse(params['beacons'] ?? '') ?? 0,
    comments: int.tryParse(params['comments'] ?? '') ?? 0,
    votes: int.tryParse(params['votes'] ?? '') ?? 0,
  );
}
