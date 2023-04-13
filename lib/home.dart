import 'package:shelf_plus/shelf_plus.dart';

Future<Response> home(Request request) async {
  final baseUri = Uri(
    scheme: request.requestedUri.scheme,
    host: request.requestedUri.host,
  );
  final example = '''curl --request POST \
--url '${baseUri.toString()}/quoosh?type=webp&width=1600' \
--header 'Content-Type: image/jpeg' \
--header 'api-key: API_KEY' \
--data BINARY_DATA''';

  final html = '''
<!DOCTYPE HTML>
<html lang="en">
<head>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="/styles/prism-coy-without-shadows.css"/>

    <style>
      code[class*="language-"], pre[class*="language-"] {
          font-size: 12px;
          white-space: pre-wrap;
          word-break: break-word;
      }
      li {
        margin-left: 12px;
      }
    </style>
</head>
<body class="bg-slate-800 text-white">
<h1 class="grid justify-center text-bold text-3xl mt-[12px]">Image optimizer</h1>



<div class="px-8 py-8">

<strong>Endpoint</strong> 
<br/>
<code>POST ${baseUri.toString()}/squoosh</code>
<br/>
<br/>
Query parameters:
<ul>
  <li>type: <code>webp</code> | <code>png</code> | <code>jpeg</code></li>
  <li>width: Resize image to this width</li>
</ul>

<br/>
<h2>Example</h2>
<pre class="language-bash overflow-auto">
    <code class="">${example}</code>
</pre>
</div>
</body>

</html>
  ''';
  return Response(200, body: html, headers: {'content-type': 'text/html'});
}
