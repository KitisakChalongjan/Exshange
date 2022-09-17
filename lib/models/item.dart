class Item {
  String id;
  String ownerid;
  String name;
  String detail;
  String address;
  String province;
  String category;
  String subCategory;
  List<dynamic> imagesUrl;
  String itemType;
  double latitude;
  double longitude;

  Item(
    this.id,
    this.ownerid,
    this.name,
    this.detail,
    this.address,
    this.province,
    this.category,
    this.subCategory,
    this.imagesUrl,
    this.itemType,
    this.latitude,
    this.longitude,
  );

  factory Item.fromMap(String id, Map data) {
    return Item(
      id,
      data['ownerId'],
      data['name'],
      data['detail'],
      data['address'],
      data['province'],
      data['category'],
      data['subCategory'],
      data['imagesUrl'],
      data['itemType'],
      data['latitude'],
      data['longitude'],
    );
  }
}
