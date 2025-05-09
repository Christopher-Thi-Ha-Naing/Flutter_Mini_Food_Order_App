import 'package:flutter/material.dart';
import 'package:food_order_app/models/food_card_model.dart';
import 'package:food_order_app/screens/food_detail_screen.dart';
import 'package:food_order_app/screens/login_screen.dart';
import 'package:food_order_app/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var name = 'Guest';
  var uid = null;

  @override
  void initState() {
    super.initState();

    fetchCurrentUsername();
  }

  Future<List<FoodCard>> fetchFoodItems() async {
    try {
      final response = await Supabase.instance.client.from('foods').select();
      return response.map<FoodCard>((item) => FoodCard.fromMap(item)).toList();
    } catch (e) {
      print("Error fetching food items: $e");
      return [];
    }
  }

  Future<void> fetchCurrentUsername() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      print('No authenticated user.');
      return;
    }

    final response =
        await supabase.from('users').select('name').eq('uid', userId).single();

    final username = response['name'] as String?;
    setState(() {
      name = username ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(appLogo),
        elevation: 10,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: Text(
          'Hello, $name!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Supabase.instance.client.auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delicious Food",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Discover and enjoy great food",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Divider(),
            const SizedBox(height: 8),

            Expanded(
              child: FutureBuilder<List<FoodCard>>(
                future: fetchFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No food items found.'));
                  }

                  final foodItems = snapshot.data!;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Popular Foods",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Horizontal List
                        SizedBox(
                          height: 350, // Adjust based on your card height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: foodItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FoodDetailScreen(
                                            food: foodItems[index],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        220, // Adjust width for better spacing
                                    child: _buildFoodCard(foodItems[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Recommended Foods",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Vertical List
                        SizedBox(
                          height: 350, // Adjust based on your card height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: foodItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: SizedBox(
                                  width: 220, // Adjust width for better spacing
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return FoodDetailScreen(
                                              food: foodItems[index],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: _buildFoodCard(foodItems[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodCard food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network(food.imageUrl, fit: BoxFit.fill),
                ),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${food.rating}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              food.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              food.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '\$${food.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    food.flavor,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
