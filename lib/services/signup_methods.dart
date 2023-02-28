import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String? email,
      required String? password,
      required String? nome,
      required String? cognome,
      required String? telefono,
      required String? indirizzo}) async {
    String result = 'Some error occurred';
    try {
      if (email!.isNotEmpty ||
          password!.isNotEmpty ||
          nome!.isNotEmpty ||
          cognome!.isNotEmpty ||
          telefono!.isNotEmpty ||
          indirizzo!.isNotEmpty) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password!);
        print(user.user!.uid);

        UserModel userModel = UserModel(
            uid: user.user!.uid,
            email: email,
            nome: nome!,
            cognome: cognome!,
            telefono: telefono!,
            indirizzo: indirizzo!);

        await _firestore.collection('users_database').doc(user.user!.uid).set(
              userModel.toJson(),
            );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    return result;
  }
}

class UserModel {
  final String uid;
  final String email;
  final String nome;
  final String cognome;
  final String telefono;
  final String indirizzo;

  UserModel(
      {required this.uid,
      required this.email,
      required this.nome,
      required this.cognome,
      required this.telefono,
      required this.indirizzo});

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "nome": nome, "cognome": cognome, "telefono": telefono, "indirizzo": indirizzo};

  static UserModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        uid: snapshot['uid'],
        email: snapshot['email'],
        nome: snapshot['nome'],
        cognome: snapshot['cognome'],
        telefono: snapshot['telefono'],
        indirizzo: snapshot['indirizzo']);
  }
}
