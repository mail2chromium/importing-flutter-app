
import 'dart:convert';

AgentModel responseFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return AgentModel.fromJson(jsonData);
}

class AgentModel{
   String? id;
   String? name;
   String? contact;
   String? whatsapp;

  AgentModel({this.id, this.name, this.contact, this.whatsapp});

  AgentModel.fromJson(Map<String, dynamic> parsedJson) {
    name = parsedJson['name'];
    contact = parsedJson['contact'];
    whatsapp = parsedJson['whatsapp'];
  }

  toJson() {
    return { "name": name, "contact": contact, "whatsapp": whatsapp };
  }
}