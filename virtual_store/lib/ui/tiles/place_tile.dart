import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class PlaceTile extends StatelessWidget {

  PlaceTile({Key key, @required this.place}):super(key: key);

  final DocumentSnapshot place;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = place.data['image'];
    final String title = place.data['title'];
    final String address = place.data['address'];
    final String phoneNumber = place.data['phone'];
    final GeoPoint geolocation = place.data['geolocation'];

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  address,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Ver no Mapa',
                ),
                textColor: Colors.blue,
                onPressed: () => _showOnMap(geolocation.latitude, geolocation.longitude),
              ),
              FlatButton(
                child: Text(
                  'Ligar',
                ),
                textColor: Colors.blue,
                onPressed: () => _makeACall(phoneNumber),
              )
            ],
          )
        ],
      ),
    );
  }

  void _makeACall(String phoneNumber) {
    launch('tel:$phoneNumber');
  }

  void _showOnMap(double latitude, double longitude) {
    launch('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  }
}
