import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../prisma/generated_dart_client/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _authUserFind(context),
    _ => Future.value(
        Response.json(
          body: {'menssage': 'not found'},
        ),
      ),
  };
}

Future<Response> _authUserFind(RequestContext context) async {
  final repo = context.read<UserRepository>();
  final data = (await context.request.json()) as Map<String, dynamic>;
  final username = data['username'] as String?;
  final password = data['password'] as String?;
  if (username == null || password == null) {
    return Response.json(
      body: {
        'mensage': 'he username and password is not empyt',
      },
      statusCode: HttpStatus.badRequest,
    );
  }

  final user = await repo.authUser(username: username, password: password);
  if (user != null) {
    return Response.json(
      body: {
        'mensage': 'Se encontro el usuario',
        'user': user,
      },
      statusCode: HttpStatus.accepted,
    );
  } else {
    return Response.json(
      body: {
        'mensage': 'No se encontro el usuario',
      },
      statusCode: HttpStatus.notFound,
    );
  }
}
