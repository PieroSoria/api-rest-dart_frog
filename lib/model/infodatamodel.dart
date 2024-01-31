// ignore_for_file: public_member_api_docs

class InfoData {

  InfoData({
    required this.nombre,
    required this.type,
    required this.url,
  });

  factory InfoData.fromMap(Map<String, dynamic> map) {
    return InfoData(
      nombre: map['nombre'] as String,
      type: map['type'] as String,
      url: map['url'] as String,
    );
  }
  String nombre;
  String type;
  String url;

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'type': type,
      'url': url,
    };
  }
}
