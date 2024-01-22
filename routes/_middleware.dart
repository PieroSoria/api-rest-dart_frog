import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../prisma/generated_dart_client/client.dart';
import '../prisma/generated_dart_client/user_repository.dart';

final _client =
    PrismaClient(datasourceUrl: Platform.environment['DATABASE_URL']);
// FutureOr<T> providePrisma<T>(
//   FutureOr<T> Function(PrismaClient prisma) main,
// ) async {
//   try {
//     return await main(_client);
//   } finally {
//     await _client.$disconnect();
//   }
// }

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(providerUserRepo());
}

Middleware providerUserRepo() {
  return provider((context) => UserRepository(_client));
}
