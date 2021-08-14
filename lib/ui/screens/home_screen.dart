import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/repository/user_repository.dart';
import 'package:movie_deck/ui/screens/add_movie_screen.dart';
import 'package:movie_deck/ui/screens/onboarding_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentUser = "Shuchita";
  String movieName = "Star Wars";
  String posterUrl =
      "https://www.digitalartsonline.co.uk/cmsdata/slideshow/3662115/star-wars-last-jedi-poster.jpg";
  String directedBy = "NN Kumar";
  late DateTime createdOn = DateTime.now();
  late DateTime updatedOn = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print(App.height(context));
    print(App.width(context));
    return Scaffold(
      backgroundColor: kWhiteColor,
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (_, bool innerBoxIsScrolled) {
          return [
            SliverPadding(
              padding: EdgeInsets.only(top: 24),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome,',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: currentUser + "! ",
                                    style: GoogleFonts.openSans(
                                      fontSize: 17,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "😀",
                                      ),
                                    ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          var user =
                          Provider.of<AuthProvider>(context, listen: false);
                          user
                              .signOut()
                              .whenComplete(() =>
                              Navigator.pushReplacement(context,
                                  PageTransition(child: OnboardingScreen(),
                                      type: PageTransitionType.rightToLeft)));
                        },
                        child: Icon(
                          Icons.logout,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(20, 25, 20, 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    focusColor: Colors.grey[300],
                    hoverColor: Colors.grey[300],
                    contentPadding: EdgeInsets.only(top: 3),
                    hintText: "Search for any movie",
                    prefixIcon: Icon(
                      FontAwesomeIcons.search,
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'My Watchlist',
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        FontAwesomeIcons.sort,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) =>
              Container(
                height: App.height(context)/3.7,
                margin: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                child: Stack(
                  children: [
                    Container(
                      width: App.width(context) / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kGreyColor,
                        image: DecorationImage(
                          image: NetworkImage(
                            posterUrl,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      left: App.width(context) / 2.7,
                      top: 13,
                      bottom: 13,
                      child: Container(
                        width: App.width(context) / 2,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: Offset(0, 0.8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieName,
                              style: GoogleFonts.lato(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            movieDetails("Directed by:", directedBy),
                            movieDetails("Created on:",
                                DateFormat('dd-MM-yyyy').format(createdOn)),
                            movieDetails("Last Updated on:",
                                DateFormat('dd-MM-yyyy').format(updatedOn)),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.edit,
                                      size: 24,
                                    )),
                                SizedBox(
                                  width: 13,
                                ),
                                InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.delete,
                                      size: 24,
                                    ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () =>
                Navigator.of(context).push(
                  PageTransition(
                      child: AddMovieScreen(),
                      type: PageTransitionType.rightToLeft),
                ),
            elevation: 10,
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.add,
              color: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Padding movieDetails(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          text: title + "  ",
          style: GoogleFonts.lato(
            fontSize: 12,
            color: kGreyColor,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: data,
              style: GoogleFonts.lato(
                fontSize: 12.5,
                color: kBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
