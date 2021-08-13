import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_deck/constants.dart';
import 'package:movie_deck/ui/screens/add_movie_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../config.dart';

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
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: currentUser + " ",
                                    style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "😀",
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
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
                height: 65,
                margin: EdgeInsets.fromLTRB(20, 25, 20, 30),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    focusColor: Colors.grey[300],
                    hoverColor: Colors.grey[300],
                    contentPadding: EdgeInsets.all(20),
                    hintText: "Search  for any movie",
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
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 6,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        FontAwesomeIcons.sort,
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
          itemBuilder: (_, index) => Container(
            height: 270,
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
                  child: Container(
                    height: 230,
                    width: App.width(context) / 1.9,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 6,
                          offset: Offset(0, 0.76),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieName,
                          style: GoogleFonts.lato(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        movieDetails("Directed by:", directedBy),
                        movieDetails("Created on:", createdOn.toString()),
                        movieDetails("Last Updated on", updatedOn.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){}, icon: Icon(Icons.edit, size: 20,)),
                            IconButton(onPressed: (){}, icon: Icon(Icons.delete, size: 20,)),
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
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              PageTransition(
                  child: AddMovieScreen(),
                  type: PageTransitionType.rightToLeft),
            ),
            elevation: 10,
            backgroundColor: kPrimaryColor,
            child: Icon(Icons.add),
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
            fontSize: 14,
            color: kGreyColor,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: data,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
