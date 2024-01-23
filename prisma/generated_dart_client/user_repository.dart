// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:orm/orm.dart';

import 'client.dart';
import 'model.dart';
import 'prisma.dart';

class UserRepository {
  UserRepository(this._db);
  final PrismaClient _db;

  Future<User?> createUser({
    required String name,
    required String lastname,
    required String username,
    required String password,
  }) async {
    final passcrip = sha256.convert(utf8.encode(password));
    final user = await _db.user.create(
      data: PrismaUnion.$1(
        UserCreateInput(
          name: name,
          lastname: lastname,
          username: username,
          password: passcrip.toString(),
        ),
      ),
    );
    return user;
  }

  Future<List<User?>> getAllUser() async {
    final list = await _db.user.findMany();
    return list.toList();
  }

  Future<User?> getSingleUser({required int id}) async {
    final user = await _db.user.findUnique(where: UserWhereUniqueInput(id: id));
    return user;
  }

  Future<User?> deleteUserbyId({required int id}) async {
    final existingUser =
        await _db.user.findUnique(where: UserWhereUniqueInput(id: id));
    if (existingUser == null) {
      return null;
    }
    final deletedUser =
        await _db.user.delete(where: UserWhereUniqueInput(id: id));
    return deletedUser;
  }

  Future<User?> updateUserById({
    required int id,
    required Map<dynamic, dynamic> us,
  }) async {
    final existingUser =
        await _db.user.findUnique(where: UserWhereUniqueInput(id: id));
    if (existingUser == null) {
      return null;
    }
    final passcrip = sha256.convert(utf8.encode(us['password'] as String));
    final user = await _db.user.update(
      data: PrismaUnion.$2(
        UserUncheckedUpdateInput(
          name: PrismaUnion.$1(
            us['name'] as String,
          ),
          lastname: PrismaUnion.$1(
            us['lastname'] as String,
          ),
          username: PrismaUnion.$1(
            us['username'] as String,
          ),
          password: PrismaUnion.$1(
            passcrip.toString(),
          ),
        ),
      ),
      where: UserWhereUniqueInput(id: id),
    );
    return user;
  }
}
