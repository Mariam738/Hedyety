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

  // bool isLandscape = true;
  // LocalDatabse mydb = LocalDatabse();
  // List myList = [];

  // Future readFriends() async{
  //   List<Map> res=  await mydb.readData("SELECT * FROM 'USERS'");
  //   myList = [];
  //   myList.addAll(res);
  //   setState(() {
  //     print('set state');
  //     print(myList);
  //   });
  // }

  // @override
  // void initState()  {
  //   super.initState();
  //   try {
  //      mydb.initialize();
  //      print('trying to initialize');
  //   } catch(e) {
  //      print('Db initlizaiton error');
  //   }
  //   try {
  //     // List myList = [];
  //     // myList.addAll(res);
  //     readFriends();
  //     print('tyring to read ${myList}');

  //   } catch (e){
  //     print('unable to read ${e}');
  //   }
  // }


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
                onPressed: () {},
              ),
            ),
          ),

          /// List of Friends
          Expanded(

            child:
                  ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.friends.length,
                    itemBuilder: (context, index) {
                      if(index == 0) return SizedBox.shrink();
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/giftsList',
                              arguments: 'args',
                            );
                          },
                          title: Text("${controller.friends[index]['NAME']}"),
                          subtitle: Text("Upcoming Events: 1\n${controller.friends[index]['PHONE']}"),
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
              onPressed: () {
                controller.addContact();
              },
              child: const Text("Add Friend From My Contact List"),
            ),
          ),
        ],
      ),
    );
  }
}
