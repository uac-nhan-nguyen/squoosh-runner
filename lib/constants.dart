import 'dart:io';

import 'package:ds_env/ds_env.dart';

// ENV
late final _secrets = Env('./.secrets');
late final API_KEY = _secrets['API_KEY'];

late final inputDir = Directory('./input');
late final publicDir = Directory('./public');
late final outputDir = Directory('./public/output');
