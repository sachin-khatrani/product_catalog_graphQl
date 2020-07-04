import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttergraphql/models/Category.dart';
import 'package:fluttergraphql/widgets/MovieCard.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // GraphQL query to be fetched
  String getCategories = """
 query {
  Category {
    products(where: {isTrending: {_eq: true}}) {
      Images {
        url
      }
      price
      rating
      ratingCount
      name
    }
    Category_name
    Category_url
  }
}

""";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title,
          style: TextStyle(color: Colors.black54),
        )),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Center(
        // Running the Query in this widget
        child: Query(
          options: QueryOptions(
            documentNode: gql(getCategories),
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {

            if (result.hasException) {
              // error connecting to server
              print(result.exception.toString());
              return Text("Error Connecting to server!");
            }

            if (result.loading) {
              // getting data from the server
              return CircularProgressIndicator();
            }
            // Casting the Categories into CategoryList Object present in Category.dart
            CategoryList cl =
            CategoryList.fromResponse(result.data['Category']);


          return CustomScrollView(
            slivers: <Widget>[

              SliverFixedExtentList(
                itemExtent: 200,
                delegate: SliverChildListDelegate([
                  _listItem(cl),
                ]),
              )
            ],
          );
          },
        ),


      ),
    );
  }

  _listItem(CategoryList cl) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
                itemCount: cl.categories.length,
                itemBuilder: (context, index) {
                  // Category Object contains the name & url of category
                  final category = cl.categories[index];

                  // Showing custom item ui for a particular category
                  return MovieCard(path: category.imgURL,name: category.name,);
                }),
    );
  }


}


