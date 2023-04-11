import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_plus/shelf_plus.dart';
import 'package:squoosh_runner/apiAuthorizer.dart';
import 'package:squoosh_runner/constants.dart';
import 'package:squoosh_runner/job.dart';


void main() async {
  final authApp = Router().plus;
  authApp.use(logRequests());
  authApp.use(apiAuthorizer());
  authApp.post('/job', addJob);

  outputDir.createSync(recursive: true);
  publicDir.createSync(recursive: true);

  final staticHandler = createStaticHandler(publicDir.path);

  final handler = Cascade().add(authApp).add(staticHandler).handler;

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, int.parse(Platform.environment['PORT'] ?? "7001"));

  // Enable content compression
  server.autoCompress = true;

  final url = 'http://${server.address.host}:${server.port}';
  print('Serving at ${url}');

  // final ans = await http.get(Uri.parse(url));
  // print(toPrettyJson(json.decode(ans.body)));
}
