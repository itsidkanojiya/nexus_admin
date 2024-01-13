// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Book {
  final int id;
  final String name;
  final int std;
  final int bid;
  final String pdf_link;
  final String cover_link;

  Book({
    required this.id,
    required this.name,
    required this.std,
    required this.bid,
    required this.pdf_link,
    required this.cover_link,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      name: map['name'] as String,
      std: map['std'] as int,
      bid: map['bid'] as int,
      pdf_link: map['pdf_link'] as String,
      cover_link: map['cover_link'] as String,
    );
  }

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'std': std,
      'bid': bid,
      'pdf_link': pdf_link,
      'cover_link': cover_link,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Book(id: $id, name: $name, std: $std, bid: $bid, pdf_link: $pdf_link, cover_link: $cover_link)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.std == std &&
        other.bid == bid &&
        other.pdf_link == pdf_link &&
        other.cover_link == cover_link;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        std.hashCode ^
        bid.hashCode ^
        pdf_link.hashCode ^
        cover_link.hashCode;
  }

  Book copyWith({
    int? id,
    String? name,
    int? std,
    int? bid,
    String? pdf_link,
    String? cover_link,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      std: std ?? this.std,
      bid: bid ?? this.bid,
      pdf_link: pdf_link ?? this.pdf_link,
      cover_link: cover_link ?? this.cover_link,
    );
  }
}

class BookModel {
  final List<Book> books;

  BookModel({
    required this.books,
  });

  factory BookModel.fromJson(Map<String, dynamic> map) {
    return BookModel(
      books: List<Book>.from(
        map['books'].map<Book>(
          (x) => Book.fromMap(x),
        ),
      ),
    );
  }

  BookModel copyWith({
    List<Book>? books,
  }) {
    return BookModel(
      books: books ?? this.books,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'books': books.map((x) => x.toMap()).toList(),
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      books: List<Book>.from(
        (map['books'] as List<int>).map<Book>(
          (x) => Book.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'BookModel(books: $books)';

  @override
  bool operator ==(covariant BookModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.books, books);
  }

  @override
  int get hashCode => books.hashCode;
}
