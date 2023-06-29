import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/chat_screen/chart_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "My Messages"
              .text
              .size(18)
              .color(darkFontGrey)
              .fontFamily(bold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getAllMessages(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No Messages Yet!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => const ChartScreen(), arguments: [
                                    data[index]["friend_name"],
                                    data[index]["toId"],
                                  ]);
                                },
                                leading: const CircleAvatar(
                                  backgroundColor: redColor,
                                  child: Icon(
                                    Icons.person,
                                    color: whiteColor,
                                  ),
                                ),
                                title: "${data[index]["friend_name"]}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                subtitle:
                                    "${data[index]["last_msg"]}".text.make(),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
