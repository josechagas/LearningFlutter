import 'package:lista_contatos/helpers/contact_helper.dart';

class ContactPageBloc {
  ContactPageBloc({Contact contact})
      : _contact = contact,
        this.name = contact?.name,
        this.email = contact?.email,
        this.phone = contact?.phone,
        this.img = contact?.img;

  Contact _contact;

  bool userEdited = false;

  String name;
  String email;
  String phone;
  String img;

  ContactHelper _contactHelper = ContactHelper();

  Future<bool> saveContact() async {
    final isNewContact = _contact == null;
    if(isNewContact) {
      var newContact = Contact(phone: phone, name: name, email: email, img: img);
      final result = await _contactHelper.saveContact(newContact);
      return result?.id != null;
    }
    else {
      var updatedContact = Contact.fromJson(_contact.toJson());
      updatedContact.name = name;
      updatedContact.email = email;
      updatedContact.phone = phone;
      updatedContact.img = img;

      final result = await _contactHelper.updateContact(updatedContact);
      return result > 0;
    }
  }

}
