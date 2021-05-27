import 'package:http/http.dart' as http;
import 'package:loja_virtualflutter/data/cep_data.dart';

class ViaCepService {
  static Future<ResultCep> fetchCep({String cep}) async {
    final response = await http.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      return null;
    }
  }
}