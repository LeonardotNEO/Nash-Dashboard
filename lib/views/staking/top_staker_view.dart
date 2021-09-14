import 'package:flutter/material.dart';
import 'package:nash_dashboard/main.dart';
import 'package:nash_dashboard/utils/calculate_numbers.dart';
import 'package:nash_dashboard/widgets/box_withlogo_widget.dart';

class TopStakerView extends StatefulWidget {
  @override
  _TopStakerViewState createState() => _TopStakerViewState();
}

class _TopStakerViewState extends State<TopStakerView> {
  int stakersPerPage = 10;
  int _page = 1;
  int _pageLimit = (Main.topStakers["stakers"] as List).length;
  List stakersToShow = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stakersToShow = (Main.topStakers["stakers"] as List).sublist(0, 10);
  }

  void _updatePage(int increment) {
    setState(() {
      if (_page + increment <= _pageLimit && _page + increment > 0) {
        _page += increment;
        stakersToShow = (Main.topStakers["stakers"] as List)
            .sublist((_page - 1) * stakersPerPage, _page * stakersPerPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int stakerRank = _page * stakersPerPage - stakersPerPage;

    return Container(
      child: Column(children: [
        _changePageRow(),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  Addresse",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "NEX",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        ...stakersToShow.map((staker) {
          stakerRank++;
          return _transactionRow(staker, stakerRank);
        }).toList(),
      ]),
    );
  }

  Widget _changePageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => _updatePage(-1),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                )),
            IconButton(
                onPressed: () => _updatePage(-10),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                )),
            IconButton(
                onPressed: () => _updatePage(-100),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                )),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 10),
          decoration: BoxDecoration(
              color: Main.color[900], borderRadius: BorderRadius.circular(5)),
          child: Text(
            _page.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () => _updatePage(100),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 25,
                )),
            IconButton(
                onPressed: () => _updatePage(10),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
            IconButton(
                onPressed: () => _updatePage(1),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )),
          ],
        )
      ],
    );
  }

  Widget _transactionRow(dynamic staker, int rank) {
    if (rank == 1)
      return _transactionTopPosition(
          Color.fromRGBO(255, 215, 0, 1), rank, staker);
    if (rank == 2)
      return _transactionTopPosition(
          Color.fromRGBO(192, 192, 192, 1), rank, staker);
    if (rank == 3)
      return _transactionTopPosition(
          Color.fromRGBO(205, 127, 50, 1), rank, staker);

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  rank.toString() + ". ",
                  style: TextStyle(fontSize: 12),
                ),
                Text(staker["addresse"], style: TextStyle(fontSize: 10)),
              ],
            ),
            Text(
                CalculateNumbers.doubleInRightFormat(
                    staker["amount"].toString()),
                style: TextStyle(fontSize: 12))
          ],
        ),
      ),
    );
  }

  Widget _transactionTopPosition(Color color, int rank, dynamic staker) {
    return BoxWithLogoWidget(
      rank.toString(),
      Column(
        children: [
          Text(staker["addresse"], style: TextStyle(fontSize: 14)),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              CalculateNumbers.doubleInRightFormat(staker["amount"].toString()),
            ),
          )
        ],
      ),
      Icons.emoji_events,
      color: color,
    );
  }
}
