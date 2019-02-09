import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/suits.dart';
import 'package:stacked/util.dart';

const CARD_WIDTH = 0.36;
const CARD_HEIGHT = 0.54;
const CARD_STACK_LENGTH = 52;

const RED_CARD = Color(0xFFFF5555);
const BASE_ASSET_PATH = 'assets';

void main() => runApp(StackedApp());

class StackedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Color(0xFF202124), // Same color as Android Messages
      ),
      home: StackedHome(title: 'Stacked'),
    );
  }
}

class StackedHome extends StatefulWidget {
  StackedHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  StackedHomeState createState() {
    return new StackedHomeState();
  }
}

class StackedHomeState extends State<StackedHome> {
  List<Widget> cards = [];

  PageController controller = PageController();
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();

    final suits = [Suits.hearts, Suits.spades, Suits.diamonds, Suits.clubs];

    var suitsIndex = 0;

    var rankIndex = 6;

    for (var i = 0; i < CARD_STACK_LENGTH; i++) {
      cards.add(PlayingCard(suit: suits[suitsIndex], rank: rankIndex));

      if (suitsIndex != suits.length - 1) {
        suitsIndex++;
      } else {
        suitsIndex = 0;
      }

      var rem = (rankIndex + 3) % 13;

      if (rem == 0) {
        rankIndex = 13;
      } else {
        rankIndex = rem;
      }
    }

    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            backgroundColor:
            Theme.of(context).canvasColor, // Use same color as background
            elevation: 0,
            centerTitle: true,
            title: Text(widget.title),
          ),
        ),
        PageView.builder(
          controller: controller,
          physics: BouncingScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (context, position) {
            if (position == currentPageValue.floor()) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(currentPageValue - position),
                child: cards[position],
              );
            } else if (position == currentPageValue.floor() + 1) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(currentPageValue - position),
                child: cards[position],
              );
            } else {
              return cards[position];
            }
          },
        ),
      ],
    );
  }
}

class PlayingCard extends StatefulWidget {
  final Suit suit;
  final int rank;

  PlayingCard({
    Key key,
    @required this.suit,
    @required this.rank,
  }) : super(key: key);

  @override
  PlayingCardState createState() {
    return new PlayingCardState();
  }
}

class PlayingCardState extends State<PlayingCard> {
  Widget cardArt;
  String name;

  @override
  void initState() {
    super.initState();

    final rankName = getRankName(widget.rank);
    final assetName = '$BASE_ASSET_PATH/${rankName}_of_${widget.suit.name}.svg';

    name =
    '${rankName[0].toUpperCase()}${rankName.substring(1)} of ${widget.suit.name}';

    Color color;

    if (!isGraphic(widget.rank)) {
      color = widget.suit.isRed ? RED_CARD : Colors.black;
    }

    cardArt = SvgPicture.asset(assetName, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: AspectRatio(
            aspectRatio: CARD_WIDTH / CARD_HEIGHT,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: cardArt,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
        Text(name, style: Theme.of(context).textTheme.title),
      ],
    );
  }
}