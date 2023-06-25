A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

### Usage

Compile the `main.dart` binary, add `credentials.yaml` file (see below) and run as follows:

```
main -u 1 -b 2 -c 3 -v 4
```

this command will generate:

* 1 user
* 2 beacons
* 3 comments
* 4 votes (amount is random -1-10)

Important note: for beacons, comments and votes, the author/source/target are randomly selected from
among *all* the objects available in the database.

### Credentials

To use, create the `credentials.yaml` file in the repository root.
The file should be the following format:

``` yaml
admin secret: "your_hasura_admin_secret"
server url: "https://path.to.your.hasura.server/v1/graphql"
```

While the file is in `.gitignore`, be careful not to commit the file to your repository.
