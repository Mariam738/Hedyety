// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/status_container.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

import '../../../../Database/local_database.dart';

class GiftsList extends StatefulWidget {
  GiftsList({super.key, required this.isFriend});

  final bool isFriend;

  @override
  State<GiftsList> createState() => _GiftsListState();
}

class _GiftsListState extends State<GiftsList> {
  LocalDatabse mydb = LocalDatabse();



  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map?;
    int id = 0;
    if (args != null && !args.isEmpty) {
      print("giftslist args: ${args}");
    }

    return Template(
      title: "Gifts List",
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FilteContainer(
                      categoryList: MyConstants.categoryList,
                      isEvent: false,
                    );
                  });
            },
            icon: Icon(Icons.filter_alt_outlined),
          ),
        )
      ],
      child: Column(
        children: [

          /// List of Events
          Expanded(
            child: FutureBuilder(
                future: mydb.readData(
          "SELECT * FROM 'GIFTS' WHERE EVENTSID = ${args!['id']}"),
                builder: (BuildContext, snapshot) {
                  print(snapshot.connectionState);
                  if(snapshot.connectionState ==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.connectionState ==ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    }
                    else if (snapshot.hasData && snapshot.data != null) {
                      List gifts = (snapshot.data as List).
                        map((e) => Map.from(e)).toList();
                      print(gifts);
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: gifts.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            // color: index % 2 ==0 ?Colors.amber : null,
                            child: ListTile(
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   '/giftsList',
                                //   arguments: 'args',
                                // );
                              },
                              title: Text("${gifts[index]['NAME']}"),
                              subtitle: Text(
                                  "Category: ${gifts[index]['CATEGORY']}\n Status: Upcoming"),
                              trailing: Wrap(
                                children: [
                                  index % 2 == 0
                                      ? widget.isFriend
                                      ? IconButton(
                                      icon: Icon(Icons.handshake,
                                          color: Colors.amber),
                                      tooltip: 'Pledge',
                                      onPressed: () {})
                                      : Wrap(children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: MyTheme.editButtonColor,
                                      onPressed: () {
                                        print('pressed $index');
                                        Navigator.pushNamed(context, '/editGiftForm',
                                            arguments: {
                                              "id": gifts[index]['ID'],
                                              "name": gifts[index]['NAME'],
                                              "description": gifts[index]['DESCRIPTION'],
                                              "category": gifts[index]['CATEGORY'],
                                              "price": gifts[index]['PRICE'],
                                              "eventid": gifts[index]['EVENTSID'],
                                            });
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: MyTheme.primary,
                                      onPressed: () async {
                                        try {
                                          int res = await mydb.deleteData(
                                              "DELETE FROM GIFTS WHERE ID=${gifts[index]['ID']}");
                                          print("Success deleting gift");
                                          setState(() {});
                                          // readGifts(id);
                                        } catch (e) {
                                          print('Error deleting event ${e}');
                                        }
                                      },
                                    ),
                                    // SizedBox(width: 10),
                                  ])
                                      : StatusContainer(staus: "Pledged"),
                                ],
                              ),
                            ),
                          );
                        },

                      );
                    }
                  }
                  return Center(child: Text("No gifts yet"));

                }
            ),
          ),

          /// Add New Gift Button
          widget.isFriend
              ? SizedBox.shrink()
              : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addGiftForm', arguments: {'id' : args['id']});
              },
              child: const Text("➕ Add New Gift 🎁"),
            ),
          ),
        ],
      ),
    );
  }
}

