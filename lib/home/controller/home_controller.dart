import 'dart:convert';

import 'package:loginapp/data/model/book_model.dart';
import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';

class BookService {
  final dio = Dio();

  final String apiUrl =
      'https://falstapi-production-90dc.up.railway.app/'; // Replace with your API URL

  Future<Result<List<Book>, Exception>> fetchBooks() async {
    try {
      final response = await dio.get("${apiUrl}books");
      if (response.statusCode == 200) {
        var data = response.data as List;
        var bookList = data.map((e) => Book.fromMap(e)).toList();

        return Success(bookList);
      } else {
        return Error(Exception(Exception('Failed to load books')));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }

  Future<Result<bool, Exception>> createBook(Book book) async {
    try {
      final response = await dio.post('${apiUrl}books/',
          data: {"id": book.id, "title": book.title, "author": book.author},
          options: Options(headers: {'Content-type': 'application/json'}));

      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(Exception('Failed to create a book'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }

  Future<Result<bool, Exception>> updateBook(Book book) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var data = json
          .encode({"id": book.id, "title": book.title, "author": book.author});
      final response = await dio.request(
        '${apiUrl}books/${book.id}',
        data: data,
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(Exception('Failed to update the book'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }

  Future<Result<bool, Exception>> deleteBook(int id) async {
    try {
      var headers = {'Accept': 'application/json'};
      var response = await dio.request(
        '${apiUrl}books/$id',
        options: Options(
          method: 'DELETE',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        return const Success(true);
      } else {
        return Error(Exception('Failed to delete the book'));
      }
    } catch (e) {
      return Error(Exception(e));
    }
  }
}
