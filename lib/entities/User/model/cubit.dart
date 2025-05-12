import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSignedIn());
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        emit(AuthFailure(message: "An error occurred: User Not Found"));
      } else if (error.code == 'wrong-password') {
        emit(
          AuthFailure(message: "An error occurred: Wrong Username or Password"),
        );
      }
    } catch (e) {
      emit(AuthFailure(message: "An error has occurred"));
    } finally {
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
        "userId": userCredential.user!.uid,
        "userName": username,
        "email": email,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure(message: "The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFailure(message: "The account already exists for this email."));
      }
    }catch (e) {
      emit(AuthFailure(message: "An error has occurred"));
    }
  }
}
