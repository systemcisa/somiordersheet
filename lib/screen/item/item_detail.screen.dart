import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/item_model.dart';
import 'package:tomato/repo/item_service.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;

  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  Size? _size;
  num? _statusBarHeight;
  bool isAppbarcollapsed = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null || _statusBarHeight == null) return;
      if (isAppbarcollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarcollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarcollapsed = true;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            return LayoutBuilder(
              builder: (context, constraints) {
                _size = MediaQuery.of(context).size;
                _statusBarHeight = MediaQuery.of(context).padding.top;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverAppBar(
                            expandedHeight: _size!.width,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              title: SmoothPageIndicator(
                                  controller: _pageController, // PageController
                                  count: itemModel.imageDownloadUrls.length,
                                  effect: WormEffect(
                                      activeDotColor:
                                          Theme.of(context).primaryColor,
                                      dotColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      radius: 4,
                                      dotHeight: 8,
                                      dotWidth: 8), // yo// ur preferred effect
                                  onDotClicked: (index) {}),
                              centerTitle: true,
                              background: PageView.builder(
                                controller: _pageController,
                                allowImplicitScrolling: true,
                                itemBuilder: (context, index) {
                                  return ExtendedImage.network(
                                    itemModel.imageDownloadUrls[index],
                                    fit: BoxFit.cover,
                                    scale: 0.1,
                                  );
                                },
                                itemCount: itemModel.imageDownloadUrls.length,
                              ),
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Row(
                              children: [
                                ExtendedImage.network(
                                  'https://picsum.photos/50',
                                  fit: BoxFit.cover,
                                  width: _size!.width / 10,
                                  height: _size!.width / 10,
                                  shape: BoxShape.circle,
                                ),
                                Column(
                                  children: [
                                    Text('무무'),
                                    Text('배곧동'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [],
                                        ),
                                        ImageIcon(
                                          ExtendedAssetImageProvider('assets/imgs/happiness.png')),
                                      ],
                                    ),
                                    Text(
                                      '매너온도',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ]))
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Container(
                        height: kToolbarHeight + _statusBarHeight!,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
                              Colors.transparent,
                            ])),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: isAppbarcollapsed
                              ? Colors.white
                              : Colors.transparent,
                          foregroundColor:
                              isAppbarcollapsed ? Colors.black87 : Colors.white,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        });
  }
}
