A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.


### Credentials
To use, create the `credentials.yaml` file in the repository root.
The file should be the following format:
``` yaml
admin secret: "your_hasura_admin_secret"
server url: "https://path.to.your.hasura.server/v1/graphql"
```
While the file is in `.gitignore`, be careful not to commit the file to your repository.
