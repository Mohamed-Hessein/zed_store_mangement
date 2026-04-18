import 'package:hive/hive.dart';

import 'order_model.dart';
import 'customer_model.dart';
import 'order_item_model.dart';
import 'shipping_address_model.dart';


class OrderModeldAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 10;

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer.write(obj.id);               
    writer.write(obj.transactionId);    
    writer.write(obj.customer);         
    writer.writeList(obj.items);        
    writer.write(obj.shippingAddress);  
    writer.write(obj.status);           
    writer.write(obj.subtotal);         
    writer.write(obj.shippingCost);     
    writer.write(obj.vatAmount);        
    writer.write(obj.grandTotal);       
    writer.write(obj.paymentMethod);    
    writer.write(obj.createdAt);        
    writer.write(obj.updatedAt);        
  }

  @override
  OrderModel read(BinaryReader reader) {
    return OrderModel(
      id: reader.read(),
      transactionId: reader.read(),
      customer: reader.read() as CustomerModel,
      items: (reader.readList()).cast<OrderItemModel>(),
      shippingAddress: reader.read() as ShippingAddressModel,
      status: reader.read(),
      subtotal: reader.read(),
      shippingCost: reader.read(),
      vatAmount: reader.read(),
      grandTotal: reader.read(),
      paymentMethod: reader.read(),
      createdAt: reader.read(),
      updatedAt: reader.read(),
    );
  }
}


class CustomerModelAdapter extends TypeAdapter<CustomerModel> {
  @override
  final int typeId = 11;

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.phone);
    writer.write(obj.avatarUrl);
  }

  @override
  CustomerModel read(BinaryReader reader) {
    return CustomerModel(
      id: reader.read(),
      name: reader.read(),
      email: reader.read(),
      phone: reader.read(),
      avatarUrl: reader.read(),
    );
  }
}


class OrderItemModelAdapter extends TypeAdapter<OrderItemModel> {
  @override
  final int typeId = 12;

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer.write(obj.id);
    writer.write(obj.productName);
    writer.write(obj.price);
    writer.write(obj.quantity);
    writer.write(obj.imageUrl);
  }

  @override
  OrderItemModel read(BinaryReader reader) {
    return OrderItemModel(
      id: reader.read(),
      productName: reader.read(),
      price: reader.read(),
      quantity: reader.read(),
      imageUrl: reader.read(),
    );
  }
}


class ShippingAddressModelAdapter extends TypeAdapter<ShippingAddressModel> {
  @override
  final int typeId = 13;

  @override
  void write(BinaryWriter writer, ShippingAddressModel obj) {
    writer.write(obj.street);
    writer.write(obj.city);
    writer.write(obj.state);
    writer.write(obj.postalCode);
    writer.write(obj.country);
  }

  @override
  ShippingAddressModel read(BinaryReader reader) {
    return ShippingAddressModel(
      street: reader.read(),
      city: reader.read(),
      state: reader.read(),
      postalCode: reader.read(),
      country: reader.read(),
    );
  }
}
