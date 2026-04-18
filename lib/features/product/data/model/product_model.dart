import 'package:hive/hive.dart';





@HiveType(typeId: 0)
class ProductResponse {
  @HiveField(0)
  String? next;
  @HiveField(1)
  String? previous;
  @HiveField(2)
  int? count;
  @HiveField(3)
  List<Results>? results;

  ProductResponse({this.next, this.previous, this.count, this.results});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
    count = json['count'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        try {
          results!.add(Results.fromJson(v));
        } catch (e) {
          print('❌ Error parsing individual product: $e');
        }
      });
    }
  }
}

@HiveType(typeId: 1)
class Results extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? sku;
  @HiveField(2)
  dynamic name;
  @HiveField(3)
  String? slug;
  @HiveField(4)
  double? price;
  @HiveField(5)
  dynamic shortDescription;
  @HiveField(6)
  double? salePrice;
  @HiveField(7)
  String? formattedPrice;
  @HiveField(8)
  String? currency;
  @HiveField(9)
  List<Categories>? categories;
  @HiveField(10)
  List<Images>? images;
  @HiveField(11)
  int? quantity;
  @HiveField(12)
  bool? isInfinite;
  @HiveField(13)
  Weight? weight;
  @HiveField(14)
  Rating? rating;
  @HiveField(15)
  List<Stocks>? stocks;
  @HiveField(16)
  String? createdAt;


  @HiveField(17)
  String? barcode;

  Results({
    this.id,
    this.sku,
    this.barcode, 
    this.name,
    this.slug,
    this.price,
    this.shortDescription,
    this.salePrice,
    this.formattedPrice,
    this.currency,
    this.categories,
    this.images,
    this.quantity,
    this.isInfinite,
    this.weight,
    this.rating,
    this.stocks,
    this.createdAt
  });

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];

    barcode = json['barcode']?.toString();

    name = json['name'];
    slug = json['slug'];
    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;
    shortDescription = json['short_description'];
    salePrice = json['sale_price'] != null ? double.tryParse(json['sale_price'].toString()) : null;
    formattedPrice = json['formatted_price'];
    currency = json['currency'];

    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    quantity = json['quantity'];
    isInfinite = json['is_infinite'];
    weight = (json['weight'] != null && json['weight'] is Map) ? Weight.fromJson(json['weight']) : null;
    rating = (json['rating'] != null && json['rating'] is Map) ? Rating.fromJson(json['rating']) : null;
    if (json['stocks'] != null) {
      stocks = <Stocks>[];
      json['stocks'].forEach((v) {
        stocks!.add(Stocks.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }
}

@HiveType(typeId: 2)
class Categories {
  @HiveField(0)
  String? id;
  @HiveField(1)
  dynamic name;
  @HiveField(2)
  String? slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    slug = json['slug'];
  }
}

@HiveType(typeId: 3)
class Images {
  @HiveField(0)
  String? id;
  @HiveField(1)
  ImageData? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'] != null ? ImageData.fromJson(json['image']) : null;
  }
}

@HiveType(typeId: 4)
class ImageData {
  @HiveField(0)
  String? thumbnail;
  @HiveField(1)
  String? medium;
  @HiveField(2)
  String? fullSize;

  ImageData({this.thumbnail, this.medium, this.fullSize});

  ImageData.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    medium = json['medium'];
    fullSize = json['full_size'];
  }
}

@HiveType(typeId: 5)
class Weight {
  @HiveField(0)
  double? value;
  @HiveField(1)
  String? unit;

  Weight({this.value, this.unit});

  Weight.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? double.tryParse(json['value'].toString()) : null;
    unit = json['unit'];
  }
}

@HiveType(typeId: 6)
class Rating {
  @HiveField(0)
  double? average;
  @HiveField(1)
  int? totalCount;

  Rating({this.average, this.totalCount});

  Rating.fromJson(Map<String, dynamic> json) {
    average = json['average'] != null ? double.tryParse(json['average'].toString()) : null;
    totalCount = json['total_count'];
  }
}

@HiveType(typeId: 7)
class Stocks {
  @HiveField(0)
  String? id;
  @HiveField(1)
  bool? isInfinite;
  @HiveField(2)
  int? availableQuantity;

  Stocks({this.id, this.isInfinite, this.availableQuantity});

  Stocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isInfinite = json['is_infinite'];
    availableQuantity = json['available_quantity'];
  }
}
class Filters {
  Filters();
  Filters.fromJson(Map<String, dynamic> json);
}
