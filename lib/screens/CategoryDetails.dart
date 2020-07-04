import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergraphql/models/Products.dart';
import 'package:fluttergraphql/widgets/ProductItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CategoryDetails extends StatefulWidget {

  final String categoryName;

  const CategoryDetails({Key key,this.categoryName}) : super(key: key);
  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  String query;
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    query = """ 
 query{
  Category(where: {Category_name: {_eq: "${widget.categoryName}"}}) {
    products {
      Images {
        url
      }
      rating
      ratingCount
      name
      price
      ID
    }
  }
}

  """;
    return Scaffold(
      appBar: AppBar(
       // centerTitle: true,
        backgroundColor: Colors.lightGreen[200],
        actions: <Widget>[
          Center(
            child: Image(
              image: AssetImage('assets/logo.png'),
              width: 40,
              height: 40,

            ),
          )


        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:8.0,left: 15,bottom: 8),
            child: Text('${widget.categoryName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),

          Query(
            options: QueryOptions(
              documentNode: gql(query)
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}){


              if (result.hasException) {
                // error connecting to server
                print(result.exception.toString());
                return Text("Error Connecting to server!");
              }

              if (result.loading) {
                // getting data from the server
                return CircularProgressIndicator();
              }

              ProductsList productList = ProductsList.fromResponse(result.data['Category'][0]['products']);

              if(productList.product.length == 0){
                return Container(
                  child: Center(child: Text("Item Not Found")),
                );
              }
                return Expanded(
                    child:SizedBox(
                      height: 100,
                      child: ListView.builder(
                          itemCount: productList.product.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {

                            return ProductItem(product: productList.product[index],size: size,categoryName: widget.categoryName,);
                          }),
                    )

                );


            }
          ),

        ],
      ),
    );
  }
}
