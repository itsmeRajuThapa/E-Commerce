// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:emart_user/consts/consts.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgwidget(Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //if data image url and controller path isempty
            data["imageUrl"] == "" && controller.profileImgPath.isEmpty
                ? Image.asset(imgProfile, width: 100, fit: BoxFit.cover)
                    .box
                    .roundedFull
                    .clip(Clip.antiAlias)
                    .make()
                //if data is not empty but controller path is empty
                : data["imageUrl"]! == "" && controller.profileImgPath.isEmpty
                    ? Image.network(data["imageUrl"],
                            width: 100, fit: BoxFit.cover)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    //if both are empty
                    : Image.file(
                        File(controller.profileImgPath.value),
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ourButton(() {
              controller.changeImage(context);
            }, redColor, whiteColor, "Change"),
            const Divider(),
            20.heightBox,
            customTextField(name, controller.nameController, nameHint, false,
                validateAll, Icons.person_2),
            10.heightBox,
            customTextField("Old Password", controller.oldpassController,
                passwordHint, true, validatePassword, Icons.password),
            10.heightBox,
            customTextField("New Password", controller.newpassController,
                passwordHint, true, validatePassword, Icons.password),
            20.heightBox,
            controller.isloading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                : SizedBox(
                    width: context.screenWidth - 60,
                    child: ourButton(() async {
                      controller.isloading(true);

                      //if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink = data["imageUrl"];
                      }

                      //if old password matches data base
                      if (data["password"] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: data["email"],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);
                        await controller.updateProfile(
                          controller.nameController.text,
                          controller.newpassController.text,
                          controller.profileImageLink,
                        );
                        VxToast.show(context, msg: "Updated");
                      } else {
                        VxToast.show(context, msg: "Wrong old password");
                        controller.isloading(false);
                      }
                    }, redColor, whiteColor, "Sava")),
          ],
        )
            .box
            .white
            .shadowSm
            .padding(const EdgeInsets.all(16))
            .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
            .rounded
            .make(),
      ),
    ));
  }
}
