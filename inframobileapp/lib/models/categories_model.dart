class Category {
  var categories;

  Category({
    this.categories,
  });

  Map<String, dynamic> toMap(Category cat) {
    Map<String, dynamic> callMap = Map();
    callMap["categories"] = cat.categories;
    return callMap;
  }

  Category.fromMap(Map callMap) {
    this.categories = callMap["categories"];
  }
}
