import 'package:koishi/models/collection_model_value.dart';

class CollectionModel {
  final String id;
  final String parent;
  final List<CollectionModelValue> value;

  CollectionModel(this.id, this.parent, this.value);

  CollectionModel.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        parent = json["parent"],
        value = json["value"];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'parent': parent,
        'value': value,
      };
}
