


import 'package:hive_flutter/adapters.dart';

import 'order_model.dart';

class ZidOrdersResponseAdapter extends TypeAdapter<ZidOrdersResponse> {
  @override
  final int typeId = 50; 

  @override
  ZidOrdersResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZidOrdersResponse(
      status: fields[0] as String?,
      orders: (fields[1] as List?)?.cast<OrderModel>(),
      totalCount: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ZidOrdersResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.orders)
      ..writeByte(2)
      ..write(obj.totalCount);
  }
}

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 51; 

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as int,
      code: fields[1] as String,
      storeName: fields[2] as String,
      orderTotal: fields[3] as String,
      issueDate: fields[4] as String,
      orderStatus: fields[5] as OrderStatus?,
      customer: fields[6] as Customer?,
      address: fields[7] as Address?,
      paymentMethod: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.storeName)
      ..writeByte(3)
      ..write(obj.orderTotal)
      ..writeByte(4)
      ..write(obj.issueDate)
      ..writeByte(5)
      ..write(obj.orderStatus)
      ..writeByte(6)
      ..write(obj.customer)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.paymentMethod);
  }
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 52; 

  @override
  OrderStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderStatus(
      name: fields[0] as String,
      code: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code);
  }
}

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final int typeId = 53; 

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      id: fields[0] as int,
      name: fields[1] as String,
      mobile: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mobile);
  }
}

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 54; 

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      street: fields[0] as String,
      district: fields[1] as String,
      city: fields[2] as String,
      country: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.district)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.country);
  }
}
