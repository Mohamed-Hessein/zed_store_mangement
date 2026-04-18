import 'package:hive/hive.dart';
import 'analysis_entity.dart'; 


class AnalysisEntityAdapter extends TypeAdapter<AnalysisEntity> {
  @override
  final int typeId = 100;

  @override
  AnalysisEntity read(BinaryReader reader) {
    return AnalysisEntity(
      totalValue: reader.readDouble(),        
      totalStockCount: reader.readInt(),     
      outOfStockCount: reader.readInt(),     
      stockLevels: (reader.readList()).cast<StockLevelItem>(), 
      stockDistribution: reader.read() as StockDistribution,   
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisEntity obj) {
    writer.writeDouble(obj.totalValue);
    writer.writeInt(obj.totalStockCount);
    writer.writeInt(obj.outOfStockCount);
    writer.writeList(obj.stockLevels);
    writer.write(obj.stockDistribution);
  }
}


class StockLevelItemAdapter extends TypeAdapter<StockLevelItem> {
  @override
  final int typeId = 101;

  @override
  StockLevelItem read(BinaryReader reader) {
    return StockLevelItem(
      productName: reader.readString(), 
      quantity: reader.readInt(),      
      price: reader.readDouble(),      
      sku: reader.readString(),        
    );
  }

  @override
  void write(BinaryWriter writer, StockLevelItem obj) {
    writer.writeString(obj.productName);
    writer.writeInt(obj.quantity);
    writer.writeDouble(obj.price);
    writer.writeString(obj.sku);
  }
}


class StockDistributionAdapter extends TypeAdapter<StockDistribution> {
  @override
  final int typeId = 103;

  @override
  StockDistribution read(BinaryReader reader) {
    return StockDistribution(
      healthyCount: reader.readInt(),    
      lowStockCount: reader.readInt(),   
      outOfStockCount: reader.readInt(), 
    );
  }

  @override
  void write(BinaryWriter writer, StockDistribution obj) {
    writer.writeInt(obj.healthyCount);
    writer.writeInt(obj.lowStockCount);
    writer.writeInt(obj.outOfStockCount);
  }
}
