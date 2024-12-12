import 'package:chat_app/constant.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  static String id = 'homeView';
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  // FirebaseFirestore.instance
                  //     .collection('messages')
                  //     .snapshots()
                  //     .forEach((querySnapshot) {
                  //   for (QueryDocumentSnapshot docSnapshot
                  //       in querySnapshot.docs) {
                  //     docSnapshot.reference.delete();
                  //   }
                  // });
                },
                child: const Icon(
                  Icons.cleaning_services_outlined,
                  color: Color.fromARGB(255, 218, 149, 144),
                ),
              ),
            )
          ],
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/scholar.png",
                height: 50,
              ),
              const Text(
                "Chat",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: messages.orderBy('createdAt').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MessagesModel> messagesList = [];
              for (var i = 0; i < snapshot.data!.docs.length; i++) {
                messagesList.add(MessagesModel.fromJson(
                  snapshot.data!.docs[i],
                ));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatBubble(message: messagesList[index].message)
                            : ChatBubbleForFriend(
                                message: messagesList[index].message);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (value) {
                        messages.add({
                          'message': value,
                          'createdAt': DateTime.now(),
                          'id': email
                        });
                        controller.clear();
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn);
                      },
                      decoration: InputDecoration(
                          hintText: "Send Message",
                          suffixIcon: Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: kPrimaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: kPrimaryColor))),
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: Text("Loading..."));
            }
          },
        ),
      ),
    );
  }
}
