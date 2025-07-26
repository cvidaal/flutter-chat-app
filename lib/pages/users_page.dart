import 'package:chat/models/usuario.dart';
import 'package:chat/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Dependencia para recargar la página
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // usuarios de prueba
  final usuarios = [
    Usuario(uid: '1', nombre: 'Pedro', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Melisa', email: 'test2@test.com', online: true),
    Usuario(uid: '3', nombre: 'Sofia', email: 'test3@test.com', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Text(usuario.nombre),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              //TODO: Desconectar del socket server
              AuthService.deleteToken();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ),
              // child: Icon(Icons.offline_bolt, color: Colors.red,),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _loadUsers,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue[400]!,
          ),
          child: _listViewUsers(),
        ));
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) => _userListTile(usuarios[i]),
        separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
            ),
        itemCount: usuarios.length);
  }

  ListTile _userListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre!),
      subtitle: Text(usuario.email!),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre!.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  _loadUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
