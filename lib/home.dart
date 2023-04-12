import 'package:shelf_plus/shelf_plus.dart';

Future<Response> home(Request request) async {
  const html = '''
<!DOCTYPE HTML>
<html lang="en">
<head>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-800 text-white">
<h1 class="grid justify-center text-bold text-3xl mt-[12px]">Image optimizer</h1>
</body>
</html>
  ''';
  return Response(200, body: html, headers: {'content-type': 'text/html'});
}
