import 'package:emart_user/views/category_screen/item_detail.dart';
import 'package:emart_user/consts/consts.dart';
import '../../../controller/product_controller.dart';

class Lowtohigh extends StatefulWidget {
  const Lowtohigh({super.key});

  @override
  State<Lowtohigh> createState() => _LowtohighState();
}

class _LowtohighState extends State<Lowtohigh> {
  var controller = Get.put(ProductController());
  dynamic getSortedData;
  @override
  Widget build(BuildContext context) {
    return bgwidget(Scaffold(
      appBar: AppBar(
        title: "title".text.size(16).fontFamily(bold).white.make(),
      ),
      body: StreamBuilder(
          stream: getSortedData(),
          // FirestoreServices.getProducts(widget.title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                ),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Expanded(
                child: "No Products Found!"
                    .text
                    .color(darkFontGrey)
                    .makeCentered(),
              );
            } else {
              var data = snapshot.data!.docs;

              return Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(data[index]["p_imgs"][0],
                            height: 150, width: 200, fit: BoxFit.cover),
                        "${data[index]["p_name"]}"
                            .text
                            .fontFamily(semibold)
                            .size(10)
                            .color(darkFontGrey)
                            .make(),
                        10.heightBox,
                        "Rs. ${data[index]["p_price"]}"
                            .text
                            .color(redColor)
                            .fontFamily(bold)
                            .size(8)
                            .make()
                      ],
                    )
                        .box
                        .white
                        .margin(const EdgeInsets.symmetric(horizontal: 4))
                        .roundedSM
                        .outerShadowSm
                        .padding(const EdgeInsets.all(12))
                        .make()
                        .onTap(() {
                      controller.checkIffav(data[index]);
                      Get.to(() => ItemDetails(
                          title: "${data[index]['p_name']}",
                          data: data[index]));
                    });
                  },
                ),
              );
            }
          }),
    ));
  }
}
