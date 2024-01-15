import 'dart:convert';

class MasterMessage {
  String? id;
  String? version;
  final String? request;
  final String? response;
  final String? content;
  final String? path;
  final String? token;

  MasterMessage({
    this.id,
    this.version,
    this.request,
    this.response,
    this.content,
    this.path,
    this.token,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (version != null) "version": version,
        if (request != null) 'request': request,
        if (response != null) 'response': response,
        if (content != null) 'content': content,
        if (path != null) 'path': path,
        if (token != null) 'token': token,
      };

  factory MasterMessage.fromJson(Map<String, dynamic> json) {
    return MasterMessage(
      id: json["id"],
      version: json["version"],
      request: json["request"],
      response: json["response"],
      content: json['content'],
      path: json["path"],
      token: json["token"],
    );
  }
}
