import 'package:lexus_admin/models/enums/transaction_type.dart';

class Transaction {
  final String id;
  final String profileImage;
  final String transactionName;
  final DateTime datetime;
  final double amount;
  final TransactionType transactionType;

  Transaction(
    this.id,
    this.transactionName,
    this.datetime,
    this.amount,
    this.transactionType,
    this.profileImage,
  );
}
