class UserData {
  final String id;
  final List<String> favourites;
  final List<String> recipes;

  UserData({required this.id, required this.favourites, required this.recipes});

  factory UserData.fromMap({required Map<String, dynamic> map, String? id}) {
    print("UserData.fromMap: $map");

    List<String> favouritesList = [];
    final favouritesMapList = map['favourites'];
    if (favouritesMapList != null && favouritesMapList.isNotEmpty) {
      favouritesList = (favouritesMapList as List).map((step) => (step as String)).toList();
    }

    List<String> recipesList = [];
    final recipesMapList = map['favourites'];
    if (recipesMapList != null && recipesMapList.isNotEmpty) {
      recipesList = (recipesMapList as List).map((step) => (step as String)).toList();
    }

    return UserData(
      id: id ?? map['id'],
      favourites: favouritesList,
      recipes: recipesList,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'favourites': favourites,
      'recipes': recipes,
    };

    if (includeId) {
      map['id'] = id;
    }
    return map;
  }
}