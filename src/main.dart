import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_plus/shelf_plus.dart';
import 'package:squoosh_runner/apiAuthorizer.dart';
import 'package:squoosh_runner/constants.dart';
import 'package:squoosh_runner/home.dart';
import 'package:squoosh_runner/squoosh.dart';

void main() async {
  final app = Router().plus;
  app.use(logRequests());
  app.get('/', home);

  final authApp = Router().plus;
  authApp.use(logRequests());
  authApp.use(apiAuthorizer());
  authApp.post('/squoosh', uploadHandler);

  inputDir.createSync(recursive: true);
  outputDir.createSync(recursive: true);
  publicDir.createSync(recursive: true);

  final staticHandler = createStaticHandler(publicDir.path);

  final handler = Cascade().add(app).add(authApp).add(staticHandler).handler;

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, int.parse(Platform.environment['PORT'] ?? "7001"));

  // Enable content compression
  server.autoCompress = true;

  final url = 'http://localhost:${server.port}';
  print('Host [${server.address.host}]. Serving at ${url}');
}
