abstract class OrdersEvent {}

class FetchOrdersEvent extends OrdersEvent {

  final bool isLoadMore;
  dynamic searchQuery;
  FetchOrdersEvent({this.isLoadMore = false,this.searchQuery,});
}

class SearchOrdersEvent extends OrdersEvent {
  final String query;
  SearchOrdersEvent(this.query);
}

class UpdateOrdersLocalStatus extends OrdersEvent {
  final List<String> ids;
  final dynamic newStatus;

  UpdateOrdersLocalStatus(this.ids, this.newStatus);


  List<Object?> get props => [ids, newStatus];
}
