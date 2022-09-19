import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage(BuildContext context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/local_restaurant.json'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<RestaurantElement> restaurant =
              parseRestaurant(snapshot.data);
          return ListView.builder(
            itemCount: restaurant.length,
            itemBuilder: (context, index) =>
                _buildRestaurantItem(context, restaurant[index]),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantElement restaurant) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: Hero(
        tag: restaurant.id,
        child: Image.network(
          restaurant.pictureId,
          width: 100,
        ),
      ),
      title: Text(restaurant.name),
      subtitle: Text(restaurant.city),
      trailing: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                Icons.star,
                size: 16,
              ),
            ),
            const TextSpan(text: " "),
            TextSpan(
              text: restaurant.rating.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant);
      },
    );
  }
}
