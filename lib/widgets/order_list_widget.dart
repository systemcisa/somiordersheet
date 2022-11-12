import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:intl/intl.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/order_model.dart';
import 'package:tomato/router/locations.dart';
import 'package:tomato/utils/logger.dart';

class OrderListWidget extends StatelessWidget {
  final OrderModel order;
  double? imgSize;
  OrderListWidget(this.order, {Key? key, this.imgSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imgSize == null) {
      Size size = MediaQuery.of(context).size;
      imgSize = size.width / 6;
    }

    return InkWell(
      onTap: () {
        BeamState beamState = Beamer.of(context).currentConfiguration!;
        String currentPath = beamState.uri.toString();
        String newPath = (currentPath == '/')
            ? '/$LOCATION_ORDER/${order.orderKey}'
            : '$currentPath/${order.orderKey}';

        logger.d('newPath - $newPath');
        context.beamToNamed(newPath);
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [
            SizedBox(
                height: imgSize,
                width: imgSize,
                child: ExtendedImage.network(
                  order.imageDownloadUrls[0],
                  fit: BoxFit.cover,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                )),
            SizedBox(
              width: common_sm_padding,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      order.detail,
                      maxLines:1,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text('${order.price.toString()},000원',style: Theme.of(context).textTheme.subtitle2),
                    Text(
                      DateFormat('MM-dd kkmm').format(order.createdDate),

                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}