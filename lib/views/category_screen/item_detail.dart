import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/controller/product_controller.dart';
import 'package:emart_user/views/chat_screen/chart_screen.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            // toolbarHeight: 40,
            title: title!.text
                .size(18)
                .color(darkFontGrey)
                .fontFamily(bold)
                .make(),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              Obx(
                () => IconButton(
                    onPressed: () {
                      if (controller.isFav.value) {
                        controller.removeFromWishlist(data.id, context);
                        // controller.isFav(false);
                      } else {
                        controller.addToWishlist(data.id, context);
                        // controller.isFav(true);
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: controller.isFav.value ? redColor : darkFontGrey,
                    )),
              )
            ]),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 250,
                          itemCount: data["p_imgs"].length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            return Image.network(data["p_imgs"][index],
                                width: double.infinity, fit: BoxFit.cover);
                          }),
                      10.heightBox,
                      //title and details section
                      title!.text
                          .size(18)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      8.heightBox,
                      //rating
                      VxRating(
                        isSelectable: false,
                        value: double.parse(data["p_rating"]),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 20,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      "Rs. ${data["p_price"]}"
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(10)
                          .make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Seller".text.white.fontFamily(semibold).make(),
                              5.heightBox,
                              "${data["p_seller"]}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .size(10)
                                  .make(),
                            ],
                          )),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.message_rounded,
                                color: darkFontGrey),
                          ).onTap(() {
                            Get.to(() => const ChartScreen(), arguments: [
                              data["p_seller"],
                              data["vender_id"]
                            ]);
                          })
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),

                      //color selection
                      20.heightBox,

                      Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color: "
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Row(
                                  children: List.generate(
                                    data["p_colors"].length,
                                    (index) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VxBox()
                                            .size(40, 40)
                                            .roundedFull
                                            .color(
                                                Color(data["p_colors"][index])
                                                    .withOpacity(1.0))
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .make()
                                            .onTap(() {
                                          controller.changeColorIndex(index);
                                        }),
                                        Visibility(
                                            visible: index ==
                                                controller.colorIndex.value,
                                            child: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity:"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.decreaseQuantity();
                                          controller.calculateTotalPrice(
                                              int.parse(data["p_price"]));
                                        },
                                        icon: const Icon(Icons.remove)),
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(darkFontGrey)
                                        .fontFamily(bold)
                                        .make(),
                                    IconButton(
                                        onPressed: () {
                                          controller.increaseQuantity(
                                              int.parse(data["p_quantity"]));
                                          controller.calculateTotalPrice(
                                              int.parse(data["p_price"]));
                                        },
                                        icon: const Icon(Icons.add)),
                                    8.widthBox,
                                    "(${data["p_quantity"]} available)"
                                        .text
                                        .color(textfieldGrey)
                                        .make()
                                  ]),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                            //total new
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total: "
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                "Rs. ${controller.totalPrice.value}"
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make()
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        ).box.white.shadowSm.make(),
                      ),
                      10.heightBox,
                      //Description of selecte
                      "Description"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data["p_desc"]}".text.color(darkFontGrey).make(),
                      //Buttons selection
                      10.heightBox,
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            itemDetailButtonsList.length,
                            (index) => ListTile(
                                  title: itemDetailButtonsList[index]
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  trailing: const Icon(Icons.arrow_forward),
                                )),
                      ),
                    ]),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(() {
                if (controller.quantity.value > 0) {
                  controller.addToCart(
                      data["p_name"],
                      data["p_imgs"][0],
                      data["p_seller"],
                      data["p_colors"][controller.colorIndex.value],
                      controller.quantity.value,
                      controller.totalPrice.value,
                      context,
                      data["vender_id"]);
                  VxToast.show(context, msg: "Added to cart");
                } else {
                  VxToast.show(context, msg: "Minumum 1 product is required");
                }
              }, redColor, whiteColor, "Add to Cart"),
            )
          ],
        ),
      ),
    );
  }
}
