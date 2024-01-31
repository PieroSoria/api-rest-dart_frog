import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mybackend_lastversion/repositoryfire/firebaserepo.dart';

bool isFirebaseInitialized = false;

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => enviararchivo(context),
    _ => Future.value(
        Response.json(
          body: {'mensaje': 'hola a todos'},
          statusCode: HttpStatus.accepted,
        ),
      ),
  };
}

// Future<Response> enviararchivo(RequestContext context) async {
//   try {
//     FirebaseDart.setup();
//     const options = FirebaseOptions(
//       appId: '1:435536882689:web:0741a8292af0275f066400',
//       apiKey: 'AIzaSyDSepdmn8oo9yBETcAJamrt0b4TknmaoEU',
//       projectId: 'mybackendlast',
//       messagingSenderId: '435536882689',
//       authDomain: 'mybackendlast.firebaseapp.com',
//       storageBucket: 'gs://mybackendlast.appspot.com',
//     );
//     final app = await Firebase.initializeApp(options: options);
//     final ini = FirebaseStorage.instanceFor(
//       app: app,
//       bucket: 'gs://mybackendlast.appspot.com',
//     );

//     final requestdata = await context.request.formData();
//     final files = requestdata.files;

//     if (files.isNotEmpty) {
//       final file = files.values.first;
//       final fileName = file.name;
//       final fileContent = await file.readAsBytes();

//       final fileUint8List = Uint8List.fromList(fileContent);
//       final res = await ini.ref('files').child(fileName).putData(fileUint8List);

//       return Response.json(
//         body: {
//           'mensaje': {
//             'nombre': fileName,
//             'dato': file.contentType.toString(),
//             'ruta': await res.ref.getDownloadURL(),
//           },
//         },
//       );
//     } else {
//       return Response.json(
//         body: {
//           'error': 'No se encontraron archivos en la solicitud.',
//         },
//       );
//     }
//   } catch (e) {
//     return Response.json(body: {'error': e.toString()});
//   }
// }

Future<Response> enviararchivo(RequestContext context) async {
  try {
    final repo = FirebaseRepoMy();
    final data = await repo.enviardata(context);

    if (data.isNotEmpty) {
      final jsonData = data.map((infoData) => infoData!.toJson()).toList();

      return Response.json(
        body: {
          'mensaje': 'save!',
          'data': jsonData,
        },
        statusCode: HttpStatus.accepted,
      );
    } else {
      return Response.json(
        body: {'mensaje': 'No se han agregado archivos.'},
        statusCode: HttpStatus.accepted,
      );
    }
  } catch (e) {
    return Response.json(
      body: {'mensaje': 'Opps!', 'Error': '$e'},
      statusCode: HttpStatus.badGateway,
    );
  }
}
