import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Map<String, dynamic> m = {};
  bool status = false;
  dummy? d;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      var response = await Dio().get('https://dummyjson.com/products');
      print(response);
      m = response.data;
      d = dummy.fromJson(m);
      setState(() {
        status = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
      ),
      body: status
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: d!.products!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return Next(d!.products![index]);
                            },
                          ));
                        },
                        child: GridTile(
                          footer: Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(width: .1),
                              ),
                              child: Column(
                                children: [
                                  Text("${d!.products![index].title}",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true),
                                  Text("\$${d!.products![index].price}")
                                ],
                              )),
                          child: Container(
                              decoration: BoxDecoration(
                            border: Border.all(width: .1),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "${d!.products![index].thumbnail}")),
                          )),
                        ));
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10)),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class dummy {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  dummy({this.products, this.total, this.skip, this.limit});

  dummy.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Products(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = double.parse(json['rating'].toString());
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discountPercentage'] = this.discountPercentage;
    data['rating'] = this.rating;
    data['stock'] = this.stock;
    data['brand'] = this.brand;
    data['category'] = this.category;
    data['thumbnail'] = this.thumbnail;
    data['images'] = this.images;
    return data;
  }
}

class Next extends StatefulWidget {
  Products products;

  Next(this.products);

  @override
  State<Next> createState() => _NextState();
}

class _NextState extends State<Next> {
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: widget.products.images!.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return Image.network(
                        "${widget.products.images![index]}",
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.products.title}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("  \$${widget.products.price}"
                                " (${widget.products.discountPercentage} \%off)"),
                            Text(
                              "Rating :${widget.products.rating}",
                            )
                          ],
                        ),
                        Text(
                          "description : ${widget.products.description}",
                        ),
                        Text(
                          "stock : ${widget.products.stock}",
                        ),
                        Text(
                          "brand : ${widget.products.brand}",
                        ),
                        Text(
                          "category : ${widget.products.category}",
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
        onWillPop: goback);
  }

  Future<bool> goback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return FirstPage();
      },
    ));
    return Future.value();
  }
}
