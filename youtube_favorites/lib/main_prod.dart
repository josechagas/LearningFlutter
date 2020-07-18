import 'package:youtube_favorites/envs.dart';
import 'package:youtube_favorites/main.dart';

void main(){
  Constants.setEnvironment(Environment.PROD);
  mainDelegate();
}