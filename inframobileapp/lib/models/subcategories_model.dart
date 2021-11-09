// ignore: camel_case_types
class subCategory {
  var subcategories;

  subCategory({
    this.subcategories,
  });

  Map<String, dynamic> toMap(subCategory subcat) {
    Map<String, dynamic> callMap = Map();
    callMap["subcategories"] = subcat.subcategories;
    return callMap;
  }

  subCategory.fromMap(Map callMap) {
    this.subcategories = callMap["subcategories"];
  }
}
