enum A2Query {
  user(
    'query { user( limit: 100) { id}}',
    r'mutation ($objects: [user_insert_input!]!)'
        r'{ insert_user(objects: $objects) { affected_rows}}',
  ),
  beacon(
    'query { beacon( limit: 100) { id}}',
    r'mutation ($objects: [beacon_insert_input!]!)'
        r'{ insert_beacon(objects: $objects) { affected_rows}}',
  ),
  comment(
    'query { comment( limit: 100) { id}}',
    r'mutation ($objects: [comment_insert_input!]!)'
        r'{ insert_comment(objects: $objects) { affected_rows}}',
  ),
  vote(
    '',
    r'mutation ($objects: [vote_insert_input!]!) { insert_vote(objects: $objects,'
        'on_conflict: { constraint: vote_pkey, update_columns: amount}) { affected_rows}}',
  );

  const A2Query(this.query, this.mutation);

  final String query, mutation;
}
