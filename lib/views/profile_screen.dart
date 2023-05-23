import 'dart:io';

import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:ecommerce_app_flutter/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/sign_up_and_login_widgets.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController displayNameController;
  late TextEditingController aboutMeController;
  late TextEditingController numberController;

  late String currentUserId;
  String dialCodeDigits = "+00";
  String id = '';
  String displayName = '';
  String photoUrl = '';
  String phoneNumber = '';
  String aboutMe = '';

  bool isLoading = false;
  File? avatarImageFile;
  late ProfileProvider profileProvider;
  final FocusNode focusNodeNickname = FocusNode();

  void readLocal() {
    setState(() {

      displayName = profileProvider.getPrefs(FirestoreConstants.displayName) ?? "";
      photoUrl = profileProvider.getPrefs(FirestoreConstants.photoUrl) ?? "";

    });

    displayNameController = TextEditingController(text: displayName);
  }

  @override
  void initState() {
    super.initState();
    profileProvider = context.read<ProfileProvider>();
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
                    await getImage();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    child: avatarImageFile == null
                        ? photoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  photoUrl,
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
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              icon: const Icon(Icons.person),
                              controller: displayNameController,
                              label: "Name",
                              hintText: 'John Doe',
                              validator: RequiredValidator(errorText: 'Name Can\'t Be Empty'),
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              icon: const Icon(Icons.info_outline),
                              controller: aboutMeController,
                              label: const Text("About Me"),
                              hintText: 'I love cooking',
                              validator: (value) {
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            IntlPhoneField(
                              controller: numberController,
                              decoration: const InputDecoration(
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
                                aboutMe = aboutMeController.text;
                                phoneNumber = numberController.text;
                                updateFirestoreData();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Update Info'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(child: isLoading ? const CircularProgressIndicator() : const SizedBox.shrink())
        ],
      ),
    );
  }
}
