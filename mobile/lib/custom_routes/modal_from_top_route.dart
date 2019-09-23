import 'package:flutter/widgets.dart';

const Color _kModalBarrierColor = Color(0x6604040F);
const Duration _kModalPopupTransitionDuration = Duration(milliseconds: 335);

Future<T> showModalTopRoute<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    ModalFromTopRoute<T>(
      builder: builder,
      barrierLabel: 'Dismiss',
    ),
  );
}

class ModalFromTopRoute<T> extends PopupRoute<T> {
  ModalFromTopRoute({
    this.builder,
    this.barrierLabel,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => _kModalBarrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => false;

  @override
  Duration get transitionDuration => _kModalPopupTransitionDuration;

  Animation<double> _animation;

  Tween<Offset> _offsetTween;

  @override
  Animation<double> createAnimation() {
    assert(_animation == null);
    _animation = CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.ease,
      //reverseCurve: Curves.ease.flipped,
    );
    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, -1),
      end: const Offset(0.0, 0.0),
    );
    return _animation;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation),
        child: child,
      ),
    );
  }
}
