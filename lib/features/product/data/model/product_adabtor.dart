import 'package:hive/hive.dart';

import 'product_model.dart';


class ProductResponseAdapter extends TypeAdapter<ProductResponse> {
  @override
  final int typeId = 0;

  @override
  void write(BinaryWriter writer, ProductResponse obj) {
    writer.write(obj.next);
    writer.write(obj.previous);
    writer.write(obj.count);
    writer.writeList(obj.results ?? []);
  }

  @override
  ProductResponse read(BinaryReader reader) {
    return ProductResponse(
      next: reader.read(),
      previous: reader.read(),
      count: reader.read(),
      results: reader.readList().cast<Results>(),
    );
  }
}


class ResultsAdapter extends TypeAdapter<Results> {
  @override
  final int typeId = 1;

  @override
  void write(BinaryWriter writer, Results obj) {
    writer.write(obj.id);               
    writer.write(obj.sku);              
    writer.write(obj.name);             
    writer.write(obj.slug);             
    writer.write(obj.price);            
    writer.write(obj.shortDescription); 
    writer.write(obj.salePrice);        
    writer.write(obj.formattedPrice);   
    writer.write(obj.currency);         
    writer.writeList(obj.categories ?? []); 
    writer.writeList(obj.images ?? []);     
    writer.write(obj.quantity);         
    writer.write(obj.isInfinite);       
    writer.write(obj.weight);           
    writer.write(obj.rating);           
    writer.writeList(obj.stocks ?? []);     
    writer.write(obj.createdAt);        
  }

  @override
  Results read(BinaryReader reader) {
    return Results(
      id: reader.read(),
      sku: reader.read(),
      name: reader.read(),
      slug: reader.read(),
      price: reader.read(),
      shortDescription: reader.read(),
      salePrice: reader.read(),
      formattedPrice: reader.read(),
      currency: reader.read(),
      categories: reader.readList().cast<Categories>(),
      images: reader.readList().cast<Images>(),
      quantity: reader.read(),
      isInfinite: reader.read(),
      weight: reader.read(),
      rating: reader.read(),
      stocks: reader.readList().cast<Stocks>(),
      createdAt: reader.read(),
    );
  }
}


class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 2;

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.slug);
  }

  @override
  Categories read(BinaryReader reader) {
    return Categories(id: reader.read(), name: reader.read(), slug: reader.read());
  }
}


class ImagesAdapter extends TypeAdapter<Images> {
  @override
  final int typeId = 3;

  @override
  void write(BinaryWriter writer, Images obj) {
    writer.write(obj.id);
    writer.write(obj.image);
  }

  @override
  Images read(BinaryReader reader) {
    return Images(id: reader.read(), image: reader.read());
  }
}


class ImageDataAdapter extends TypeAdapter<ImageData> {
  @override
  final int typeId = 4;

  @override
  void write(BinaryWriter writer, ImageData obj) {
    writer.write(obj.thumbnail);
    writer.write(obj.medium);
    writer.write(obj.fullSize);
  }

  @override
  ImageData read(BinaryReader reader) {
    return ImageData(thumbnail: reader.read(), medium: reader.read(), fullSize: reader.read());
  }
}


class WeightAdapter extends TypeAdapter<Weight> {
  @override
  final int typeId = 5;

  @override
  void write(BinaryWriter writer, Weight obj) {
    writer.write(obj.value);
    writer.write(obj.unit);
  }

  @override
  Weight read(BinaryReader reader) {
    return Weight(value: reader.read(), unit: reader.read());
  }
}


class RatingAdapter extends TypeAdapter<Rating> {
  @override
  final int typeId = 6;

  @override
  void write(BinaryWriter writer, Rating obj) {
    writer.write(obj.average);
    writer.write(obj.totalCount);
  }

  @override
  Rating read(BinaryReader reader) {
    return Rating(average: reader.read(), totalCount: reader.read());
  }
}


class StocksAdapter extends TypeAdapter<Stocks> {
  @override
  final int typeId = 7;

  @override
  void write(BinaryWriter writer, Stocks obj) {
    writer.write(obj.id);
    writer.write(obj.isInfinite);
    writer.write(obj.availableQuantity);
  }

  @override
  Stocks read(BinaryReader reader) {
    return Stocks(id: reader.read(), isInfinite: reader.read(), availableQuantity: reader.read());
  }
}
