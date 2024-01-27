// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:orm/orm.dart';

import 'client.dart';
import 'model.dart';
import 'prisma.dart';

class UserRepository {
  UserRepository(this._db);
  final PrismaClient _db;

  String _hashpassword(String pass) {
    final encodedpassword = utf8.encode(pass);
    return sha256.convert(encodedpassword).toString();
  }

  Future<User?> authUser({
    required String username,
    required String password,
  }) async {
    final user = await _db.user.findFirst(
      where: UserWhereInput(
        username: PrismaUnion.$1(
          StringFilter(equals: username),
        ),
        password: PrismaUnion.$1(
          StringFilter(equals: _hashpassword(password)),
        ),
      ),
    );
    return user;
  }

  Future<User?> createUser({
    required String name,
    required String lastname,
    required String username,
    required String password,
  }) async {
    final user = await _db.user.create(
      data: PrismaUnion.$1(
        UserCreateInput(
          name: name,
          lastname: lastname,
          username: username,
          password: _hashpassword(password),
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
    required RequestContext context,
  }) async {
    try {
      final existingUser =
          await _db.user.findUnique(where: UserWhereUniqueInput(id: id));

      if (existingUser == null) {
        return null;
      }
      final json = (await context.request.json()) as Map<String, dynamic>;
      final name = json['name'] as String?;
      final lastname = json['lastname'] as String?;
      final username = json['username'] as String?;
      final password = json['password'] as String?;

      if (name == null &&
          lastname == null &&
          username == null &&
          password == null) {
        return existingUser;
      }

      final passcrip = sha256.convert(utf8.encode(password!));
      final user = await _db.user.update(
        data: PrismaUnion.$2(
          UserUncheckedUpdateInput(
            name: PrismaUnion.$1(name!),
            lastname: PrismaUnion.$1(lastname!),
            username: PrismaUnion.$1(username!),
            password: PrismaUnion.$1(passcrip.toString()),
          ),
        ),
        where: UserWhereUniqueInput(id: id),
      );
      return user;
    } catch (e) {
      return null;
    }
  }
}
