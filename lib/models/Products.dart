class Product {
  String ID;
  String name;
  String imgURL = "";
  double price;
  double rating;
  int ratingCount;
  Product(this.ID,this.name,this.imgURL,this.price,this.rating,this.ratingCount);

  factory Product.fromResults(Map<String, dynamic> result){
    return Product(result['ID'],result['name'],result['Images'][0]['url'], result['price']+.0,result['rating']+.0,result['ratingCount']);
  }
}

class ProductsList{
  List<Product> product;

  ProductsList(this.product);

  factory ProductsList.fromResponse(List<dynamic> list){
    List<Product> temp = List<Product>();
    list.forEach((item) {
      if(item['Images'].length == 0){
        temp.add(Product(item['ID'],item['name'],"", item['price']+.0,item['rating']+.0,item['ratingCount']));
      }else{
        temp.add(Product(item['ID'],item['name'],item['Images'][0]['url'], item['price'] + .0,item['rating']+.0,item['ratingCount']));
      }

    });
    return ProductsList(temp);
  }

  List<Product> getListProduct(){
    return product;
  }
}


class ProductFullDetails{

  String name;
  List<String> imageUrl;
  String currency;
  String description;
  double rating;
  String seller_ID;
  int ratingCount;
  double price;
  String id;
  Seller seller;
  List<Reviews> listReview;
  ProductFullDetails(this.name,this.imageUrl,this.currency,this.description,this.rating,this.seller_ID,this.ratingCount,this.price,this.id,this.seller,this.listReview);

  factory ProductFullDetails.fromResults(Map<String, dynamic> result){

    List<String> imageUrl = List<String>();

    result['Images'].forEach((val) {
      imageUrl.add(val['url']);
    });


    Seller temp = Seller.fromResult(result['Seller']);
    ReviewList listReviews = ReviewList.fromResponse(result['reviews']);

    return ProductFullDetails(result['name'],imageUrl,result['currency'],result['description'],result['rating']+.0,result['seller_ID'],result['ratingCount'], result['price'] + .0,result['ID'],temp,listReviews.getReview());
  }
}


class Seller{

  String name;
  int rating_count;
  String seller_profile;
  double seller_rating;
  String ID;

  Seller(this.name,this.rating_count,this.seller_profile,this.seller_rating,this.ID);

  factory Seller.fromResult(Map<String, dynamic> result){
    return Seller(result['Name'],result['rating_count'],result['seller_profile'],result['seller_rating'],result['ID']);
  }

}

class Reviews {
  String profile_url;
  double rating;
  String review;
  String timestamp;
  String name;

  Reviews(this.profile_url,this.rating,this.review,this.timestamp,this.name);
}

class ReviewList{
  List<Reviews> review;

  ReviewList(this.review);


  factory ReviewList.fromResponse(List<dynamic> list){
    List<Reviews> temp = List<Reviews>();
    list.forEach((item) {
      if(item['profile_url'] == null){
        temp.add(Reviews("",item['rating']+.0,item['review'],item['timestamp'],item['name']));
      }else{
        temp.add(Reviews(item['profile_url'],item['rating']+.0,item['review'],item['timestamp'],item['name']));
      }

    });
    return ReviewList(temp);
  }

  List<Reviews> getReview(){
    return review;
  }
}
