import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergraphql/screens/CategoryDetails.dart';


class MovieCard extends StatelessWidget {
  String path="";
  int ratings=2;
  String name;
  MovieCard({@required this.path,this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 3),
      width: 100,
      height: 150,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CategoryDetails(categoryName: name,)));
              print("You have tapped on ${name}");
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 12,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle
                ),
                child: Image(
                  image: NetworkImage(path ??
                      'https://graphql.org/users/logos/github.png'),
                  fit: BoxFit.fill,width: 100,height: 100,
                ),
              ),
            ),
          ),
          //title
          SizedBox(
            height: 5,
          ),
          Text('${name}',
              style: TextStyle(fontFamily: 'open_sans',color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal)
          ),

        ],
      ),
    );
  }

}