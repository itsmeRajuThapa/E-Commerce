import 'package:emart_user/consts/consts.dart';
import '../../controller/product_controller.dart';
import 'orders_details.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "My Order"
              .text
              .size(18)
              .color(darkFontGrey)
              .fontFamily(bold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
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
                child: "No Order Yet!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      tileColor: data[index]["order_confirmed"] == false
                          ? Colors.amber
                          : textfieldGrey,
                      leading: data[index]["order_confirmed"] == false
                          ? IconButton(
                              hoverColor: Colors.pink,
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => deleteDialog(
                                        context,
                                        controller
                                            .deleteOrder(data[index].id)));
                                return;
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: darkFontGrey,
                              ),
                            )
                          : const Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                            ),

                      //  "${index + 1}"
                      //     .text
                      //     .fontFamily(bold)
                      //     .color(darkFontGrey)
                      //     .xl
                      //     .make(),
                      title: data[index]["order_code"]
                          .toString()
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                      subtitle: data[index]['total_amount']
                          .toString()
                          .numCurrency
                          .text
                          .fontFamily(bold)
                          .make(),
                      trailing: IconButton(
                        onPressed: () {
                          Get.to(() => OrdersDetails(data: data[index]));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: darkFontGrey,
                        ),
                      ),
                    ).box.padding(EdgeInsets.all(5)).make();
                  });
            }
          },
        ));
  }

  Widget deleteDialog(context, what) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
          const Divider(),
          10.heightBox,
          "Are you sure you want to exit"
              .text
              .size(16)
              .color(darkFontGrey)
              .make(),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                color: redColor,
                onPressed: () {
                  what;
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              ourButton(() {
                Navigator.pop(context);
              }, redColor, whiteColor, "No"),
            ],
          )
        ],
      ).box.color(lightGrey).padding(const EdgeInsets.all(15)).roundedSM.make(),
    );
  }
}
