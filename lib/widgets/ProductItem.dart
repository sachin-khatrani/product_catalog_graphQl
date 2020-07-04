import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttergraphql/models/Products.dart';
import 'package:fluttergraphql/screens/ProductDetails.dart';
class ProductItem extends StatefulWidget {

  final Product product;
  final Size size;
  final String categoryName;
  ProductItem({this.product,this.size,this.categoryName});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {


  @override
  Widget build(BuildContext context) {
    print(widget.product.ID);
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(id: widget.product.ID,categoryName: widget.categoryName,)));
      },
      child: Card(

        child: Container(
          margin: EdgeInsets.only(left:14.0,right: 14,top: 8),
          width: widget.size.width,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border(
                left: const BorderSide(color: Colors.grey, width: 2),
                right: const BorderSide(color: Colors.grey, width: 2),
                bottom: const BorderSide(color: Colors.grey, width: 2),
                top: const BorderSide(color: Colors.grey, width: 2),
              )
          ),

          child: Row(
            children: <Widget>[
              Container(
                width: widget.size.width/4,
                height: 100,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border(
                      left: const BorderSide(color: Colors.black, width: 2),
                      right: const BorderSide(color: Colors.black, width: 2),
                      bottom: const BorderSide(color: Colors.black, width: 2),
                      top: const BorderSide(color: Colors.black, width: 2),
                    )
                ),

                child: Image(

                  image: widget.product.imgURL == "" ? NetworkImage('https://iaaglobal.org/storage/bulk_images/no-image.png'):NetworkImage('${widget.product.imgURL}'),
                ),
              ),

              Container(
                width: 3*widget.size.width/4 - 40,
                height: 100,
                padding: EdgeInsets.only(left: 5,top: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),

                color: Colors.white
                ),
                child: Column(
                  children: <Widget>[

                    Text(
                        '${widget.product.name}\n',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),

                    Row(
                      children: <Widget>[
                        Text(
                          'Rs.${widget.product.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),


                        Container(
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.only(left: 10),
                          width: 80,
                          height: 20,
                          color: Colors.black,
                          child: Text(
                            'FREE SHIPPING',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),


                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.lightGreenAccent,
                        ),
                        Text(
                            '${widget.product.rating}(${widget.product.ratingCount})'
                        ),
                      ],
                    )
                  ],
                ),
              ),


            ],

          )

        ),
      ),
    );
  }
}
