part of 'a2_gen.dart';

enum A2Query {
  user(
    r'query ($limit: Int!) { user( limit: $limit) { id}}',
    r'mutation ($objects: [user_insert_input!]!)'
        r'{ insert_user(objects: $objects) { affected_rows}}',
  ),
  beacon(
    r'query ($limit: Int!) { beacon( limit: $limit) { id}}',
    r'mutation ($objects: [beacon_insert_input!]!)'
        r'{ insert_beacon(objects: $objects) { affected_rows}}',
  ),
  comment(
    r'query ($limit: Int!) { comment( limit: $limit) { id}}',
    r'mutation ($objects: [comment_insert_input!]!)'
        r'{ insert_comment(objects: $objects) { affected_rows}}',
  ),
  vote(
    '',
    r'mutation ($objects: [vote_insert_input!]!) { insert_vote(objects: $objects,'
        'on_conflict: { constraint: vote_subject_user_id_beacon_id_comment_id_key,'
        ' update_columns: amount}) { affected_rows}}',
  );

  const A2Query(this.query, this.mutation);

  final String query, mutation;
}

const _entityCounts = '''
query EntityCounts {
  vote_aggregate { aggregate { count}}
  user_aggregate { aggregate { count}}
  beacon_aggregate { aggregate { count}}
  comment_aggregate { aggregate { count}}
}
''';
