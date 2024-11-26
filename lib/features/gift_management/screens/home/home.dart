// ignore_for_file: prefer_const_constructors

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Database/local_database.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/features/gift_management/screens/home/landscape_home.dart';

import '../../models/users.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  // bool isLandscape = true;
  LocalDatabse mydb = LocalDatabse();

  @override
  void initState()  {
    super.initState();
    try {
       print('trying to initialize');
       mydb.initialize();
       print('trying to initialize');
    } catch(e) {
       print('Db initlizaiton error');
    }
  }


  @override
  Widget build(BuildContext context) {

    // if(isLandscape) return LandscapeHome();

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

            child: FutureBuilder(
              future: mydb.readData("SELECT * FROM 'USERS'"),
              builder: (BuildContext, snapshot){
                if(snapshot.hasData && snapshot.data !=null) {
                  List friends = (snapshot.data as List)
                    .map((item) => Map.from(item))
                    .toList();
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
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
                          subtitle: Text("Upcoming Events: 1"),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
                          ),
                        ),
                      );
                    },
                  );
                }
                else if(snapshot.hasError) {
                return Text("No friends yet.");
                }

                return CircularProgressIndicator();

              },
            ),
          ),

          /// Add Friend Manually Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/addFriendFrom');
              },
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
