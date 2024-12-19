// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/common/widgets/containers/status_container.dart';
import 'package:hedyety/common/widgets/template/template.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gifts_list_controller.dart';
import 'package:hedyety/my_theme.dart';
import 'package:hedyety/common/widgets/containers/filter_container.dart';

import '../../../../Repository/local_database.dart';

class GiftsList extends StatefulWidget {
  GiftsList({super.key, required this.isFriend, this.isFiltered = false});

  final bool isFriend;
  bool? isFiltered;

  @override
  State<GiftsList> createState() => _GiftsListState();
}

class _GiftsListState extends State<GiftsList> {
  GiftsListController controller = GiftsListController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller.isFriend = widget.isFriend;
    if (widget.isFriend) {
      controller.args = ModalRoute.of(context)?.settings.arguments;
      if (controller.args != null) {
        print("args friend ${controller.args}");
      }
    } else {

      final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
                print('ddddddd $args');
      if (args != null && !args.isEmpty) {
        controller.id = args['id'];
        controller.name = args['name'];
        print("giftslist args: ${args}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.giftAnimKey = GlobalKey();
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
                      isFriend: widget.isFriend,
                    );
                  });
            },
            icon: Icon(Icons.filter_alt_outlined),
          ),
        )
      ],
      child: Column(
        children: [
          /// Freind List of Events
          widget.isFriend == true
              ? Expanded(
                  child: StreamBuilder(
                    stream: controller.getGiftStream(), // The stream to listen to
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Center(
                            child: CircularProgressIndicator(
                          color: MyTheme.primary,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error ${snapshot.error}"));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text("No data yet."));
                      }
                      {

                        Map<dynamic, dynamic> map =
                            snapshot.data?.snapshot.value as dynamic ?? {};
                        List<dynamic> gifts = [];
                        List<dynamic> ids = [];
                        gifts.clear();
                        gifts = map.values.toList();
                        ids = map.keys.toList();
                        for (int i = 0; i < gifts.length; i++) 
                          gifts[i]['id'] = ids[i]; 
                          controller.myList.clear();
                        controller.myList = gifts;
                        if(widget.isFiltered== true){ controller.filterFriend();print('filtttttered ${controller.args}');}
                                                // return Center(child: Text("$gifts"));

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: controller.myList.length,
                          itemBuilder: (
                            BuildContext,
                            int index,
                          ) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  print('argsss ${controller.args} $ids');
                                  widget.isFriend
                                      ? controller.toFriendGift(
                                          controller.args['uid'],
                                          controller.myList[index]['id'],
                                          controller.args['eid'],
                                           controller.myList[index]['STATUS']
                                          )
                                      : controller.toEdit( controller.myList[index]);
                                },
                                title: Text("${controller.myList[index]['NAME']}"),
                                subtitle: Text(
                                    "Category: ${controller.myList[index]['CATEGORY']}\n Status: Upcoming"),
                                trailing: Wrap(
                                  children: [
                                          controller.myList[index]['STATUS'] == "pledged" ||  controller.myList[index]['STATUS'] == "purchased"
                                            ?   controller.myList[index]['STATUS'] == "pledged" ? StatusContainer(staus: "Pledged") : StatusContainer(staus: "Purhcased")
                                            :  IconButton(
                                                icon: Icon(Icons.handshake,
                                                    color: Colors.amber),
                                                tooltip: 'Pledge',
                                                onPressed: () {})
                                        
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              : SizedBox.shrink(),


          /// List of Gifts
          widget.isFriend == false ? 
          Expanded(
            child: FutureBuilder(
                future: widget.isFriend == false
                    ? controller.readGifts(widget.isFiltered)
                    : controller.readFriendGifts(),
                builder: (BuildContext, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error"));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // List gifts = (snapshot.data as List).
                      //   map((e) => Map.from(e)).toList();
                      List gifts = widget.isFiltered == false
                          ? controller.myList
                          : controller.filtered;
                      print('snapshot $gifts');
                      return AnimatedList(
                        key: controller.giftAnimKey,
                        padding: const EdgeInsets.all(8),
                        initialItemCount: gifts.length,
                        itemBuilder: (context, int index, anim) {
                          return SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: anim,
                            child: Card(
                              // color: index % 2 ==0 ?Colors.amber : null,
                              child: ListTile(
                                onTap: () {
                                  widget.isFriend
                                      ? controller.toFriendGift(
                                          controller.args['UID'],
                                          controller.args['GIFTS'][index],
                                          controller.args['EID'],
                                          gifts[index]['STATUS']
                                          )
                                      : controller.toEdit(gifts[index]);
                                },
                                title: Text("${gifts[index]['NAME']}"),
                                subtitle: Text(
                                    "Category: ${gifts[index]['CATEGORY']}\n Status: Upcoming"),
                                trailing: Wrap(
                                  children: [
                                    widget.isFriend
                                        ? gifts[index]['STATUS'] == "pledged" || gifts[index]['STATUS'] == "purchased"
                                            ?  gifts[index]['STATUS'] == "pledged" ? StatusContainer(staus: "Pledged") : StatusContainer(staus: "Purhcased")
                                            :  IconButton(
                                                icon: Icon(Icons.handshake,
                                                    color: Colors.amber),
                                                tooltip: 'Pledge',
                                                onPressed: () {})
                                        : gifts[index]['STATUS'] == "pledged" || gifts[index]['STATUS'] == "purchased"
                                            ?  gifts[index]['STATUS'] == "pledged" ? StatusContainer(staus: "Pledged") : StatusContainer(staus: "Purhcased")
                                            : Wrap(children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              color: MyTheme.editButtonColor,
                                              onPressed: () {
                                                print('pressed $index');
                                                controller.toEdit(gifts[index]);
                                              },
                                            ),
                                            SizedBox(width: 10),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              color: MyTheme.primary,
                                              onPressed: () async {
                                                try {
                                                  print("trying deleting gift");
                                                   controller.deleteGift(
                                                      gifts[index]['ID'], index, "${gifts[index]['NAME']}", "Category: ${gifts[index]['CATEGORY']}\n Status: Upcoming");
                                                    // setState(() {});
                                                } catch (e) {
                                                  print(
                                                      'Error deleting event ${e}');
                                                }
                                              },
                                            ),
                                            // SizedBox(width: 10),
                                          ]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return Center(child: Text("No gifts yet"));
                }),
          ) : SizedBox.shrink(),

          /// Add New Gift Button
          widget.isFriend
              ? SizedBox.shrink()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.toAddGift();
                    },
                    child: const Text("➕ Add New Gift 🎁"),
                  ),
                ),
        ],
      ),
    );
  }
}
