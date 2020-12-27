import 'package:flutter/material.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';

class HeaderWidget extends StatelessWidget{

  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();

  @override
  Widget build(BuildContext context) {
    _authSocialNetwork.user.name = 'Bryan Aliaga';
    var splitName = _authSocialNetwork.user.name.split(' ');
    var nameAbbreviation = '';
    for (var word in splitName) {
      nameAbbreviation = nameAbbreviation + word.substring(0, 1);
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(240, 240, 240, 1.0),
                border: Border.all(
                  color: const Color.fromRGBO(255, 165, 0, 1.0),
                  width: 2,
                ),
                image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://freepngimg.com/thumb/mario_bros/92986-mario-play-toy-super-bros-png-file-hd.png'),
                ),
              ),
              child: Center(child: Text(nameAbbreviation, style: const TextStyle(fontSize: 35.0, color: Colors.black)),),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 80,
              // color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_authSocialNetwork.user.name, style: const TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15),),

                  const SizedBox(height: 5.0),

                  Container(
                    height: 30,
                    // width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(color: Color.fromRGBO(240, 240, 240, 1.0), spreadRadius: 1.5),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Conducir', style: TextStyle(color: Color.fromRGBO(130, 130, 130, 1.0), fontSize: 15)),
                        Switch(
                          value: true,
                          onChanged: (value) {
                            
                          },
                          activeTrackColor: const Color.fromRGBO(240, 240, 240, 1.0),
                          activeColor: const Color.fromRGBO(255, 165, 0, 1.0),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
