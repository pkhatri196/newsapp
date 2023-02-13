import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:todolist/NewsView.dart';
import 'package:todolist/model.dart';
import 'package:http/http.dart';

import 'category.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = ["Top News", "India", "World", "Finance", "Health"];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2023-01-02&sortBy=publishedAt&apiKey=d6135a7f522e4a3bb73dc7b295f98874";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        i++;
        try {
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
          //newsModelList.sublist(0,5); to show only 5 latest news

        } catch (e) {
          print(e);
        }
        ;
      }
    });
  }

  getNewsofIndia() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=d6135a7f522e4a3bb73dc7b295f98874";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("india");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    // var newsModelList;
    return Scaffold(
        appBar: AppBar(
          title: Text("PK news"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //Search container
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Category(Query: searchController.text)));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(2, 0, 5, 0),
                        child: Icon(
                          Icons.search,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            if(value==""){
                              print("Black Search");
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: navBarItem[index])));
                          },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: isLoading
                      ? Container(
                          height: 200,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.purple)))
                      : CarouselSlider(
                          items: newsModelListCarousel.map((instance) {
                            return Builder(builder: (BuildContext context) {
                              try {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: InkWell(
                                    onTap:(){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(instance.newsUrl)));
                                  },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                  instance.newsImg,
                                                  fit: BoxFit.fitHeight,
                                                  width: double.infinity,
                                                  height: 200),
                                            ),
                                            Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black12
                                                                .withOpacity(0),
                                                            Colors.black,
                                                          ],
                                                          begin:
                                                              Alignment.topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        )),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        child: Text(
                                                            instance.newsHead,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    )))
                                          ],
                                        )),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                                return Container();
                              }
                            });
                          }).toList(),
                          options: CarouselOptions(
                            height: 230,
                            autoPlay: true,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                          ),
                        )),
              Container(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("LATEST NEWS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )),
                      ],
                    ),
                  ),
                  isLoading
                      ? Container(
                          height: MediaQuery.of(context).size.height - 400,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.purple,
                          )))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsModelList.length,
                          itemBuilder: (context, index) {
                            try{
                            return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: InkWell(
                                  onTap:() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(newsModelList[index].newsUrl)));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 1.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                                newsModelList[index].newsImg,
                                                fit: BoxFit.fitHeight,
                                                height: 230,
                                                width: double.infinity)),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    newsModelList[index].newsHead,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    )),
                                                Text(
                                                    newsModelList[index]
                                                                .newsDes
                                                                .length >
                                                            50
                                                        ? "${newsModelList[index].newsDes.substring(0, 55)} "
                                                        : newsModelList[index]
                                                            .newsDes,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                            }catch(e){print(e); return Container(); }
                          }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Category(Query: "Technology")));
                          },
                          child: Text("Show More"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple, // background
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
        ));
  }

  final List items = [
    Colors.black,
    Colors.blue,
    Colors.yellow,
    Colors.lightGreen,
    Colors.orange
  ];
}
