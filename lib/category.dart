import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:todolist/model.dart';

import 'NewsView.dart';



class Category extends StatefulWidget {
   String Query;
   Category({ required this.Query});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isLoading=true;
  List<NewsQueryModel> newsModelList =<NewsQueryModel>[];
  getNewsByQuery(String query) async {
    String url;
    if(query=="Top News"|| query=="India"){
      url="https://newsapi.org/v2/top-headlines?country=in&apiKey=d6135a7f522e4a3bb73dc7b295f98874";
    }
    else{
      url="https://newsapi.org/v2/everything?q=$query&from=2023-01-02&sortBy=publishedAt&apiKey=d6135a7f522e4a3bb73dc7b295f98874";
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
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
    getNewsByQuery(widget.Query);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("PK news"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body:SingleChildScrollView(
        child: Container(
            child:Column(
              children: [
                Container(
                  margin:EdgeInsets.symmetric(horizontal:17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height:12),
                      Container(
                        margin:EdgeInsets.fromLTRB(15, 25, 0, 0),
                        child: Text(widget.Query,style:TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30,
                        )),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                    itemBuilder:(context, index)  {
                      try{
                      return Container(
                          margin:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child:
                          InkWell(
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(newsModelList[index].newsUrl)));
                            },
                            child: Card(
                              shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation:1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius:BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].newsImg,fit:BoxFit.fitHeight,height:230,width:double.infinity)),
                                  Positioned(
                                    left:0,
                                    right:0,
                                    bottom:0,
                                    child: Container(
                                      decoration:BoxDecoration(
                                          borderRadius:BorderRadius.circular(15),
                                          gradient:LinearGradient(
                                            colors:[Colors.black12.withOpacity(0),
                                              Colors.black,],
                                            begin:Alignment.topCenter,
                                            end:Alignment.bottomCenter,
                                          )
                                      ),
                                      padding:EdgeInsets.fromLTRB(10,15,10,8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(newsModelList[index].newsHead,
                                              style:TextStyle(
                                                color:Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(newsModelList[index].newsDes.length >50? "${newsModelList[index].newsDes.substring(0,55)} ":newsModelList[index].newsDes ,
                                              style:TextStyle(
                                                color:Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                      }catch(e){print(e);return Container();}
                    }),
              ],
            )
        ),
      )
    );
  }
}
