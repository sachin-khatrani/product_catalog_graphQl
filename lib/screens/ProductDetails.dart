import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttergraphql/models/Products.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProductDetails extends StatefulWidget {

  final String id;
  final String categoryName;
  ProductDetails({this.id,this.categoryName});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  int perPage  = 2;
  int present = 0;
  Seller tempSeller;
  List<Reviews> tempRev;
  List<Reviews> items = List<Reviews>();
  int flag = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempSeller = Seller('Japantali Ayurvedic',1899,'https://res.cloudinary.com/djisilfwk/image/upload/v1593327381/Training/seller_profile/photo-1510227272981-87123e259b17_h1do60.jpg',4.7,'d2a067a4-6cd9-41f3-9441-3103d357f659');
    tempRev = List<Reviews>();
    
    tempRev.add(Reviews('https://res.cloudinary.com/djisilfwk/image/upload/v1593327380/Training/seller_profile/32_sczgxk.jpg',1,'No Use! Useless Product','2020-06-28T08:30:20.542178+00:00','Pandit Ramesh'));

    tempRev.add(Reviews('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT7nMcLjweymPromT7_MChCJn1kS0ZR5i4U5A&usqp=CAU',3,'This Product is not use for me!!','2020-06-28T08:30:20.542178+00:00','Jariwala Sweta'
        ''));
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    String query = """
  
  query{
  Category(where: {Category_name: {_eq: "${widget.categoryName}"}}) {
    Category_name
    products(where: {ID: {_eq: "${widget.id}"}}) {
      currency
      description
      categoryID
      name
      rating
      seller_ID
      ratingCount
      price
      Images {
        url
      }
      ID
      reviews {
        profile_url
        rating
        review
        timestamp
        name
      }
      Seller {
        Name
        rating_count
        seller_profile
        seller_rating
        ID
      }
    }
  }
}

  """;
    return Query(
        options: QueryOptions(
            documentNode: gql(query)
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}){


          print(result.data);
          if (result.hasException) {
            // error connecting to server
            print(result.exception.toString());
            return Text("Error Connecting to server!");
          }

          if (result.loading) {
            // getting data from the server
             return SpinKitFadingCircle(
              color: Colors.white,
              size: (size.width/16) * 0.75,
            );
          }

          ProductFullDetails productDetails = ProductFullDetails.fromResults(result.data['Category'][0]['products'][0]);

          if(flag == 0){
            if(productDetails.listReview.length != 0){

              if(productDetails.listReview.length == 1) {
                items.addAll(productDetails.listReview.getRange(present, present + perPage - 1));
                present = present + perPage - 1;
              }else{
                items.addAll(productDetails.listReview.getRange(present, present + perPage));
                present = present + perPage;
              }

            }else{
              items.addAll(tempRev.getRange(present,present+perPage));
              present = present + perPage;
            }
            flag = 1;
          }


          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 320,
                          width: size.width,
                          child: Carousel(
                            images: productDetails.imageUrl.length != 0 ? productDetails.imageUrl.length == 1 ? [ NetworkImage('${productDetails.imageUrl[0]}'), ] :

                            productDetails.imageUrl.length == 2 ? [
                              NetworkImage('${productDetails.imageUrl[0]}'),
                              NetworkImage('${productDetails.imageUrl[1]}'),
                            ]:
                            [
                              NetworkImage('${productDetails.imageUrl[0]}'),
                              NetworkImage('${productDetails.imageUrl[1]}'),
                              NetworkImage('${productDetails.imageUrl[2]}')
                            ] : [
                              NetworkImage('https://iaaglobal.org/storage/bulk_images/no-image.png'),
                            ],
                            dotSize: 4.0,
                            dotSpacing: 15.0,
                            dotColor: Colors.lightGreenAccent,
                            indicatorBgPadding: 5.0,
                            dotBgColor: Colors.purple.withOpacity(0.5),
                            borderRadius: true,
                            moveIndicatorFromBottom: 180.0,
                            noRadiusForIndicator: true,
                          ),
                        ),

                        Positioned(
                          right: 8,
                          top: 80,
                          child: Container(

                            child: Icon(
                              Icons.share,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 20,
                          child: Container(

                            child: Icon(
                                Icons.arrow_back
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 20,
                          child: Container(

                            child: Icon(
                                Icons.more_vert
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 50,
                          child: Container(

                            child: Icon(
                                Icons.favorite
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),

                        ),
                      ],

                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ExpandableText(
                      productDetails.description,
                      trimLines: 2,
                    ),
                  ),


                  Divider(indent:20,endIndent:20,color: Colors.grey,thickness: 2,),

                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 8.0),
                      width: size.width,
                      child: Text(
                          'Reviews: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productDetails.listReview.length == 0 ? 2 : productDetails.listReview.length,
                      itemBuilder: (context,index){

                        Reviews review;
                        if(productDetails.listReview.length == 0){
                          review = tempRev[index];
                        }else{
                          review = productDetails.listReview[index];
                        }

                       // DateTime date = review.timestamp.toDate()                                           ;


                        return (index == items.length ) ?
                        Container(
                          color: Colors.greenAccent,
                          child: FlatButton(
                            child: Text("Load ${productDetails.listReview.length - items.length} More"),
                            onPressed: () {

                              if(productDetails.listReview.length != 0){
                                setState(() {
                                  if((present + perPage)> productDetails.listReview.length) {
                                    items.addAll(
                                        productDetails.listReview.getRange(present, productDetails.listReview.length));
                                  } else {
                                    items.addAll(
                                        productDetails.listReview.getRange(present, present + perPage));
                                  }
                                  present = present + perPage;
                                });
                              }else{
                                setState(() {
                                  if((present + perPage)> tempRev.length) {
                                    items.addAll(
                                        tempRev.getRange(present, tempRev.length));
                                  } else {
                                    items.addAll(
                                        tempRev.getRange(present, present + perPage));
                                  }
                                  present = present + perPage;
                                });
                              }

                            },
                          ),
                        )
                            :
                        Container(
                          child: Card(
                            margin: EdgeInsets.only(left:8.0,top: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 35.0,
                                    height: 35.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(review.profile_url)
                                        )
                                    )),

                                Column(
                                  children: <Widget>[
//
                                      Row(
                                      children: <Widget>[

                                        getIcon((review.rating).round()),


                                        //SizedBox(width: 100,),
//                                          Text(
//                                            '${review.name}'
//                                          )
                                      ],
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 6),
                                      child: Text(
                                        'From ${review.name}'
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 6),
                                      child: Text(
                                        review.review.length < 43 ? '${review.review}':'${review.review.substring(0,43)}...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Divider(indent:20,endIndent:20,color: Colors.grey,thickness: 2,),

                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    width: size.width,
                    child: Text(
                      'About the Seller: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black
                      ),
                    ),
                  ),

              Container(
                child: Card(
                  margin: EdgeInsets.only(left:8.0,top: 8.0,bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(

                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: productDetails.seller == null || productDetails.seller.seller_profile == "" ? NetworkImage(tempSeller.seller_profile):new NetworkImage(productDetails.seller.seller_profile)
                              )
                          )),

                      Column(

                        children: <Widget>[
//                                   getIcon((review.rating).round()),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            child: Text(
                                productDetails.seller == null || productDetails.seller.seller_profile == "" ? '${tempSeller.name}':'${productDetails.seller.name}'
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 5,),

                              getIcon((productDetails.seller.seller_rating).round()),

                              Text(
                                  productDetails.seller == null || productDetails.seller.seller_profile == "" ? '(${tempSeller.rating_count})': '(${productDetails.seller.rating_count})'
                              )
                              //SizedBox(width: 100,),
//                                          Text(
//                                            '${review.name}'
//                                          )
                            ],
                          ),

                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[

                                SizedBox(width: 5,),
                                Container(
                                  width: 100,
                                  height: 25,
                                  child: RaisedButton(

                                    child: Text('Visit Store'),

                                    onPressed: (){

                                    },
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Container(
                                  width: 100,
                                  height: 25,
                                  child: RaisedButton(
                                    child: Text('Message'),
                                    onPressed: (){

                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
                ],
              ),


            ),


          );


        }
    );
  }

  Widget getIcon(count){

    switch(count){

      case 5:
        return Row(
          children: <Widget>[

            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),

          ],
        );
        break;
      case 4:
        return Row(
          children: <Widget>[

            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.grey,),

          ],
        );
        break;
      case 3:
        return Row(
          children: <Widget>[

            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),

          ],
        );
        break;
      case 2:
        return Row(
          children: <Widget>[

            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),

          ],
        );
        break;
      case 1:
        return Row(
          children: <Widget>[

            Icon(Icons.star,color: Colors.yellow,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),
            Icon(Icons.star,color: Colors.grey,),

          ],
        );
        break;

      }
  }
}


class ExpandableText extends StatefulWidget {
  const ExpandableText(
      this.text, {
        Key key,
        this.trimLines = 2,
      })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );


    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
              color: widgetColor,
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}