
class CategoryList {
  List<CategoryData> categoryData;

  CategoryList({
    this.categoryData = const [],
  });

  CategoryList.fromJson(Map<String, dynamic> json) {
    if (json["categoryData"] != null) {
      categoryData = new List<CategoryData>();
      json['categoryData'].forEach((v) {
        categoryData.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "categoryData": categoryData,
  };
}

class CategoryData {
  int mainCategoryID;
  String categoryName;
  List<CategoryTextAndID> categoryTextAndID;

  CategoryData({
    this.mainCategoryID,
    this.categoryName,
    this.categoryTextAndID,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    mainCategoryID = json["mainCategoryID"];
    categoryName = json["categoryName"];

    if (json["categoryTextAndID"] != null) {
      categoryTextAndID = new List<CategoryTextAndID>();
      json['categoryTextAndID'].forEach((v) {
        categoryTextAndID.add(new CategoryTextAndID.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "mainCategoryID": mainCategoryID,
    "categoryName": categoryName,
    "categoryTextAndID": categoryTextAndID,
  };

}

class CategoryTextAndID {
  int categoryTextID;
  String categoryTextDetail;
  List<SubCategoryData> subCategoryData;
  CategoryTextAndID({
    this.categoryTextID,
    this.categoryTextDetail,
    this.subCategoryData,
  });

  CategoryTextAndID.fromJson(Map<String, dynamic> json) {
    categoryTextID = json["categoryTextID"];
    categoryTextDetail = json["categoryTextDetail"];

    if (json["subCategoryData"] != null) {
      subCategoryData = new List<SubCategoryData>();
      json['subCategoryData'].forEach((v) {
        subCategoryData.add(new SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "categoryTextID": categoryTextID,
    "categoryTextDetail": categoryTextDetail,
    "subCategoryData": subCategoryData,
  };

}

class SubCategoryData {
  int subCategoryTextID;
  String subCategoryTextDetail;
  SubCategoryData({
    this.subCategoryTextID,
    this.subCategoryTextDetail,
  });

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    subCategoryTextID = json["subCategoryTextID"];
    subCategoryTextDetail = json["subCategoryTextDetail"];
  }

  Map<String, dynamic> toJson() => {
    "subCategoryTextID": subCategoryTextID,
    "subCategoryTextDetail": subCategoryTextDetail,
  };

}
