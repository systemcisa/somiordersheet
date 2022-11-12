import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tomato/constants/common_size.dart';
import 'package:tomato/data/record_model.dart';
import 'package:tomato/repo/record_service.dart';
import 'package:tomato/widgets/record_list_widget.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery
            .of(context)
            .size;
        final imgSize = size.width / 4;
        return FutureBuilder<List<RecordModel>>(
            future: RecordService().getRecords(),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
              child: _listView2(imgSize, snapshot.data!));
                  // child: (snapshot.hasData && snapshot.data!.isNotEmpty)
                  //     ? _listView(imgSize, snapshot.data!)
                  //     : _shimmerListView(imgSize));
            });
      },
    );
  }

  ListView _listView2(double imgSize, List<RecordModel> records) {
    return ListView.separated(
        padding: EdgeInsets.all(common_padding),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: common_padding+1,
            thickness: 1,
            color: Colors.grey[300],
            indent: common_padding,
            endIndent: common_padding,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          RecordModel record = records[index];
          return RecordListWidget(record, imgSize: imgSize);
        }, itemCount: records.length,
      );
  }
  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.all(common_padding),
        separatorBuilder: (context, index) {
          return Divider(
            height: common_padding * 2 + 1,
            thickness: 1,
            color: Colors.grey[200],
            indent: common_sm_padding,
            endIndent: common_sm_padding,
          );
        },
        itemBuilder: (context, index) {
          return SizedBox(
            height: imgSize,
            child: Row(
              children: [
                Container(
                    height: imgSize,
                    width: imgSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    )),
                SizedBox(
                  width: common_sm_padding,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 12,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 14,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            )),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 14,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                )),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}