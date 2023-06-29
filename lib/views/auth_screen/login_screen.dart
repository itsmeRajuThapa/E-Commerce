import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/auth_screen/signup_screen.dart';
import 'package:emart_user/views/home_screen/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    // bool _isVisible false;
    // final GlobalKey<FormState> _key = GlobalKey<FormState>();

    return bgwidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          (context.screenHeight * 0.1).heightBox,
          applogoWidget(),
          10.heightBox,
          "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
          Obx(
            () => Form(
              key: _key,
              child: Column(
                children: [
                  customTextField(email, controller.emailController, emailHint,
                      false, validateAll, Icons.person_2),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        password.text
                            .color(redColor)
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                        5.heightBox,
                        TextFormField(
                          obscureText: !_isVisible,
                          controller: controller.passwordController,

                          // ignore: non_constant_identifier_names
                          validator: validateAll,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: redColor,
                                size: 25,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                icon: _isVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                              hintStyle: const TextStyle(
                                fontFamily: semibold,
                                color: textfieldGrey,
                              ),
                              hintText: passwordHint,
                              isDense: true,
                              fillColor: lightGrey,
                              filled: true,
                              border: InputBorder.none,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: redColor))),
                        ),
                        5.heightBox,
                      ]),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgotPass.text.make())),
                  5.heightBox,
                  controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(() async {
                          controller.isLoading(true);
                          if (_key.currentState!.validate()) {
                            await controller.loginMethod(context).then((value) {
                              if (value != null) {
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => const Home());
                              } else {
                                VxToast.show(context,
                                    msg: "Invalid password or email",
                                    textColor: redColor);
                              }
                            });
                          }
                          setState(() {
                            controller.isLoading(false);
                          });
                        }, redColor, whiteColor, login)
                          .box
                          .width(context.screenWidth - 50)
                          .make(),
                  5.heightBox,
                  createNewAcc.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(() {
                    Get.to(() => const SignupScreen());
                  }, golden, redColor, signup)
                      .box
                      .width(context.screenWidth - 50)
                      .make(),
                  10.heightBox,
                  loginwith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialIconsList[index],
                                  width: 30,
                                ),
                              ),
                            )),
                  )
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ),
          15.heightBox
        ]),
      ),
    ));
  }
}
