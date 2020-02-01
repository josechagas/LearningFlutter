import 'package:flutter/material.dart';
import 'package:lista_contatos/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';

typedef OnOptionPressed = void Function(Contact contact);
typedef OnAfterDeleteOptionPressed = void Function(Contact contact, bool success);

class ContactBottomSheetOptions extends StatelessWidget {
  ContactBottomSheetOptions({
    @required this.contact,
    @required OnOptionPressed editOptionFuction,
    this.onAfterDeleteOption,
  }) : this._editOptionPressed = editOptionFuction;

  final Contact contact;
  final OnOptionPressed _editOptionPressed;
  final OnAfterDeleteOptionPressed onAfterDeleteOption;

  final _contactHelper = ContactHelper();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Escolha uma opção",
            style: Theme.of(context).textTheme.subhead.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        MaterialButton(
          child: Text(
            "Ligar",
            style: Theme.of(context).textTheme.title,
          ),
          onPressed: () => makeACall(context,contact),
        ),
        Divider(),
        MaterialButton(
          child: Text(
            "Editar",
            style: Theme.of(context).textTheme.title,
          ),
          onPressed: () => _editOptionPressed(contact),
        ),
        Divider(),
        MaterialButton(
          child: Text(
            "Excluir",
            style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () => deleteContact(context,contact),
        ),
        Divider(),
        MaterialButton(
          child: Text(
            "Cancelar",
            style: Theme.of(context).textTheme.title,
          ),
          onPressed: () => onCancelButtonPressed(context),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void makeACall(BuildContext context,Contact contact) {
    String phone = contact?.phone;
    if(phone != null && phone.isNotEmpty) {
      launch("tel:$phone");
      Navigator.of(context).pop();
    }
  }



  void deleteContact(BuildContext context, Contact contact) async {
    if(contact?.id != null) {
      final result = await _contactHelper.deleteContact(contact.id);
      Navigator.of(context).pop();
      onAfterDeleteOption(contact, result > 0);
    }
  }

  void onCancelButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
