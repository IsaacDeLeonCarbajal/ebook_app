import 'package:ebook_app/app/models/model.dart';
import 'package:ebook_app/app/support/helper.dart';
import 'package:slugify/slugify.dart';

class Category extends Model {
  static const String modelName = 'categories';

  static Future<Category> find(String? id) {
    return Model.findRecord<Category>(id, Category.modelName, Category.fromEntries);
  }

  static Future<Map<String, Category>> all() {
    return Model.allRecords<Category>(Category.modelName, Category.fromEntries);
  }

  @override
  final List<String> requiredAttrs = [
    'name',
    'slug',
  ];

  Category() : super(Category.modelName);

  Category.fromEntries(Map entries) : super(Category.modelName, id: entries['id']?.toString()) {
    updateData(entries);
  }

  Category.fromData({
    String? id,
    required String name,
    required String slug,
  }) : super(Category.modelName, id: id) {
    updateData({
      'name': name,
      'slug': slug,
    });
  }

  @override
  void updateData(Map entries) {
    name = Helper.getMapValue<String>(entries, 'name', defaultValue: name); // Update or keep the old value
    slug = Helper.getMapValue<String>(entries, 'slug', defaultValue: slugify(name)); // Update or slug the name
  }

  String get name => getValue<String>('name');
  String get slug => getValue<String>('slug');

  set name(String name) {
    attributes['name'] = name;
  }

  set slug(String slug) {
    attributes['slug'] = slug;
  }
}
