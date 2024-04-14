import 'package:ebook_app/app/models/model.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:slugify/slugify.dart';

class Book extends Model {
  static const String modelName = 'books';

  static Future<Book> find(String? id) {
    return Model.findRecord<Book>(id, Book.modelName, Book.fromEntries);
  }

  static Future<Map<String, Book>> all() {
    return Model.allRecords<Book>(Book.modelName, Book.fromEntries);
  }

  @override
  final List<String> requiredAttrs = [
    'title',
    'description',
  ];

  Book() : super(Book.modelName);

  Book.fromEntries(Map entries) : super(Book.modelName, id: entries['id']?.toString()) {
    updateData(entries);
  }

  Book.fromData({
    String? id,
    required String title,
    required String subtitle,
    required String slug,
    required String description,
    required int price,
    required int stock,
    required int year,
    required int pages,
  }) : super(Book.modelName, id: id) {
    updateData({
      'title': title,
      'subtitle': subtitle,
      'slug': slug,
      'description': description,
      'price': price,
      'stock': stock,
      'year': year,
      'pages': pages,
    });
  }

  @override
  void updateData(Map entries) {
    title = Helper.getMapValue<String>(entries, 'title', defaultValue: title); // Update or keep the old value
    subtitle = Helper.getMapValue<String>(entries, 'subtitle', defaultValue: subtitle); // Update or keep the old value
    slug = Helper.getMapValue<String>(entries, 'slug', defaultValue: slugify(title)); // Update or slug the title
    description = Helper.getMapValue<String>(entries, 'description', defaultValue: description); // Update or keep the old value
    price = Helper.getMapValue<int>(entries, 'price', defaultValue: price); // Update or keep the old value
    stock = Helper.getMapValue<int>(entries, 'stock', defaultValue: stock); // Update or keep the old value
    year = Helper.getMapValue<int>(entries, 'year', defaultValue: year); // Update or keep the old value
    pages = Helper.getMapValue<int>(entries, 'pages', defaultValue: pages); // Update or keep the old value
  }

  String get title => getValue<String>('title');
  String get subtitle => getValue<String>('subtitle');
  String get slug => getValue<String>('slug');
  String get description => getValue<String>('description');
  int get price => getValue<int>('price');
  int get stock => getValue<int>('stock');
  int get year => getValue<int>('year');
  int get pages => getValue<int>('pages');

  set title(String title) {
    attributes['title'] = title;
  }

  set subtitle(String subtitle) {
    attributes['subtitle'] = subtitle;
  }

  set slug(String slug) {
    attributes['slug'] = slug;
  }

  set description(String description) {
    attributes['description'] = description;
  }

  set price(int price) {
    attributes['price'] = price;
  }

  set stock(int stock) {
    attributes['stock'] = stock;
  }

  set year(int year) {
    attributes['year'] = year;
  }

  set pages(int pages) {
    attributes['pages'] = pages;
  }
}
