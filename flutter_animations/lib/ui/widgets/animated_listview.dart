import 'package:flutter/material.dart';
import 'package:flutter_animations/ui/widgets/list_data.dart';

class AnimatedListView extends StatelessWidget {

  AnimatedListView({@required this.animation, Key key}):super(key:key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListData(
          title: 'Estudar Flutter 4',
          subtitle: 'Com o curso da Udemy',
          image: AssetImage(
            'images/perfil.jpg',
          ),
          bottomMargin: animation.value*3,
        ),
        ListData(
          title: 'Estudar Flutter 3',
          subtitle: 'Com o curso da Udemy',
          image: AssetImage(
            'images/perfil.jpg',
          ),
          bottomMargin: animation.value*2,
        ),
        ListData(
          title: 'Estudar Flutter 2',
          subtitle: 'Com o curso da Udemy',
          image: AssetImage(
            'images/perfil.jpg',
          ),
          bottomMargin: animation.value*1,
        ),
        ListData(
          title: 'Estudar Flutter 1',
          subtitle: 'Com o curso da Udemy',
          image: AssetImage(
            'images/perfil.jpg',
          ),
          bottomMargin: animation.value*0,
        ),
      ],
    );
  }
}
