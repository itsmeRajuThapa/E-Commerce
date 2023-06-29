import 'package:emart_user/consts/consts.dart';
import '../../controller/chat_controller.dart';
import 'components/sender_bubble.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => controller.isloading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ),
                  )
                : Expanded(
                    child: StreamBuilder(
                    stream: FirestoreServices.getChatMessages(
                        controller.chatDocId.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          ),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: "Send a message..."
                              .text
                              .color(darkFontGrey)
                              .make(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .mapIndexed((currentValue, index) {
                            var data = snapshot.data!.docs[index];
                            return Align(
                                alignment: data["uid"] == currentUser?.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: senderBubble(data));
                          }).toList(),
                        );
                      }
                    },
                  ))),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textfieldGrey),
                      ),
                      hintText: "Type a message..."),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: redColor,
                    ))
              ],
            )
                .box
                .height(70)
                .padding(const EdgeInsets.all(8))
                .margin(const EdgeInsets.only(bottom: 4))
                .make()
          ],
        ),
      ),
    );
  }
}
