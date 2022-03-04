// NOTE: The original struct of a collection (in API) is a bit different (has more fields)
class Collection {
  final String id;
  final String title;
  final String owner;
  final String? ownerString;
  final String model;

  Collection(this.id, this.title, this.owner, this.ownerString, this.model);

  Collection.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        title = json["title"],
        owner = json["owner"],
        ownerString = json["ownerString"] ?? "",
        model = json["model"];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'owner': owner,
        'ownerString': ownerString,
        'model': model,
      };
}
