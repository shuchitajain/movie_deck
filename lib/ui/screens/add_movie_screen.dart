import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/ui/config.dart';
import 'package:movie_deck/ui/widgets/back_button_widget.dart';
import 'package:movie_deck/ui/widgets/form_field_widget.dart';
import 'package:movie_deck/ui/widgets/reusable_button_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({Key? key}) : super(key: key);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _movieNameController = TextEditingController();
  TextEditingController _directorNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File? _moviePoster;

  /// Get from gallery
  Future<File?> _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _moviePoster = File(pickedFile.path);
      });
      return _moviePoster;
    }
  }

  /// Get from Camera
  Future<File?> _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _moviePoster = File(pickedFile.path);
      });
      return _moviePoster;
    }
  }

  void _showBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
      ),
        builder: (builder) {
          return Container(
            height: 200,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    "Change Movie Poster",
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: kGreyColor,
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: InkWell(
                    onTap: () => _getFromGallery().whenComplete(() => Navigator.pop(context)),
                    child: Text(
                      "Choose from gallery",
                      style: GoogleFonts.lato(
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: InkWell(
                    onTap: () => _getFromCamera().whenComplete(() => Navigator.pop(context)),
                    child: Text(
                      "Click from camera",
                      style: GoogleFonts.lato(
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }

  showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Container(
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.exclamationCircle,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Sorry', style: GoogleFonts.lato(fontWeight: FontWeight.bold,),),
            ],
          ),
        ),
        content: Container(
          height: 50,
          child: Center(
            child: Text(
              'Please upload a movie poster!',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            height: App.height(context),
            width: App.width(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        backButton(context),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          "Add a movie",
                          style: GoogleFonts.ubuntu(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showBottomSheetMenu();
                      //_getFromCamera();
                    },
                    child: Container(
                      height: App.height(context)/3.7,
                      width: App.width(context) / 2.3,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10)),
                      child: _moviePoster == null
                          ? Center(
                              child: Icon(
                                FontAwesomeIcons.camera,
                                size: 36,
                                color: kBlackColor,
                              ),
                            )
                          : Image.file(
                              _moviePoster!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  formFieldWidget(
                    title: "Movie name",
                    controller: _movieNameController,
                    validator: (value) =>
                        (value!.isEmpty) ? "Movie name can't be empty" : null,
                    icon: FontAwesomeIcons.film,
                    onTap: () {},
                  ),
                  formFieldWidget(
                    title: "Director name",
                    controller: _directorNameController,
                    validator: (value) =>
                        (value!.isEmpty) ? "Director name can't be empty" : null,
                    icon: FontAwesomeIcons.user,
                    onTap: () {},
                  ),
                  formFieldWidget(
                    title: "Description (Optional)",
                    controller: _descriptionController,
                    icon: FontAwesomeIcons.fileAlt,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: submitButton(
                      context: context,
                      text: "Submit",
                      onTap: () {
                        if(_moviePoster == null) {
                          print("no image selected");
                          showErrorDialog();
                        }
                        if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print("success");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
