import 'dart:convert';

class CategoryList {
  List<CategoryData> categoryData;

  CategoryList({
    this.categoryData = const [],
  });

  CategoryList.fromJson(Map<String, dynamic> json) {
    if (json["CategoryData"] != null) {
      categoryData = new List<CategoryData>();
      json['CategoryData'].forEach((v) {
        categoryData.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "CategoryData": categoryData,
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
    mainCategoryID = json["MainCategoryID"];
    categoryName = json["CategoryName"];

    if (json["CategoryTextAndID"] != null) {
      categoryTextAndID = new List<CategoryTextAndID>();
      json['CategoryTextAndID'].forEach((v) {
        categoryTextAndID.add(new CategoryTextAndID.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "MainCategoryID": mainCategoryID,
    "CategoryName": categoryName,
    "CategoryTextAndID": categoryTextAndID,
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
    categoryTextID = json["CategoryTextID"];
    categoryTextDetail = json["CategoryTextDetail"];

    if (json["SubCategoryData"] != null) {
      subCategoryData = new List<SubCategoryData>();
      json['SubCategoryData'].forEach((v) {
        subCategoryData.add(new SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    "CategoryTextID": categoryTextID,
    "CategoryTextDetail": categoryTextDetail,
    "SubCategoryData": subCategoryData,
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
    subCategoryTextID = json["SubCategoryTextID"];
    subCategoryTextDetail = json["SubCategoryTextDetail"];
  }

  Map<String, dynamic> toJson() => {
    "SubCategoryTextID": subCategoryTextID,
    "SubCategoryTextDetail": subCategoryTextDetail,
  };

}
