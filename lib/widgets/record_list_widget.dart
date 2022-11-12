import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:intl/intl.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/record_model.dart';
import 'package:tomato/router/locations.dart';
import 'package:tomato/utils/logger.dart';

class RecordListWidget extends StatelessWidget {
  final RecordModel record;
  double? imgSize;
  RecordListWidget(this.record, {Key? key, this.imgSize}) : super(key: key);

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
            ? '/$LOCATION_RECORD/${record.recordKey}'
            : '$currentPath/${record.recordKey}';

        logger.d('newPath - $newPath');
        context.beamToNamed(newPath);
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [SizedBox(
            height: imgSize,
            width: imgSize,
            child: ExtendedImage.network(
              record.imageDownloadUrls[0],
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
                      record.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      DateFormat('MM-dd kkmm').format(record.createdDate),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text('${record.price.toString()}원'),
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