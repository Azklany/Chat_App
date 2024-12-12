class MessagesModel {
  final String message;
  final String id;

  MessagesModel( {required this.id,required this.message});
  factory MessagesModel.fromJson(json) {
    return MessagesModel(message: json['message'], id: json['id']);
  }
}
