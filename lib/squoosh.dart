import 'dart:convert';
import 'dart:io';

import 'package:shelf_plus/shelf_plus.dart';
import 'package:squoosh_runner/constants.dart';
import 'package:uuid/uuid.dart';

late final uuid = Uuid();

Future<Response> uploadHandler(Request request) async {
  final w = int.tryParse(request.requestedUri.queryParameters['width'] ?? '1600');
  final quality = int.tryParse(request.requestedUri.queryParameters['quality'] ?? '');
  final type = request.requestedUri.queryParameters['type'];
  final String jobId = uuid.v4();
  final List<int> bytes = await request.body.asBinary.toList().then((value) => value.expand((element) => element).toList(growable: false));
  final filename = '${jobId}';
  await File(inputDir.path + '/' + filename).writeAsBytes(bytes);

  await convert(filename, width: w, type: type, quality: quality);
  final outputFilename = filename +
      (type == 'png'
          ? '.png'
          : type == 'webp'
              ? '.webp'
              : '.jpg');

  return Response(200,
      body: jsonEncode({
        'filename': filename,
        'size': File('${outputDir.path}/${outputFilename}').lengthSync(),
        'url': Uri(scheme: request.requestedUri.scheme, port: request.requestedUri.port, host: request.requestedUri.host, path: '${outputDir.path.replaceAll(publicDir.path, '')}/${outputFilename}').toString(),
      }));
}

Future<void> convert(
  String filename, {
  String? type,
  int? width,
  int? height,
  int? quality,
}) async {
  // squoosh-cli -d output input/cbbca148-6b69-492f-8bfa-70346ebc7a41.jpeg --webp "{}"
  // squoosh-cli -d output input/cbbca148-6b69-492f-8bfa-70346ebc7a41.jpeg --mozjpeg "{}"
  // squoosh-cli -d output input/cbbca148-6b69-492f-8bfa-70346ebc7a41.jpeg --mozjpeg "{}" --resize '{width:200}'

  String params = '-d ${outputDir.path} ${inputDir.path}/${filename}';

  if (width != null || height != null) {
    params += ' --resize ${jsonEncode({
          if (width != null) 'width': width,
          if (height != null) 'height': height,
        })}';
  }
  print('PARAM ${params}');
  final p = await Process.start('squoosh-cli', [
    ...params.split(' '),
    if (type == 'png') ...[
      "--oxipng",
      "{ }"
    ] else if (type == 'webp') ...[
      "--webp",
      "{ }"
    ] else ...[
      "--mozjpeg",
      jsonEncode({
        if (quality != null) 'quality': quality,
      })
    ]
  ]);
  final running = _RunProcess(p);
  await p.exitCode;
  print(running.fullLogs);
  // print(r.stdout);
  // print(r.stderr);
}

class _RunProcess {
  String? command;
  final Process process;
  final logs = <String>[];
  int? completed;

  String get fullLogs => logs.join();

  _RunProcess(
    this.process, {
    this.command,
  }) {
    process.stdout.listen((e) => logs.add(utf8.decode(e)));
    process.stderr.listen((e) => logs.add(utf8.decode(e)));
    process.exitCode.then((exitCode) {
      completed = exitCode;
    });
  }
}
