import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplecrud/models/user.dart';
import 'package:simplecrud/provider/users.dart';

class UserForm extends StatefulWidget {

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _FormData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _FormData['id'] = user.id;
      _FormData['name'] = user.name;
      _FormData['email'] = user.email;
      _FormData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final User user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState.validate();

              if (isValid) {
                _form.currentState.save();

                Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _FormData['id'],
                    name: _FormData['name'],
                    email: _FormData['email'],
                    avatarUrl: _FormData['avatarUrl'],
                  ),
                );
                Navigator.of(context).pop();
              }
              ;
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _FormData['name'],
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome inválido';
                  }

                  if (value.trim().length < 3) {
                    return 'Nome muito pequeno. No mínimo 3 letras.';
                  }
                  return null;
                },
                onSaved: (value) => _FormData['name'] = value,
              ),
              TextFormField(
                initialValue: _FormData['email'],
                decoration: InputDecoration(labelText: 'E-mail'),
                onSaved: (value) => _FormData['email'] = value,
              ),
              TextFormField(
                initialValue: _FormData['avatarUrl'],
                decoration: InputDecoration(labelText: 'URL do Avatar'),
                onSaved: (value) => _FormData['avatarUrl'] = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
