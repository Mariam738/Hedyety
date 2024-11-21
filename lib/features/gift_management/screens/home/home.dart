// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/template/template.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Template(
      title: "Home",
      child: Column(
        children: [
          /// Create Event/List Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Create Your Own Event/List"),
            ),
          ),
          const SizedBox(height: 16),

          /// Search Bar
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8, color: Colors.red.shade900),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.8, color: Colors.black),
                borderRadius: BorderRadius.circular(30.0),
              ),
              hintText: "Search for Friend",
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.red.shade900,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.red.shade900),
                onPressed: () {},
              ),
            ),
          ),

          /// List of Friends
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/giftsList',
                        arguments: 'args',
                      );
                    },
                    title: Text("Mariam Essam"),
                    subtitle: Text("Upcoming Events: 1\n +201213333"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Add Friend Manually Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Add Friend Manually"),
            ),
          ),

          const SizedBox(height: 16),

          /// Add Friend Manually Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text("Add Friend From My Contact List"),
            ),
          ),
        ],
      ),
    );
  }
}
