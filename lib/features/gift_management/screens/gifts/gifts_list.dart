// ignore_for_file: prefer_const_constructors

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
      if (args != null && !args.isEmpty) {
        controller.id = args['id'];
        controller.name = args['name'];
        print("giftslist args: ${args}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          /// List of Events
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
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: gifts.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            // color: index % 2 ==0 ?Colors.amber : null,
                            child: ListTile(
                              onTap: () {
                                widget.isFriend
                                    ? controller.toFriendGift(
                                        controller.args['UID'],
                                        controller.args['GIFTS'][index],
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
                                                if (await controller.deleteGift(
                                                    gifts[index]['ID']))
                                                  setState(() {});
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
                          );
                        },
                      );
                    }
                  }
                  return Center(child: Text("No gifts yet"));
                }),
          ),

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
