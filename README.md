A sample command-line application with an entrypoint in `bin/`, library code in `lib/`.

### Usage

Compile the `a2gen.dart` binary, export `A2_API_URL` and `A2_API_SECRET` (see below) and run as follows:

```
a2gen.exe -u 1 -b 2 -c 3 -v 4
```

this command will generate:

* 1 user
* 2 beacons
* 3 comments
* 4 votes (amount is random -1-10)

Important note: for beacons, comments and votes, the author/source/target are randomly selected from
among *all* the objects available in the database.

### Credentials

To use, export env vars:
  - `A2_API_URL` for API endpoint
  - `A2_API_SECRET` for admin secret
