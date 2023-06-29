import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/controller/cart_controller.dart';
import 'package:emart_user/views/cart_screen/payment_method.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({super.key});

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
          height: 60,
          child: ourButton(() {
            if (_key.currentState!.validate()) {
              Get.to(() => const PaymentMethods());
            }
          }, redColor, whiteColor, "Continue")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                customTextField("Address", controller.addressController,
                    "Address", false, validateAll, Icons.house_rounded),
                customTextField("City", controller.cityController, "City",
                    false, validateAll, Icons.location_city),
                customTextField("State", controller.stateController, "State",
                    false, validateAll, Icons.directions),
                customTextField(
                    "Postal Code",
                    controller.postalcodeController,
                    "Postal Code",
                    false,
                    validatePostalcode,
                    Icons.post_add_sharp),
                customTextField("Phone", controller.phoneController, "Phone",
                    false, validateMobile, Icons.phone),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
