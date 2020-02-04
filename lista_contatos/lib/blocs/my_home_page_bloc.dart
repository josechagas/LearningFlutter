

import 'package:flutter/cupertino.dart';
import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:lista_contatos/ui/my_home_page.dart';

class MyHomePageBloc {

  ContactHelper helper = ContactHelper();
  //Future<List<Contact>> contactsFuture;

  ValueNotifier<Future<List<Contact>>> contactsFuture = ValueNotifier(null);

  ValueNotifier<List<Contact>> contacts = ValueNotifier(null);

  Contact getContactAt(int index) {
    if(contacts != null)
      if(contacts.value != null &&
          contacts.value.isNotEmpty &&
          contacts.value.length > index)
        return contacts.value[index];
    return null;
  }

  loadContacts(){
    contactsFuture.value = helper.getAllContacts();
    contactsFuture.value.then((contacts){
      this.contacts.value = contacts;
    });
  }


  saveContactExample() async {
    print("saving example contact");
    Contact c = Contact(
        name: "Daniel",
        email: "daniel@gmail.com",
        phone: "85985137757",
        img: "teste");
    final Contact result = await helper.saveContact(c);
    print(result ?? "no contact");
  }

  getAllContactsExample() {
    print("loading all contacts");
    helper.getAllContacts().then((contacts){
      if(contacts == null)
        print("contacts is null");
      else
        print(contacts ?? "no contacts");
    });
  }

  void orderContactsBy(OrderOptions orderBy) {
    switch(orderBy) {
      case OrderOptions.aToz:
        contacts.value.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        contacts.notifyListeners();
        break;
      case OrderOptions.zToa:
        contacts.value.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        contacts.notifyListeners();
        break;
      default:
        break;
    }
  }
}