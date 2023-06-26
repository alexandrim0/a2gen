import 'package:args/args.dart';

typedef Params = ({
  int? numUsers,
  int? numVotes,
  int? numBeacons,
  int? numComments,
});

Params parseArgs(List<String> args) {
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
        ))
      .parse(args);
  return (
    numUsers: int.tryParse(params['users'] ?? ''),
    numVotes: int.tryParse(params['votes'] ?? ''),
    numBeacons: int.tryParse(params['beacons'] ?? ''),
    numComments: int.tryParse(params['comments'] ?? ''),
  );
}
