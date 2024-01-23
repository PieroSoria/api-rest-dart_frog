import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import '../../prisma/generated_dart_client/user_repository.dart';

Future<Response> onRequest(RequestContext context, String ids) {
  final id = int.parse(ids);
  return switch (context.request.method) {
    HttpMethod.get => _getSingleUser(id, context),
    HttpMethod.delete => _deleteUser(id, context),
    HttpMethod.put => _updateUser(id, context),
    _ => Future.value(Response(body: 'This is default'))
  };
}

Future<Response> _getSingleUser(int id, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final jsondata = (await repo.getSingleUser(id: id))?.toJson();
  if (jsondata != null) {
    return Response.json(
      body: {
        'menssaje': 'user is id = $id',
        'user': jsondata,
      },
    );
  } else {
    return Response.json(
      body: {
        'menssaje': 'No se encontro ningun usuario',
      },
      statusCode: HttpStatus.badRequest,
    );
  }
}

Future<Response> _deleteUser(int id, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final data = (await repo.deleteUserbyId(id: id))?.toJson();
  if (data != null) {
    return Response.json(
      body: {'message': 'user with id = $id is detele', 'user': data},
    );
  } else {
    return Response.json(
      body: {'message': 'no existe user with id $id'},
      statusCode: HttpStatus.badRequest,
    );
  }
}

Future<Response> _updateUser(int id, RequestContext context) async {
  final repo = context.read<UserRepository>();
  

  final data = await repo.updateUserById(id: id, context: context);

  if (data != null) {
    return Response.json(
      body: {
        'menssage': 'user with id = $id is update',
        'user': data,
      },
      statusCode: HttpStatus.accepted,
    );
  } else {
    return Response.json(
      body: {
        'menssage': 'not existe user with id $id',
      },
      statusCode: HttpStatus.badRequest,
    );
  }
}
