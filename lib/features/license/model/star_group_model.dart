class StarGroupModel {
  int? id;
  String? businessName;
  String? businessPhone;
  String? businessAddress;
  String? starId;

  StarGroupModel({
    this.id,
    this.businessName,
    this.businessPhone,
    this.businessAddress,
    this.starId,
  });

  @override
  String toString() {
    return 'StarGroupModel(id: $id, busniessName: $businessName, busniessPhone: $businessPhone, busniessAddress: $businessAddress, starId: $starId)';
  }

  factory StarGroupModel.fromJson(Map<String, dynamic> json) {
    return StarGroupModel(
      id: json['id'] as int?,
      businessName: json['busniessName'] as String?,
      businessPhone: json['busniessPhone'] as String?,
      businessAddress: json['busniessAddress'] as String?,
      starId: json['starId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessName': businessName,
        'businessPhone': businessPhone,
        'businessAddress': businessAddress,
        'starId': starId,
      };
}
