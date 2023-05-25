import 'dart:io';

import 'package:ecommerce_app_flutter/views/my_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/sign_up_and_login_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  late TextEditingController numberController;

  late String currentUserId;
  String dialCodeDigits = "+92";
  String id = '';
  String displayName = '';
  String photoUrl = '';
  String phoneNumber = '';
  String email = '';

  bool isLoading = false;
  File? avatarImageFile;
  late ProfileProvider profileProvider;
  final FocusNode focusNodeNickname = FocusNode();

  void readLocal() {
    profileProvider.readLocal();
    id = profileProvider.userId;
    displayName = profileProvider.displayName;
    email = profileProvider.email;
    photoUrl = profileProvider.photoURL;
    phoneNumber = profileProvider.phoneNumber;

    displayNameController = TextEditingController(text: displayName);
    emailController = TextEditingController(text: email);
    numberController = TextEditingController(text: phoneNumber);

    print("photo" + photoUrl);
  }

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xff1E1E1E),
        ),
        backgroundColor: const Color(0xff1E1E1E),
        centerTitle: true,
        elevation: 0,
        title: const Text("Profile "),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xff1E1E1E),
            width: double.infinity,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    await profileProvider.getImage().then((value) => Navigator.of(context, rootNavigator: true).pop());
                  },
                  child: Consumer<ProfileProvider>(
                    builder: (context, value, child) => Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(20),
                      child: avatarImageFile == null
                          ? value.photoURL.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          value.photoURL,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.account_circle,
                            size: 90,
                            color: Colors.grey,
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return SizedBox(
                              width: 90,
                              height: 90,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                          : const Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Colors.grey,
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.file(
                          avatarImageFile!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Muhammad Uzair",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "m67uzair@gmail.com",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                controller: displayNameController,
                                label: "Name",
                                validator: ValidationBuilder().required().build(),
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                controller: emailController,
                                label: "E-mail",
                                validator: ValidationBuilder().email().required().build(),
                              ),
                              const SizedBox(height: 20),
                              IntlPhoneField(
                                controller: numberController,
                                initialCountryCode: "PK",
                                decoration: const InputDecoration(
                                  enabled: false,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  label: Text('Phone Number'),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  displayName = displayNameController.text;
                                  email = emailController.text;
                                  phoneNumber = numberController.text;
                                  profileProvider.updateDisplayName(displayName);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Update Info'),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  authProvider.signOut();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Log out'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Consumer<ProfileProvider>(
          //   builder: (context, value, child) => Positioned(
          //     child: value.isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
