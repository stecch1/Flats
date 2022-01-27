import 'package:flats/Screens/Host/host_add.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){

  test('empty field returns error string',(){

    var result = FieldValidator.validate('');
    expect(result, 'Invalid text');
  });

  test('wrong format returns error string',(){

    var result = FieldValidator.validate('trytouse@');
    expect(result, 'Invalid text');
  });

  test('right format returns null',(){

    var result = FieldValidator.validate('thisshouldwork');
    expect(result, null);
  });

  test('even if there is a space returns null',(){

    var result = FieldValidator.validate('thisshould work');
    expect(result, null);
  });

  test('even if there is caps returns null',(){

    var result = FieldValidator.validate('this Should work');
    expect(result, null);
  });
  test(', character wrong',(){

    var result = FieldValidator.validate('thisshouldnt # work');
    expect(result, 'Invalid text');
  });

  test('numbers return null',(){

    var result = FieldValidator.validate('this9');
    expect(result, null);
  });
  test('points return null',(){

    var result = FieldValidator.validate('Appartamentino per sole donne lavoratrici. Contattateci dopo il 15 Marzo.');
    expect(result, null);
  });

  test('numbers return null',(){

    var result = FieldValidator.validate('Now i use comma,');
    expect(result, null);
  });

  test('numbers return null',(){

    var result = FieldValidator.validate('Now i use comma \' ');
    expect(result, null);
  });


}