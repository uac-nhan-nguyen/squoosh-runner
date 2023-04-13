# squoosh-runner
This service receives image, write to local, optimize image using `@squoosh/cli`, 
then host that image statically for download


[Squoosh handler](/lib/squoosh.dart)

## Installation

Install dart

```
dart pub get
```

## Development

```
dart src/main.dart
```

## Deployment

Create a release to trigger Github action, that will build and upload package to S3

[workflow](./.github/workflows/build.workflow.yml)

Then launch ec2 with script:

[script](./ec2script)


