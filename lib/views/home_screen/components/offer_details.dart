import 'package:emart_user/consts/consts.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "Spical Offer".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      
    );
  }
}
