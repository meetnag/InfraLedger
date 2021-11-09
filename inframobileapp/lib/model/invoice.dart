import './customer.dart';
import './supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;
  final List<FlatInvoiceItem> flatitems;

  const Invoice(
      {this.info, this.supplier, this.customer, this.items, this.flatitems});
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    this.description,
    this.number,
    this.date,
    this.dueDate,
  });
}

class InvoiceItem {
  final String category;
  final String subcategory;
  final DateTime date;
  final String type;
  final double amount;
  final String paidby;

  const InvoiceItem({
    this.category,
    this.subcategory,
    this.date,
    this.type,
    this.amount,
    this.paidby,
  });
}

class FlatInvoiceItem {
  final DateTime date;
  final String type;
  final String flat;
  final double amount;

  const FlatInvoiceItem({
    this.date,
    this.type,
    this.flat,
    this.amount,
  });
}
