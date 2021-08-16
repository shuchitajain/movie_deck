import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/providers/data_provider.dart';
import 'package:movie_deck/providers/auth_provider.dart';
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
  TextEditingController _searchController = TextEditingController();
  int sortVal = 2;
  String userName = "User";

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

  void getUserName() async{
    String? name = await App.fss.read(key: "name");
    if(name != null){
      setState(() {
        userName = name;
      });
    }
    print(userName);
  }

  @override
  void initState() {
    super.initState();
    getUserName();
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
                                  text: "$userName! ",
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
                          showDialog(context: context, builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.only(top: 30, left: 20, right: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            content: Text("Are you sure you want to log out?", style: TextStyle(color: kBlackColor, fontSize: 18,),),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: kBlackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  var user =
                                  Provider.of<AuthProvider>(context, listen: false);
                                  user.signOut().whenComplete(() =>
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: OnboardingScreen(),
                                              type: PageTransitionType.rightToLeft)));
                                },
                              ),
                            ],
                          ));
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
                  controller: _searchController,
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
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 18,
                          color: kGreyColor,
                        ),
                        onTap: () {
                          _searchController.clear();
                          Provider.of<DataProvider>(context, listen: false).filterItems("");
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onChanged: (val) {
                    print("searching");
                    if(val.length >= 3)
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
                    // IconButton(
                    //   onPressed: () {
                    //     Provider.of<DataProvider>(context, listen: false)
                    //         .toggle();
                    //   },
                    //   icon: Icon(
                    //     Provider.of<DataProvider>(context, listen: false)
                    //             .isSorted
                    //         ? FontAwesomeIcons.sortAlphaUp
                    //         : FontAwesomeIcons.sortAlphaDown,
                    //     size: 18,
                    //   ),
                    // )
                    Container(
                      height: 50,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          icon: Visibility(
                              visible: false,
                              child: Icon(Icons.arrow_downward)),
                          style: TextStyle(fontSize: 14, color: kBlackColor),
                          value: sortVal,
                          onChanged: (val) {
                            setState(() {
                              sortVal = val!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text("Sort A-Z"),
                              value: 0,
                              onTap: () {
                                Provider.of<DataProvider>(context,
                                        listen: false)
                                    .toggle(0);
                              },
                            ),
                            DropdownMenuItem(
                              child: Text("Sort Z-A"),
                              value: 1,
                              onTap: () {
                                Provider.of<DataProvider>(context,
                                        listen: false)
                                    .toggle(1);
                              },
                            ),
                            DropdownMenuItem(
                              child: Text("Last Added"),
                              value: 2,
                              onTap: () {
                                Provider.of<DataProvider>(context,
                                        listen: false)
                                    .toggle(2);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder<void>(
          future: Provider.of<DataProvider>(context, listen: false)
              .fetchAndSetMovie(),
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
                  if (movies.items.length == 0)
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
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Text(
                                            movies.items[index].name,
                                            maxLines: 2,
                                            style: GoogleFonts.lato(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        movieDetails("Directed by:",
                                            movies.items[index].director),
                                        movieDetails(
                                            "Added on:",
                                            DateFormat('dd-MM-yyyy')
                                                .format(DateTime.parse(movies
                                                    .items[index].createdOn))
                                                .toString()),
                                        //movieDetails("Updated on:", DateFormat('dd-MM-yyyy').format(DateTime.parse(movies.items[index].updatedOn)).toString()),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                PageTransition(
                                                    child: AddMovieScreen(
                                                      movie:
                                                          movies.items[index],
                                                    ),
                                                    type: PageTransitionType
                                                        .rightToLeft),
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
                                                Provider.of<DataProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteMovie(movies
                                                        .items[index].name);
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
            onPressed: () {
              _searchController.clear();
              Navigator.of(context).push(
                PageTransition(
                  child: AddMovieScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
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

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
