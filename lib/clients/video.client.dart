import 'package:cloud_firestore/cloud_firestore.dart';

import '../models.dart';
import '../shared.dart';

class DbVideo {
  final int creationTime; // in milliseconds SinceEpoch
  String videoUrl;
  GeoPoint location;
  final DocumentReference? ref; // not a db field

  DbVideo({
    required this.creationTime,
    required this.videoUrl,
    required this.location,
    this.ref,
  });

  factory DbVideo.fromJson(json, ref) {
    return DbVideo(
      ref: ref,
      location: json['location'],
      videoUrl: json['videoUrl'],
      creationTime: json['creationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creationTime': creationTime,
      'videoUrl': videoUrl,
      'location': location
    };
  }
}

class VideoClient {
  static Future<List<DbVideo>> getVideoListAround(GeoPoint location) async {
    LatLngBound bounds = getLatLngBoundFromRadius(100000, location);
    GeoPoint lesserGeopoint = GeoPoint(bounds.lowerLat, bounds.lowerLng);
    GeoPoint greaterGeopoint = GeoPoint(bounds.greaterLat, bounds.greaterLng);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('videos')
        .where("location", isGreaterThan: lesserGeopoint)
        .where("location", isLessThan: greaterGeopoint)
        .get();

    if (query.size > 0) {
      final videoList = query.docs
          .map((e) => DbVideo.fromJson(e.data(), e.reference))
          .toList();
      videoList.sort((a, b) => b.creationTime.compareTo(a.creationTime));
      return videoList;
    } else {
      return List<DbVideo>.empty();
    }
  }

  static saveVideo(DbVideo video) async {
    DocumentReference newVideoRef =
        FirebaseFirestore.instance.collection('videos').doc();
    await newVideoRef.set(video.toJson());
  }
}
