
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diet_plan_app/models/food.dart';
import 'package:diet_plan_app/models/recipe_detail.dart';


class ApiService {
  final String _apiKey = '92a5864b22854b86b49b649c2d615045'; 
  final String _baseUrl = 'https://api.spoonacular.com/recipes/findByNutrients';








  Future<List<Food>> fetchMeals(String mealType, double minCalories, double maxCalories) async {
  final response = await http.get(Uri.parse(
    '$_baseUrl?apiKey=$_apiKey&minCalories=$minCalories&maxCalories=$maxCalories&number=30',
  ));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
   // print('API Response: $data'); // Print the API response for debugging
   

    if (data != null && data is List) {
        List<Food> foodList = parseFoodList(data, mealType);

        // Debug: Print the image URLs
         /* for (var food in foodList) {
        //  print('Image URL: ${food.imageUrl}'); // Print each image URL
        } */

        return foodList;
      } else {
        throw Exception('Unexpected data structure');
      }
    } 
    
    else {
      throw Exception('Failed to load meals');
    }
  }




Future<RecipeDetail>? fetchRecipeDetail(int recipeId) async {
    final response = await http.get(
      Uri.parse('https://api.spoonacular.com/recipes/$recipeId/information?includeNutrition=false&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //print(data);
      return RecipeDetail.fromJson(data);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }








  // Parse the list of food items from JSON
  List<Food> parseFoodList(List<dynamic> jsonList, String mealType) {
    return jsonList.map((json) => Food.fromJson(json as Map<String, dynamic>, mealType)).toList();
  }
}
