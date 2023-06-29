import 'package:emart_user/consts/consts.dart';
import 'package:emart_user/views/home_screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  bool _isVisible = false;
  bool _isVisible1 = false;
  var controller = Get.put(AuthController());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = "";

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bgwidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          (context.screenHeight * 0.06).heightBox,
          applogoWidget(),
          8.heightBox,
          "Sign Up to $appname".text.fontFamily(bold).white.size(18).make(),
          8.heightBox,
          Obx(
            () => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    customTextField(name, nameController, nameHint, false, user,
                        Icons.person),
                    customTextField(email, emailController, emailHint, false,
                        validateEmail, Icons.email),
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
                          controller: passwordController,

                          // ignore: non_constant_identifier_names
                          validator: validatePassword,
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        comformpass.text
                            .color(redColor)
                            .fontFamily(semibold)
                            .size(16)
                            .make(),
                        5.heightBox,
                        TextFormField(
                          obscureText: !_isVisible1,
                          controller: passwordRetypeController,
                          validator: validatePassword,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: redColor,
                                size: 25,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible1 = !_isVisible1;
                                  });
                                },
                                icon: _isVisible1
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
                        Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: redColor,
                            checkColor: whiteColor,
                            value: isCheck,
                            onChanged: (onValue) {
                              setState(() {
                                isCheck = onValue;
                              });
                            }),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(children: [
                            TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey)),
                            TextSpan(
                                text: termAndCond,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor)),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                    fontFamily: regular, color: fontGrey)),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                    fontFamily: regular, color: redColor))
                          ])),
                        ),
                      ],
                    ),
                    2.heightBox,
                    controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(() async {
                            if (isCheck != false) {
                              setState(() {
                                controller.isLoading(true);
                                errorMessage = "";
                              });

                              if (_key.currentState!.validate()) {
                                try {
                                  if (validatePassword1(passwordController.text,
                                      passwordRetypeController.text)) {
                                    await controller
                                        .signupMethod(emailController.text,
                                            passwordController.text, context)
                                        .then((value) {
                                      return controller.storeUserData(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text);
                                    }).then((value) {
                                      VxToast.show(context, msg: loggedin);
                                      Get.offAll(() => const Home());
                                    });
                                  }
                                } on FirebaseAuthException catch (error) {
                                  errorMessage = errorMessage;
                                  //auth.signOut();
                                }
                              }
                              setState(() {
                                controller.isLoading(false);
                              });
                            }
                          }, isCheck == true ? redColor : lightGrey, whiteColor,
                                signup)
                            .box
                            .width(context.screenWidth - 50)
                            .make(),
                    10.heightBox,
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: "Already have an account ",
                          style: TextStyle(fontFamily: bold, color: fontGrey)),
                      TextSpan(
                          text: login,
                          style: TextStyle(fontFamily: bold, color: redColor)),
                    ])).onTap(() {
                      Get.back();
                    })
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
          )
        ]),
      ),
    ));
  }

  static bool validatePassword1(String value1, String value2) {
    if (value1.trim() == value2.trim()) {
      return true;
    }
    Get.snackbar(
      "Error",
      "Confirm Password do not match",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    return false;
  }
}
