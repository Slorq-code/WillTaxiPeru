import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:taxiapp/models/ride_request_model.dart';

@lazySingleton
class RideRequestService {
  String collectionRequests = 'requests';

  FirebaseFirestore get firebaseFiretore => FirebaseFirestore.instance;

  void updateRequest(Map<String, dynamic> values) {
    firebaseFiretore.collection(collectionRequests).doc(values['id']).update(values);
  }

  Stream<QuerySnapshot> requestStream({String id}) {
    final reference = firebaseFiretore.collection(collectionRequests);
    return reference.snapshots();
  }

  Future<RideRequestModel> getRequestById(String id) => firebaseFiretore.collection(collectionRequests).doc(id).get().then((doc) {
        return RideRequestModel.fromJson(doc.data());
      });

  void createRideRequest({
    String id,
    String userId,
    String username,
    Map<String, dynamic> destination,
    Map<String, dynamic> position,
    Map distance,
  }) {
    firebaseFiretore.collection(collectionRequests).doc(id).set({
      'username': username,
      'id': id,
      'userId': userId,
      'driverId': '',
      'position': position,
      'status': 'pending',
      'destination': destination,
      'distance': distance
    });
  }
}
