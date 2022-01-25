
import 'package:flats/Utils/get_chatroom_id_function.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){

  test('equal names return same chatroom id in reverse order',(){

    String result1 = getChatRoomIdByUsernames("ale", "bepo");
    String result2 = getChatRoomIdByUsernames("bepo", "ale");
    bool result = result1 == result2;
    expect(result, true);
  });

  test('equal emails return same chatroom id in reverse order',(){

    String result1 = getChatRoomIdByUsernames("alessio@gmail.com", "beporap@yahoo.it");
    String result2 = getChatRoomIdByUsernames("beporap@yahoo.it", "alessio@gmail.com");
    bool result = result1 == result2;
    expect(result, true);
  });


}