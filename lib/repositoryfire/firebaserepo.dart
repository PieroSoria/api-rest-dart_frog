// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_dart/firebase_dart.dart';

import 'package:mybackend_lastversion/model/infodatamodel.dart';

class FirebaseRepoMy {
  Future<List<InfoData?>> enviardata(RequestContext context) async {
    try {
      FirebaseDart.setup();
      const options = FirebaseOptions(
        appId: '1:435536882689:web:0741a8292af0275f066400',
        apiKey: 'AIzaSyDSepdmn8oo9yBETcAJamrt0b4TknmaoEU',
        projectId: 'mybackendlast',
        messagingSenderId: '435536882689',
        authDomain: 'mybackendlast.firebaseapp.com',
        storageBucket: 'gs://mybackendlast.appspot.com',
      );
      final app = await Firebase.initializeApp(options: options);
      final ini = FirebaseStorage.instanceFor(
        app: app,
        bucket: 'gs://mybackendlast.appspot.com',
      );

      final requestdata = await context.request.formData();
      final files = requestdata.files;
      final resullist = <InfoData>[];

      for (final file in files.values) {
        final nombre = file.name;
        final type = file.contentType;
        final fileContent = await file.readAsBytes();
        final filesend = Uint8List.fromList(fileContent);

        final data = await ini.ref('files').child(nombre).putData(filesend);
        final url = await data.ref.getDownloadURL();
        final datafinal = InfoData(
          nombre: nombre,
          type: type.toString(),
          url: url,
        );
        resullist.add(datafinal);
      }

      return resullist;
    } catch (e) {
      print('Error al enviar datos: $e');
      return [];
    }
  }
}
