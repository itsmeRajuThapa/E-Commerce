import 'package:emart_user/views/category_screen/category_details.dart';
import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/controller/product_controller.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return bgwidget(Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).white.make(),
        ),
        body: Container(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 200),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(categoryImages[index],
                          height: 120, width: 200, fit: BoxFit.cover),
                      10.heightBox,
                      categoriesList[index]
                          .text
                          .color(darkFontGrey)
                          .align(TextAlign.center)
                          .make(),
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .clip(Clip.antiAlias)
                      .outerShadowSm
                      .make()
                      .onTap(() {
                    controller.getSubCategories(categoriesList[index]);
                    Get.to(() => CategoryDetails(title: categoriesList[index]));
                  });
                }))));
  }
}
