import 'package:flutter/material.dart';
import '../model/product.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    Key? key,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _productAddedToCart = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
      velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity,
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        layerTop,
        0.0,
        layerTop - layerSize.height,
      ),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller);

    return Stack(
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _productAddedToCart
                ? FloatingActionButton(
                    onPressed: _checkout,
                    child: Icon(Icons.shopping_cart),
                    backgroundColor: Colors.green,
                  )
                : ElevatedButton(
                    onPressed: _checkout,
                    child: Text('Checkout'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleBackdropLayerVisibility,
        ),
        title: _BackdropTitle(
          listenable: _controller,
          onPress: _toggleBackdropLayerVisibility,
          frontTitle: widget.frontTitle,
          backTitle: widget.backTitle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'Cari ${widget.currentCategory.toString().toLowerCase()} dengan nama',
            ),
            onPressed: _toggleBackdropLayerVisibility,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Profil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage(),
                      ),
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: LayoutBuilder(builder: _buildStack),
    );
  }

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Terima kasih telah berkunjung!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perpindahan ke halaman login saat logout
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _FrontLayer extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _FrontLayer({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 16.0,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
        ),
        child: child,
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle({
    Key? key,
    required AnimationController listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.red),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 72.0,
            child: IconButton(
              padding: const EdgeInsets.only(right: 8.0),
              onPressed: onPress,
              icon: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: animation.value,
                    child: const ImageIcon(
                      AssetImage('assets/slanted_menu.png'),
                    ),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(animation).value,
                    child: const ImageIcon(
                      AssetImage('assets/diamond.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.5, 0.0),
                  ).animate(animation).value,
                  child: backTitle,
                ),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: const Offset(-0.25, 0.0),
                    end: Offset.zero,
                  ).animate(animation).value,
                  child: frontTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Image.asset(
              'assets/gambar2.png',
              width: 400,
              height: 400,
            ),
            Text(
              'Claudia Berlian Harli',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              '221511008',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
