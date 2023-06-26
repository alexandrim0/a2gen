part of 'api_service.dart';

const _createBeaconMutate = r'''
mutation ($author_id: String, $description: String, $title: String) {
  insert_beacon_one(object: {author_id: $author_id, description: $description, title: $title}) {
    id
  }
}
''';

const _createOrUpdateVoteMutate = r'''
mutation ($src: uuid, $dst: uuid, $amount: Int) {
  insert_votes_one(object: {src: $src, dst: $dst, amount: $amount}, on_conflict: {constraint: votes_pkey, update_columns: [amount]})
}
''';

const _createUserMutate = r'''
mutation ($author: String, $content: String, $parent: uuid) {
  insert_comment_one(object: {author: $author, content: $content, parent: $parent}) {
    uid
  }
}
''';

const _createUserQuery = r'''
mutation ($id: String!, $display_name: String!, $description: String) {
  insert_user_one(object: {id: $id, display_name: $display_name, description: $description}) {
    uid
  }
}
''';
