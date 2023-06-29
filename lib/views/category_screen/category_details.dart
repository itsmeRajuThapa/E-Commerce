import 'package:emart_user/views/category_screen/item_detail.dart';
import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/category_screen/sort_item/low%20_to_high.dart';
import '../../controller/product_controller.dart';
import '../timer/timer.dart';
import '../timer/timrt_screen.dart';

class CategoryDetails extends StatefulWidget {
  final String title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  List<String> sortList = ["Low to High", "High to Low"];

  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.put(ProductController());
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    return bgwidget(Scaffold(
        appBar: AppBar(
          title: widget.title.text.size(16).fontFamily(bold).white.make(),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == "Low to High") {
                  Get.to(() => CountdownTimer());
                } else {
                  Get.to(() => TimerControlScreen());
                }
              },
              itemBuilder: (context) {
                return sortList
                    .map((e) => PopupMenuItem(
                        value: e,
                        child: Text(e,
                            style: const TextStyle(fontFamily: semibold))))
                    .toList();
              },
              icon: const Icon(
                Icons.article_sharp,
                color: whiteColor,
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    controller.subcat.length,
                    ((index) => "${controller.subcat[index]}"
                            .text
                            .size(10)
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .makeCentered()
                            .box
                            .white
                            .rounded
                            .size(110, 60)
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .make()
                            .onTap(() {
                          switchCategory("${controller.subcat[index]}");
                          setState(() {});
                        }))),
              ),
            ),
            20.heightBox,
            StreamBuilder(
                stream: productMethod,
                // stream: FirestoreServices.getProducts(widget.title),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
          ],
        )));
  }
}
