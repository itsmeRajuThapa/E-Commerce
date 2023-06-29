import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/controller/cart_controller.dart';
import 'package:emart_user/views/cart_screen/shipping_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          toolbarHeight: 45,
          automaticallyImplyLeading: false,
          title: "Shopping cart"
              .text
              .size(20)
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
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
                child: "Cart is empty!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Image.network(
                                      "${data[index]["img"]}",
                                      width: 80,
                                      fit: BoxFit.cover),
                                  title:
                                      "${data[index]["title"]}  (x${data[index]["qty"]})"
                                          .text
                                          .fontFamily(semibold)
                                          .size(16)
                                          .make(),
                                  subtitle: "Rs.${data[index]["tprice"]}"
                                      .text
                                      .color(redColor)
                                      .fontFamily(semibold)
                                      .make(),
                                  trailing:
                                      const Icon(Icons.delete, color: redColor)
                                          .onTap(() {
                                    FirestoreServices.deleteDocument(
                                        data[index].id);
                                  }),
                                );
                              })),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            "Total price"
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            "Rs. ${controller.totalP.value}"
                                .text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.all(12))
                            .color(lightGolden)
                            .width(context.screenWidth - 60)
                            .roundedSM
                            .make(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Positioned(
                            child: MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          color: redColor,
                          onPressed: () {
                            Get.to(() => const ShippingDetails());
                          },
                          child: const Text(
                            "Process to Shipping",
                            style:
                                TextStyle(color: whiteColor, fontFamily: bold),
                          ),
                        )),
                      ),
                    ],
                  ));
            }
          },
        ));
  }
}
