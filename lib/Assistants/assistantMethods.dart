import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/request-assistant.dart';
import 'package:rider_app/config-maps.dart';
import 'package:rider_app/controllers/appProvider.dart';
import 'package:rider_app/models/address.dart';
import 'package:rider_app/models/directionDetails.dart';
import 'package:rider_app/models/user.dart';

class AssistantMethods {
  Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBSn3hFO_1ndRGrxuCZcnQ-LzhWet2Nq-s";

    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      //print(response);
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userAddress = new Address();
      userAddress.latitude = position.latitude;
      userAddress.longitude = position.longitude;
      userAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userAddress);
    } else {
      print("get address failed");
    }

    return placeAddress;
  }

  //
  static Future<DirectionDetails> obtainDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionURL =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionURL);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static double calculateFares(DirectionDetails directionDetails) {
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //convert to kd
    double totalKDAmount = totalFareAmount * 0.315;

    return totalKDAmount;
  }

  static void getCurrentOnLineUserInfo()async{

    firebaseUser = await FirebaseAuth.instance.currentUser;

    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value !=null ){
        userCurrentInfo  = Users.fromSnapshot(dataSnapshot);

      }
    });

  }

  static double createRandomNumber (int num){
    var random = Random();
    int redNumber = random.nextInt(num);

    return redNumber.toDouble();
  }
}
