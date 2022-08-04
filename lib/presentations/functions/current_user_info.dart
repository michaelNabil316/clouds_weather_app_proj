import 'package:blood_bank/business_logic/signing_bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

void setCurrentUserData(context) async {
  var appBloc = AppBloc.get(context);
  FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(appBloc.uid)
      .once()
      .then((DataSnapshot snapshot) {
    appBloc.changefirstName(snapshot.value['firstName']);
    appBloc.changelastName(snapshot.value['secondName']);
    appBloc.changeUserEmail(snapshot.value['email']);
  }).catchError((err) => print(err));
}
