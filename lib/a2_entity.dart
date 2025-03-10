enum A2Entity {
  user(r'''
query ($limit: Int!) {
  user(limit: $limit) {
    id
  }
}
''', r'''
mutation ($objects: [user_insert_input!]!) {
  insert_user(objects: $objects) {
    affected_rows
  }
}
'''),

  beacon(r'''
query ($limit: Int!) {
  beacon(limit: $limit) {
    id
  }
}
''', r'''
mutation ($objects: [beacon_insert_input!]!) {
  insert_beacon(objects: $objects) {
    affected_rows
  }
}
'''),

  comment(r'''
query ($limit: Int!) {
  comment(limit: $limit) {
    id
  }
}
''', r'''
mutation ($objects: [comment_insert_input!]!) {
  insert_comment(objects: $objects) {
    affected_rows
  }
}
'''),

  voteUser('', r'''
mutation ($objects: [vote_user_insert_input!]!) {
  insert_vote_user(objects: $objects, on_conflict: {constraint: vote_user_pkey, update_columns: amount}) {
    affected_rows
  }
}
'''),

  voteBeacon('', r'''
mutation ($objects: [vote_beacon_insert_input!]!) {
  insert_vote_beacon(objects: $objects, on_conflict: {constraint: vote_beacon_pkey, update_columns: amount}) {
    affected_rows
  }
}
'''),

  voteComment('', r'''
mutation ($objects: [vote_comment_insert_input!]!) {
  insert_vote_comment(objects: $objects, on_conflict: {constraint: vote_comment_pkey, update_columns: amount}) {
    affected_rows
  }
}
''');

  const A2Entity(this.query, this.mutation);

  final String query, mutation;
}
