import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    this.imageAspectRatio = 33 / 49,
    required this.product,
    Key? key,
  })   : assert(imageAspectRatio > 0),
        super(key: key);

  final double imageAspectRatio;
  final Product product;

  static const kTextBoxHeight = 65.0;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Map<Product, int> productsInCart = {}; // Menyimpan produk yang ditambahkan ke keranjang beserta jumlahnya

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    final imageWidget = Image.asset(
      widget.product.assetName,
      package: widget.product.assetPackage,
      fit: BoxFit.cover,
    );

    // Fungsi untuk menghitung total harga dari semua produk di keranjang
    double calculateTotalPrice() {
      double totalPrice = 0;
      productsInCart.forEach((product, quantity) {
        totalPrice += product.price * quantity;
      });
      return totalPrice;
    }

    // Fungsi untuk menampilkan snackbar dengan total harga dari semua produk di keranjang
    void showTotalPriceSnackBar() {
      String productName = widget.product.name; // Nama barang yang ditambahkan
      String totalPriceText = formatter.format(calculateTotalPrice()); // Total harga

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Text(
                  'Total harga di keranjang: $totalPriceText',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                ' | $productName', // Menampilkan nama barang
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // Set warna latar belakang snackbar menjadi merah
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: widget.imageAspectRatio,
          child: imageWidget,
        ),
        SizedBox(
          height: ProductCard.kTextBoxHeight *
              MediaQuery.of(context).textScaleFactor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.name,
                      style: theme.textTheme.labelLarge,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100, // Lebar untuk tombol tambah
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (productsInCart.containsKey(widget.product)) {
                        productsInCart[widget.product] = productsInCart[widget.product]! + 1; // Perbarui nilai menggunakan operator []
                      } else {
                        productsInCart[widget.product] = 1; // Jika produk belum ada di keranjang, tambahkan dengan jumlah 1
                      }
                    });
                    showTotalPriceSnackBar(); // Panggil fungsi untuk menampilkan snackbar dengan total harga
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.add), // Icon tambah
                      Text(productsInCart[widget.product]?.toString() ?? '0'), // Tampilkan jumlah produk yang diambil
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
