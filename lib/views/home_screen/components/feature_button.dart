import 'package:emart_user/consts/consts.dart';
import '../../category_screen/category_details.dart';

Widget featuredButton(String title, icon) {
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill),
      10.widthBox,
      title.text.fontFamily(semibold).size(5).color(darkFontGrey).make()
    ],
  )
      .box
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  });
}
