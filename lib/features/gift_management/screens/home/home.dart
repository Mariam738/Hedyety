// ignore_for_file: prefer_const_constructors

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/Repository/local_database.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/features/gift_management/screens/home/home_controller.dart';
import 'package:hedyety/features/gift_management/screens/home/landscape_home.dart';
import 'package:hedyety/my_theme.dart';

import '../../models/user_model.dart';

class Home extends StatefulWidget {
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController controller = HomeController();

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
              onPressed: () {
                controller.toEventForm();
              },
              child: const Text("Create Your Own Event/List"),
            ),
          ),
          const SizedBox(height: 16),

          /// Search Bar
          TextField(
            // onChanged: (val) {
            //   print('search $val');
            // },
            onSubmitted: (val) {
              // print('submit $val');
              // controller.search(val.toLowerCase());
              setState(() {});
            },
            controller: controller.searchEditing,
            cursorColor: MyTheme.primary,
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
              hintText: "Search for Friend by Name",
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.red.shade900,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.red.shade900),
                onPressed: () {
                  controller.searchEditing.clear();
                  setState(()  {});
                },
              ),
            ),
          ),

          /// List of Friends
           Expanded(
            child: FutureBuilder(
                future: controller.getFriends(),
                builder: (BuildContext, snapshot) {
                  if(snapshot.connectionState ==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.connectionState ==ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    }
                    else if (snapshot.hasData && snapshot.data != null) {
                      List friends = (snapshot.data as List).
                        map((e) => Map.from(e)).toList();
                        print('future s ${controller.friends}');
                      return
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.friends.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            controller.toFriendEvents(controller.friends[index]['PHONE']);
                            // Navigator.pushNamed(
                            //   context,
                            //   '/giftsList',
                            //   arguments: 'args',
                            // );
                          },
                          title: Text("${controller.friends[index]['NAME']}"),
                          subtitle: Text(
                              "Upcoming Events: 1\n${controller.friends[index]['PHONE']}"),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&s"),
                          ),
                        ),
                      );
                    },
                  );
                    
                     
                    }
                  }
                  return Center(child: Text("No friends yet"));

                }
            ),
          ),

      
          /// Add Friend Manually Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.toAddFriendFrom();
              },
              child: const Text("Add Friend Manually"),
            ),
          ),

          const SizedBox(height: 16),

          /// Add Friend From Contract Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                await controller.addContact();
                setState(() {});
              },
              child: const Text("Add Friend From My Contact List"),
            ),
          ),
        ],
      ),
    );
  }
}
