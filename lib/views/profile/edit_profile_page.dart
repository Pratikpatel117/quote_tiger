import 'dart:io';
import 'package:quote_tiger/components/buttons/empty_button.dart';
import 'package:quote_tiger/components/buttons/filled_button.dart';
import 'package:quote_tiger/components/buttons/go_back_button.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quote_tiger/components/country_picker.dart';
import 'package:quote_tiger/components/input_fields/tiger/quote_tiger_input_field.dart';
import 'package:quote_tiger/components/logos/trademark.dart';
import 'package:quote_tiger/components/notifications/info_dialog.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/provider/auth_provider.dart';
import 'package:quote_tiger/services/storage/image.dart';
import 'package:quote_tiger/services/storage/storage.dart';
import 'package:quote_tiger/utils/globals.dart';

import '../../components/buttons/filled_icon_button.dart';
import '../../components/icons/qicon.dart';
import '../../utils/flags.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel localUser;
  const EditProfilePage({Key? key, required this.localUser}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController socialLinkController = TextEditingController();

  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  List<String> socialLinks = [];
  final ImageService imageService = ImageService();
  bool changed = false;
  bool loading = false;

  File? newImageFile;

  bool isDifferent() {
    if (newImageFile != null) return true;
    if (websiteController.text != (widget.localUser.website ?? '')) return true;
    if (companyNameController.text != widget.localUser.company) return true;
    if (descriptionController.text != widget.localUser.description) return true;
    if (countryController.text != widget.localUser.location) return true;
    if (fullNameController.text != widget.localUser.fullName) return true;
    if (instagramController.text != (widget.localUser.instagram ?? '')) {
      return true;
    }
    if (facebookController.text != (widget.localUser.facebook ?? '')) {
      return true;
    }
    if (twitterController.text != (widget.localUser.twitter ?? '')) return true;
    if (linkedinController.text != (widget.localUser.linkedin ?? '')) {
      return true;
    }
    return false;
  }

  Future<void> getNewImage() async {
    File? imageFile = await imageService.imagePickerDialog(context);
    if (imageFile == null) {
      return;
    }

    setState(() {
      newImageFile = imageFile;
    });
  }

  SizedBox secondayWhiteSpace() {
    return const SizedBox(
      height: 12,
    );
  }

  SizedBox primaryWhiteSpace() {
    return const SizedBox(
      height: 24,
    );
  }

  @override
  void initState() {
    instagramController.text = widget.localUser.instagram ?? '';
    facebookController.text = widget.localUser.facebook ?? '';
    twitterController.text = widget.localUser.twitter ?? '';
    linkedinController.text = widget.localUser.linkedin ?? '';
    websiteController.text = widget.localUser.website ?? '';
    descriptionController.text = widget.localUser.description;
    fullNameController.text = widget.localUser.fullName;
    companyNameController.text = widget.localUser.company ?? '';
    countryController.text = widget.localUser.location;

    if (!countries.contains(countryController.text)) {
      countryController.text = 'Country';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModelProvider = Provider.of<UserModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFFCA205),
                Color(0xFFFFC55F),
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoBackButton(context),
            const Trademark(),
            if (isDifferent())
              FilledIconButton(
                icon: QIcons.check,
                size: 40,
                onPressed: () async {
                  if (!isDifferent()) {
                    showInfo(context, 'No changes seem to have been made');
                    return;
                  }

                  setState(() {
                    loading = true;
                  });
                  String? imageURL;
                  if (newImageFile != null) {
                    imageURL = await ImageService().uploadImage(
                        newImageFile!, 'users/${widget.localUser.id}');
                    if (imageURL != null &&
                        widget.localUser.image != defaultUserImageUrl) {
                      StorageService().deleteFile(widget.localUser.image);
                    }
                  }
                  authProvider
                      .updateUser(
                    image: imageURL,
                    website: websiteController.text,
                    description: descriptionController.text,
                    fullName: fullNameController.text,
                    company: companyNameController.text,
                    location: countryController.text,
                    instagram: instagramController.text,
                    facebook: facebookController.text,
                    twitter: twitterController.text,
                    linkedin: linkedinController.text,
                  )
                      .then((value) {
                    loading = false;
                    Navigator.pop(context);
                  });
                },
              )
            else
              const SizedBox(
                height: 40,
                width: 40,
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  secondayWhiteSpace(),
                  Center(
                    child: InkWell(
                      onTap: () {
                        getNewImage();
                      },
                      child: Ink(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: newImageFile != null
                                  ? Image.file(newImageFile!).image
                                  : NetworkImage(userModelProvider.image),
                            ),
                            const Text(
                              'Edit Profile Picture',
                              style: TextStyle(
                                color: Color(0xFFFCA205),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  secondayWhiteSpace(),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: websiteController,
                      hint: 'Website',
                      message: 'Website'),
                  secondayWhiteSpace(),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: descriptionController,
                      hint: 'Bio',
                      message: 'Bio'),
                  primaryWhiteSpace(),
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  secondayWhiteSpace(),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: fullNameController,
                      hint: 'Full Name',
                      message: 'Full Name'),
                  secondayWhiteSpace(),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: companyNameController,
                      hint: 'Company Name',
                      message: 'Company Name'),
                  secondayWhiteSpace(),
                  CountryPicker(
                    onChanged: (e) {
                      if (isDifferent()) {
                        if (changed == false) {
                          setState(() {
                            changed = true;
                          });
                        }
                      } else {
                        if (changed == true) {
                          setState(() {
                            changed = false;
                          });
                        }
                      }
                    },
                    prefix: getFlagFromCountryName(
                        authProvider.locationController.text),
                    controller: countryController,
                    title: 'Country',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Social Links",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //buildSocialLinks(),
                  QuoteTigerInputField(
                      controller: instagramController,
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      hint: 'Enter a link to your Instagram profile',
                      message: 'Instagram'),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: facebookController,
                      hint: 'Enter a link to your Facebook profile',
                      message: 'Facebook'),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: twitterController,
                      hint: 'Enter a link to your Twitter profile',
                      message: 'Twitter'),
                  QuoteTigerInputField(
                      onChanged: (e) {
                        if (isDifferent()) {
                          if (changed == false) {
                            setState(() {
                              changed = true;
                            });
                          }
                        } else {
                          if (changed == true) {
                            setState(() {
                              changed = false;
                            });
                          }
                        }
                      },
                      controller: linkedinController,
                      hint: 'Enter a link to your Linkedin profile',
                      message: 'Linkedin'),
                ],
              ),
            ),
          ),
          if (loading)
            ClipRect(
              // <-- clips to the 200x200 [Container] below
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> socialLinkAddDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuoteTigerInputField(
                  controller: socialLinkController,
                  hint: 'Enter a social link',
                  message: 'Enter a social link'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EmptyTextButton(
                    width: MediaQuery.of(context).size.width / 3,
                    onPressed: () {
                      Navigator.pop(_);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  FilledTextButton(
                      width: MediaQuery.of(context).size.width / 3,
                      onPressed: () {
                        bool isValidUrl =
                            Uri.parse(socialLinkController.text).isAbsolute;

                        if (isValidUrl) {
                          socialLinks.add(socialLinkController.text);
                          setState(() {});
                        } else {
                          showError(context, 'Not a valid url');
                        }
                        Navigator.pop(_);
                      },
                      fontSize: 16,
                      message: 'Add social link'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSocialLinks() {
    List<Widget> socialLinkTexts = [];
    for (var socialLink in socialLinks) {
      socialLinkTexts.add(Text(socialLink));
    }

    return Column(
      children: socialLinkTexts,
    );
  }
}
