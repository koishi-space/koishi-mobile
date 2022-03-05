class CollectionModelValue {
  final String columnName;
  final String dataType;
  final String unit;

  CollectionModelValue(this.columnName, this.dataType, this.unit);

  CollectionModelValue.fromJson(Map<String, dynamic> json)
      : columnName = json["columnName"],
        dataType = json["dataType"],
        unit = json["unit"] ?? "";

  Map<String, dynamic> toJson() => {
        'columnName': columnName,
        'dataType': dataType,
        'unit': unit,
      };
}
