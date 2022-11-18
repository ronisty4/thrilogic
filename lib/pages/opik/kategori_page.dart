// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:thrilogic_shop/API/json_future/json_future.dart';
import 'package:thrilogic_shop/API/object_class/category.dart';
import 'package:thrilogic_shop/API/object_class/review.dart';
import 'package:thrilogic_shop/API/object_class/wishlist.dart';
import 'package:thrilogic_shop/pages/delvy/produk_page.dart';
import 'package:thrilogic_shop/pages/delvy/tampilan_review_page.dart';
import 'package:thrilogic_shop/services/icon_assets.dart';
import 'package:thrilogic_shop/services/styles.dart';

class KategoriPage extends StatelessWidget {
  KategoriPage({
    super.key,
    required this.id,
  });

  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna().primer,
      body: FutureBuilder<GetKategoriById>(
        future: JsonFuture().getKategoriById(id: id),
        builder: (context, snapshotGetKategori) {
          if (snapshotGetKategori.hasData &&
              snapshotGetKategori.connectionState != ConnectionState.waiting &&
              snapshotGetKategori.data != null) {
            if (snapshotGetKategori.data!.data != null) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          snapshotGetKategori.data!.data!.name!.toUpperCase(),
                          style: Font.style(fontSize: 20),
                        ),
                      ),
                    ),
                    snapshotGetKategori.data!.data!.products!.isNotEmpty
                        ? GridKategori(
                            getkategoribyid: snapshotGetKategori.data!,
                          )
                        : Center(
                            child: Text(
                              'NO DATA',
                              style: Font.style(),
                            ),
                          ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  "NO DATA",
                  style: Font.style(),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class GridKategori extends StatelessWidget {
  GridKategori({
    super.key,
    required this.getkategoribyid,
  });
  GetKategoriById getkategoribyid;

  @override
  Widget build(BuildContext context) {
    List<ProductsGetKategoriById> kategoriProducts =
        getkategoribyid.data!.products ?? [];
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: kategoriProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10 / 16,
          crossAxisSpacing: 10,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return CardKategoriById(
            kategoriProducts: kategoriProducts,
            index: index,
          );
        });
  }
}

class CardKategoriById extends StatefulWidget {
  CardKategoriById({
    super.key,
    required this.kategoriProducts,
    required this.index,
  });
  List<ProductsGetKategoriById> kategoriProducts;
  int index;

  @override
  State<CardKategoriById> createState() => _CardKategoriByIdState();
}

class _CardKategoriByIdState extends State<CardKategoriById> {
  double star = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProdukPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Warna().shadow,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Warna().primerCard,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.kategoriProducts[widget.index].image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            widget.kategoriProducts[widget.index].name!,
                            style: Font.style(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 5),
                        FutureBuilder<GetWishlist>(
                          future: JsonFuture().getWishlist(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                snapshot.data != null) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data!.data != null &&
                                      snapshot.data!.data!
                                          .map((e) => e.product!.id)
                                          .contains(widget
                                              .kategoriProducts[widget.index]
                                              .id)) {
                                    await JsonFuture().deleteWishlist(
                                        id: snapshot.data!.data!.first.id
                                            .toString());
                                  } else {
                                    await JsonFuture().createWishlist(
                                        productId: widget
                                            .kategoriProducts[widget.index].id!
                                            .toString());
                                  }
                                  setState(() {});
                                },
                                child: snapshot.data!.data != null
                                    ? Assets.navbarIcon(
                                        snapshot.data!.data!
                                                .map(
                                                  (e) => e.product!.id,
                                                )
                                                .contains(
                                                  widget
                                                      .kategoriProducts[
                                                          widget.index]
                                                      .id,
                                                )
                                            ? 'hearton'
                                            : 'heart',
                                      )
                                    : Text(
                                        'err',
                                        style:
                                            Font.style(color: Warna().shadow),
                                      ),
                              );
                            } else {
                              return Center(
                                child: Container(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    FutureBuilder(
                      future: JsonFuture().getReview(
                          productId: widget.kategoriProducts[widget.index].id!
                              .toString()),
                      builder: (context, snapshotGetreview) {
                        if (snapshotGetreview.hasData &&
                            snapshotGetreview.connectionState ==
                                ConnectionState.done &&
                            snapshotGetreview.data != null) {
                          List<DataGetReview> datareview =
                              snapshotGetreview.data!.data ?? [];
                          datareview.map((e) {
                            num baps = e.star ?? 0;
                            star = star + baps;
                          }).toList();
                          star = star / datareview.length;
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TampilanReviewPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: star.isNaN ? 0 : star,
                                  itemSize: 15,
                                  itemBuilder: (context, index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                ),
                                AutoSizeText(
                                  datareview.isNotEmpty
                                      ? "${datareview.length} terjual"
                                      : '',
                                  style: Font.style(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Text(
                            'err',
                            style: Font.style(color: Warna().shadow),
                          );
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          rupiah(widget.kategoriProducts[widget.index].harga!),
                          style: Font.style(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        FutureBuilder(
                          future: JsonFuture().getKeranjang(),
                          builder: (context, snapshotGetKeranjang) {
                            if (snapshotGetKeranjang.hasData &&
                                snapshotGetKeranjang.connectionState !=
                                    ConnectionState.waiting &&
                                snapshotGetKeranjang.connectionState !=
                                    ConnectionState.none &&
                                snapshotGetKeranjang.data != null) {
                              return snapshotGetKeranjang.data!.data != null
                                  ? snapshotGetKeranjang.data!.data!
                                              .map((e) => e.productId)
                                              .contains(widget
                                                  .kategoriProducts[
                                                      widget.index]
                                                  .id) !=
                                          true
                                      ? GestureDetector(
                                          onTap: () async {
                                            await JsonFuture().createKeranjang(
                                                productId: widget
                                                    .kategoriProducts[
                                                        widget.index]
                                                    .id
                                                    .toString(),
                                                qty: "1");
                                            setState(() {});
                                          },
                                          child: Assets.lainnyaIcon('tambah'),
                                        )
                                      : Icon(
                                          Icons.done_outline_rounded,
                                          color: Warna().font,
                                        )
                                  : Text(
                                      "err",
                                      style: Font.style(color: Warna().shadow),
                                    );
                            } else {
                              return Container(
                                width: 10,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
