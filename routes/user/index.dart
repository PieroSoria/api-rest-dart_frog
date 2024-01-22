import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../../prisma/generated_dart_client/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getUsers(context),
    HttpMethod.post => _createUser(context),
    _ => Future.value(Response(body: 'This is default'))
  };
}

Future<Response> _getUsers(RequestContext context) async {
  final repo = context.read<UserRepository>();
  final users = await repo.getAllUser();
  if (users.isEmpty) {
    return Response.json(body: {'mensaje': 'no se encontró nada'});
  } else {
    return Future.value(
      Response.json(
        body: users,
      ),
    );
  }
}

Future<Response> _createUser(RequestContext context) async {
  final json = (await context.request.json()) as Map<String, dynamic>;
  final name = json['name'] as String?;
  final lastname = json['lastname'] as String?;
  final username = json['username'] as String?;
  final password = json['password'] as String?;
  if (name == null ||
      lastname == null ||
      username == null ||
      password == null) {
    return Response.json(
      body: {'message': 'and name and lastname'},
      statusCode: HttpStatus.badRequest,
    );
  } else {
    final repo = context.read<UserRepository>();
    final user = await repo.createUser(
      name: name,
      lastname: lastname,
      username: username,
      password: password,
    );

    return Response.json(
      body: {'mensage': 'Save!', 'user': user},
    );
  }
}
