import 'package:shelf/shelf.dart';

import 'constants.dart';

Middleware apiAuthorizer() {
  return (innerHandler) {
    return (request) {
      if (request.headers['api-key'] != API_KEY) {
        return Response(401);
      }
      return innerHandler(request);
    };
  };
}
