import 'package:emart_user/consts/consts.dart';

Widget customTextField(
    String? title, controller, hint, isPass, validator, icon) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: redColor,
              size: 25,
            ),
            hintStyle: const TextStyle(
              fontFamily: semibold,
              color: textfieldGrey,
            ),
            hintText: hint,
            isDense: true,
            fillColor: lightGrey,
            filled: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: redColor))),
      ),
      5.heightBox,
    ],
  );
}

String? validateAll(String? formAll) {
  if (formAll == null || formAll.isEmpty) return "Required address is empty";
  return null;
}

String? user(String? user) {
  if (user == null || user.isEmpty) return "Email address is empty";
  var pattern = r'^[a-zA-Z]';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(user)) return "Invalid Email Address format";
  return null;
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return "Email address is empty";
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return "Invalid Email Address format";
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return "Email address is empty";
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return "Password must be at least 8 character,\n include an uppercase letter, number and symbol";
  return null;
}

String? validateMobile(String? value) {
  if (value == null || value.isEmpty) return "Mobile num.. is empty";
  String pattern = (r'^(98|97)\d{8}$');
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) return "Invalid number";
  return null;
}

String? validatePostalcode(String? value) {
  if (value == null || value.isEmpty) return "Mobile num.. is empty";
  String pattern = r'^((?!0{5})\d{5}|0[1-9]\d{4}|0{2}[1-9]\d{3})$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) return "Invalid Postal code";
  return null;
}
