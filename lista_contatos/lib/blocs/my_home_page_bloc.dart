

import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:lista_contatos/ui/my_home_page.dart';

class MyHomePageBloc {

  ContactHelper helper = ContactHelper();
  Future<List<Contact>> contactsFuture;
  List<Contact> contacts;

  Contact getContactAt(int index) {
    if(contacts != null && contacts.isNotEmpty && contacts.length > index)
      return contacts[index];
    return null;
  }

  loadContacts(){
    contactsFuture = helper.getAllContacts();
    contactsFuture.then((contacts){
      this.contacts = contacts;
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
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.zToa:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      default:
        break;
    }
  }
}