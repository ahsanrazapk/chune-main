import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp/models/profile_model.dart';

import '../Useful_Code/constants.dart';

abstract class ProfileRepository {
  Query get likedChunesQuery;

  Query get myNotificationsQuery;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get myNotificationsCount;

  Future<bool> isNewUser(String userId);

  Future<bool> usernameExists(String userName);

  Future<ProfileModel> getUserProfile(String userId);

  ProfileModel getMyCachedProfile();

  Future<ProfileModel> createProfile(String userId, ProfileModel profile);

  void updateLikes(String id, bool likeStatus);

  void resetNotifications();

  void updateFollows(String id, bool followStatus);

  Future<ProfileModel> loadUserProfile(String userId);

  Query userChunesQuery(String id);
}

class ProfileRepositoryImpl extends ProfileRepository {
  final fireStore = FirebaseFirestore.instance;

  Query get likedChunesQuery => FirebaseFirestore.instance
      .collection(chunesCollection)
      .where(FieldPath.documentId,
          whereIn: me.likedChunes.isNotEmpty ? me.likedChunes : ['notfound']);

  Query get myNotificationsQuery => FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(me.id)
      .collection(notificationCollection)
      .orderBy('timestamp', descending: true);

  Stream<DocumentSnapshot<Map<String, dynamic>>> get myNotificationsCount =>
      FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(me.id)
          .snapshots();

  @override
  Future<bool> isNewUser(String userId) async {
    final user = await fireStore.collection(usersCollection).doc(userId).get();
    return !user.exists;
  }

  ProfileModel me;

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    final userRef = fireStore.collection(usersCollection).doc(userId);
    final info = await userRef.collection(infoCollection).get();
    final user = await userRef.get();
    final userData = Map<String, dynamic>.from(user.data());
    for (final i in info.docs) {
      if (i.id == 'following') {
        userData['following'] = i.data()['key'];
      }
      if (i.id == 'followers') {
        userData['followers'] = i.data()['key'];
      }
      if (i.id == 'chunes') {
        userData['chunes'] = i.data()['key'];
      }
      if (i.id == 'likedChunes') {
        userData['likedChunes'] = i.data()['key'];
      }
    }
    this.me = ProfileModel.fromMap(userData).copyWith(id: user.id);
    return this.me;
  }

  @override
  Future<bool> usernameExists(String userName) async {
    final user = await fireStore
        .collection(usersCollection)
        .where('username', isEqualTo: '$userName')
        .get();
    return user.size > 0;
  }

  @override
  Future<ProfileModel> createProfile(
      String userId, ProfileModel profile) async {
    try {
      await fireStore
          .collection(usersCollection)
          .doc(userId)
          .set(profile.toMap());
      this.me = profile.copyWith(id: userId);
      return me;
    } catch (e) {
      return null;
    }
  }

  @override
  ProfileModel getMyCachedProfile() => me;

  @override
  void updateLikes(String id, bool likeStatus) {
    if (likeStatus) {
      me.likedChunes.add(id);
    } else {
      me.likedChunes.remove(id);
    }
  }

  @override
  void updateFollows(String id, bool followStatus) {
    if (followStatus) {
      me.followings.add(id);
    } else {
      me.followings.remove(id);
    }
  }

  @override
  Future<ProfileModel> loadUserProfile(String userId) async {
    final profile =
        await fireStore.collection(usersCollection).doc(userId).get();
    return ProfileModel.fromMap(profile.data()).copyWith(id: userId);
  }

  @override
  Query<Object> userChunesQuery(String id) => fireStore
      .collection(chunesCollection)
      .where('userId', isEqualTo: id)
      .orderBy('timestamp', descending: true);

  @override
  void resetNotifications() async {
    await fireStore.collection(usersCollection).doc(me.id).update({
      'unreadNotifications': 0,
    });
  }
}
