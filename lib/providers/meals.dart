import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';
import '../models/url.dart';

class Meals with ChangeNotifier {
  var fav = false;
  var quantity = 1;

  List<Meal> _cmeals = [];
  List<Meal> _favmeals = [];
  List<Meal> _meals = [];
  List<Meal> _searchmeals = [];

  List<Meal> get meals {
    return [..._meals];
  }

  List<Meal> get cmeals {
    return [..._cmeals];
  }

  List<Meal> get favMeals {
    return [..._favmeals];
  }

  List<Meal> get searchedMeals {
    return [..._searchmeals];
  }

  Future<void> getCategoriezedmeals(String category) async {
    var prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Url.getMeals, body: {
        'category': category,
      });
      prefs.setString('bella_category_meals', response.body);
      _cmeals = [];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> loadCategorizedMeals(String category) async {
    await getCategoriezedmeals(category);

    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('bella_category_meals');
    final categoryData = json.decode(response) as Map<String, dynamic>;
    final List<Meal> loadedMeal = [];
    categoryData.forEach((key, value) {
      List<dynamic> ele = value as List<dynamic>;
      ele.forEach((element) {
        loadedMeal.add(Meal(
          id: element['id'],
          title: element['title'],
          description: element['description'],
          picture1: '${Url.pictureOne}${element['picture_1']}',
          picture2: '${Url.pictureTwo}${element['picture_2']}',
          picture3: '${Url.pictureThree}${element['picture_3']}',
          picture4: '${Url.pictureFour}${element['picture_4']}',
          price: double.parse(element['price']),
          slashedprice: element['slashed_price'],
          category: element['category'],
        ));
      });
    });
    _cmeals = loadedMeal;
    notifyListeners();
  }

  Future<void> getAllMealsToMemory() async {
    _meals = [];

    var preference = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Url.getAllMeals);
      preference.setString('bella_meals', response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> loadAllMealsFromMemory() async {
    var pref = await SharedPreferences.getInstance();
    await getAllMealsToMemory();
    try {
      var response = pref.getString('bella_meals');
      final categoryData = json.decode(response) as Map<String, dynamic>;
      final List<Meal> loadedMeal = [];
      categoryData.forEach((key, value) {
        List<dynamic> ele = value as List<dynamic>;
        ele.forEach((element) {
          loadedMeal.add(Meal(
            id: element['id'],
            title: element['title'],
            description: element['description'],
            picture1: '${Url.pictureOne}${element['picture_1']}',
            picture2: '${Url.pictureTwo}${element['picture_2']}',
            picture3: '${Url.pictureThree}${element['picture_3']}',
            picture4: '${Url.pictureFour}${element['picture_4']}',
            price: double.parse(element['price']),
            slashedprice: element['slashed_price'],
            category: element['category'],
          ));
        });
      });
      _meals = loadedMeal;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  clearMeals() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('bella_category_meals');
    _cmeals.clear();
    // prefs.remove('bella_meals');
    // _meals.clear();
  }

  clearCMeals() async {
    _cmeals.clear();
  }

  resetFav() {
    fav = false;
  }

  int get getQuantity {
    return quantity;
  }

  Future<void> setQuantity(int mealid) async {
    try {
      final response = await http.post(Url.quantity, body: {
        'mealid': '$mealid',
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      quantity = data['quantity'] as int;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  bool get favStatus {
    return fav;
  }

  Future<void> addFav(int mealid, String userId) async {
    try {
      final response = await http.post('${Url.fav}', body: {
        'mealid': mealid.toString(),
        'id': userId,
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      fav = data['status'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> showFav(int mealid, String userId) async {
    try {
      final response = await http.post('${Url.showFav}', body: {
        'mealid': mealid.toString(),
        'id': userId.toString(),
      });
      final data = json.decode(response.body) as Map<String, dynamic>;
      fav = data['status'];
      if (!fav) {
        _favmeals.removeWhere((element) => element.id == mealid);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllFav(int userid) async {
    try {
      final response = await http.post(Url.allFav, body: {
        'id': userid.toString(),
      });
      final categoryData = json.decode(response.body) as Map<String, dynamic>;
      final List<Meal> loadedMeals = [];
      categoryData.forEach((key, element) {
        final List<dynamic> ele = element as List<dynamic>;
        ele.forEach((element) {
          loadedMeals.add(Meal(
            id: element['id'],
            title: element['title'],
            description: element['description'],
            picture1: '${Url.pictureOne}${element['picture_1']}',
            picture2: element['picture_2'],
            picture3: element['picture_3'],
            picture4: element['picture_4'],
            price: double.parse(element['price']),
            slashedprice: element['slashed_price'],
            category: element['category'],
          ));
        });
      });
      _favmeals = loadedMeals;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  searchMeal(dynamic search) async {
    _searchmeals = [];
    try {
      final response = await http.post(Url.search, body: {
        'search': search.toString(),
      });
      final categoryData = json.decode(response.body) as Map<String, dynamic>;
      final List<Meal> meals = [];
      categoryData.forEach((key, element) {
        final List<dynamic> ele = element as List<dynamic>;
        ele.forEach((element) {
          meals.add(Meal(
            id: element['id'],
            title: element['title'],
            description: element['description'],
            picture1: '${Url.pictureOne}${element['picture_1']}',
            picture2: '${Url.pictureTwo}${element['picture_2']}',
            picture3: '${Url.pictureThree}${element['picture_3']}',
            picture4: '${Url.pictureFour}${element['picture_4']}',
            price: double.parse(element['price']),
            slashedprice: element['slashed_price'],
            category: element['category'],
          ));
        });
      });
      _searchmeals = [];
      _searchmeals = meals;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
