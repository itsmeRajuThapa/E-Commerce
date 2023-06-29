import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/order_screen/order_screen.dart';
import '../chat_screen/messaging_screen.dart';
import '../wishlist_screen/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgwidget(Scaffold(
      body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              final data = snapshot.data!.docs[0];
              return SafeArea(
                  child: Column(
                children: [
                  //Edit profile button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.edit, color: whiteColor))
                        .onTap(() {
                      controller.nameController.text = data["name"];

                      Get.to(() => EditProfileScreen(data: data));
                    }),
                  ),
                  //Users details section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(children: [
                      data["imageUrl"] == ""
                          ? Image.asset(imgProfile,
                                  width: 70, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make()
                          : Image.network(data["imageUrl"],
                                  width: 70, fit: BoxFit.cover)
                              .box
                              .roundedFull
                              .clip(Clip.antiAlias)
                              .make(),
                      10.widthBox,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${data["name"]}"
                              .text
                              .size(16)
                              .fontFamily(semibold)
                              .white
                              .make(),
                          "${data["email"]}".text.size(10).white.make(),
                        ],
                      )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: whiteColor)),
                        onPressed: () async {
                          await Get.put(AuthController())
                              .signoutMethod(context);
                          Get.offAll(() => LoginScreen());
                        },
                        child: "Logout"
                            .text
                            .fontFamily(semibold)
                            .size(10)
                            .white
                            .make(),
                      )
                    ]),
                  ),
                  20.heightBox,
                  FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            ),
                          );
                        } else {
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(context.screenWidth / 3.2,
                                  countData[0].toString(), "in your cart"),
                              detailsCard(context.screenWidth / 3.2,
                                  countData[1].toString(), "in your wishlist"),
                              detailsCard(context.screenWidth / 3.2,
                                  countData[2].toString(), " your orders")
                            ],
                          );
                        }
                      }),

                  ListView.separated(
                    itemCount: profileButtonslist.length,
                    separatorBuilder: (context, index) {
                      return const Divider(color: lightGrey);
                    },
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const OrderScreen());
                              break;
                            case 1:
                              Get.to(() => const WishlistScreen());
                              break;
                            case 2:
                              Get.to(() => const MessagesScreen());
                              break;
                          }
                        },
                        leading: Image.asset(
                          profileButtonsIcons[index],
                          width: 22,
                          color: darkFontGrey,
                        ),
                        title: profileButtonslist[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    },
                  )
                      .box
                      .white
                      .rounded
                      .margin(const EdgeInsets.all(12))
                      .padding(const EdgeInsets.symmetric(horizontal: 15))
                      .shadowSm
                      .make()
                      .box
                      .color(redColor)
                      .make()
                ],
              ));
            }
          }),
    ));
  }
}
