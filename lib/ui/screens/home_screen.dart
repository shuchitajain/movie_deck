import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/providers/data_provider.dart';
import 'package:movie_deck/providers/user_repository.dart';
import 'package:movie_deck/ui/screens/add_movie_screen.dart';
import 'package:movie_deck/ui/screens/onboarding_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Padding movieDetails(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        overflow: TextOverflow.ellipsis,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                  text: "User! ",
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
                          user.signOut().whenComplete(() =>
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: OnboardingScreen(),
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
                  textCapitalization: TextCapitalization.words,
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
                  onFieldSubmitted: (val) {
                    print("searching");
                    Provider.of<DataProvider>(context, listen: false).filterItems(val);
                  },
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
                    IconButton(
                      onPressed: () {
                        Provider.of<DataProvider>(context, listen: false).toggle();
                      },
                      icon: Icon(
                        FontAwesomeIcons.sortAlphaDown,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder<void>(
          future: Provider.of<DataProvider>(context, listen: false).fetchAndSetMovie(),
          builder: (context, snapshot) {
            print(snapshot.hasData);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<DataProvider>(
                child: Center(
                  child: Text("No movies yet"),
                ),
                builder: (ctx, movies, ch) {
                  if(movies.items.length == 0)
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Use the Add Button below to add movies to your watchlist :)",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  else
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: movies.items.length,
                        itemBuilder: (_, index) {
                          return Container(
                            height: App.height(context) / 3.7,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 18),
                            child: Stack(
                              children: [
                                Container(
                                  width: App.width(context) / 2.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: kGreyColor,
                                    image: DecorationImage(
                                      image: FileImage(
                                          File(movies.items[index].imageUrl)),
                                      fit: BoxFit.cover,
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 7),
                                          child: Text(
                                            movies.items[index].name,
                                            style: GoogleFonts.lato(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        movieDetails("Directed by:", movies.items[index].director),
                                        movieDetails("Created on:", DateFormat('dd-MM-yyyy').format(DateTime.parse(movies.items[index].createdOn)).toString()),
                                        movieDetails("Updated on:", DateFormat('dd-MM-yyyy').format(DateTime.parse(movies.items[index].updatedOn)).toString()),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.of(context).push(
                                                PageTransition(child: AddMovieScreen(movie: movies.items[index],), type: PageTransitionType.rightToLeft),
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Provider.of<DataProvider>(context, listen: false).deleteMovie(movies.items[index].name);
                                                setState(() {});
                                              },
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
                          );
                        });
                },
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
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
}
