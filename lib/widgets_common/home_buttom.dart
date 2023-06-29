import 'package:emart_user/consts/consts.dart';

Widget homeButtons(width, height, icon, String title, onPress) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(icon, width: 23),
      8.heightBox,
      title.text.fontFamily(semibold).size(3).color(darkFontGrey).make()
    ],
  ).box.rounded.white.size(width, height).shadowSm.make();
}
