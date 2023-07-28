import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginapp/data/model/book_model.dart';
import 'package:loginapp/home/controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookService _bookService = BookService();
  final bookIdController = TextEditingController();
  final bookTittleController = TextEditingController();
  final bookAuthorController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  List<Book> _books = [];
  bool isLoading = true;
  bool isAddBookLoading = false;
  bool isDeletingBookLoading = false;
  bool isupdateBookLoading = false;
  bool isUpdateButtonEnable = false;
  int tapIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      if (isDeletingBookLoading || isAddBookLoading || isupdateBookLoading) {
        isLoading = false;
      } else {
        isLoading = true;
      }
    });

    final result = await _bookService.fetchBooks();
    result.when((books) {
      setState(() {
        _books = books;
      });
      isLoading = false;
    }, (error) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(message: error.toString(), color: Colors.red);
    });
  }

  Future<void> addBook() async {
    if (formkey.currentState!.validate()) {
      final id = int.parse(bookIdController.text);
      final tittle = bookTittleController.text;
      final author = bookAuthorController.text;
      setState(() {
        isAddBookLoading = true;
      });

      var result = await _bookService.createBook(
        Book(
          id: id,
          title: tittle,
          author: author,
        ),
      );
      result.when((success) async {
        await fetchBooks();
        setState(() {
          isAddBookLoading = false;
        });
        showSnackBar(color: Colors.green, message: "Book Successfully Added");
        hidekeyboard();
        clearTextField();
      }, (error) {
        setState(() {
          isAddBookLoading = false;
        });
        showSnackBar(message: error.toString(), color: Colors.red);
      });
    }
  }

  Future<void> updateBook() async {
    final id = int.parse(bookIdController.text);
    final tittle = bookTittleController.text;
    final author = bookAuthorController.text;
    if (formkey.currentState!.validate()) {
      setState(() {
        isupdateBookLoading = true;
      });

      var result = await _bookService.updateBook(
        Book(
          id: id,
          title: tittle,
          author: author,
        ),
      );
      result.when((success) async {
        hidekeyboard();
        await fetchBooks();
        setState(() {
          isupdateBookLoading = false;
          isUpdateButtonEnable = false;
        });
        clearTextField();
        showSnackBar(message: "Book Successfully Updated", color: Colors.blue);
      }, (error) {
        setState(() {
          isupdateBookLoading = false;
        });
        showSnackBar(message: error.toString(), color: Colors.red);
      });
    }
  }

  Future<void> deleteBook({required bookId}) async {
    isDeletingBookLoading = true;
    var result = await _bookService.deleteBook(bookId);

    result.when((success) async {
      await fetchBooks();

      setState(() {
        isDeletingBookLoading = false;
      });
      showSnackBar(message: "Book Successfully Deleted", color: Colors.red);
    }, (error) {
      setState(() {
        isDeletingBookLoading = false;
      });
      showSnackBar(message: error.toString(), color: Colors.red);
    });
  }

  void clearTextField() {
    bookAuthorController.clear();
    bookIdController.clear();

    bookTittleController.clear();
    formkey.currentState?.reset();
  }

  void hidekeyboard() {
    FocusScope.of(context).unfocus();
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: color,
        ))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  @override
  void dispose() {
    formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book List',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                fetchBooks();
              },
              icon: const Icon(Icons.refresh)),
          TextButton(
              onPressed: () {
                clearTextField();
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add TextFormField for Book Title
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: bookIdController,
                    enabled: isUpdateButtonEnable ? false : true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Book id",
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a book id';
                      }
                      return null;
                    },
                  ),
                ),
                // Add TextFormField for Author
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: bookTittleController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Book Title",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Title';
                      }
                      return null;
                    },
                  ),
                ),
                // Add TextFormField for ISBN
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    controller: bookAuthorController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Author",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Author';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isUpdateButtonEnable) {
                          updateBook();
                        } else {
                          addBook();
                        }
                      },
                      child: Row(
                        children: [
                          Row(
                            children: [
                              isAddBookLoading || isupdateBookLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          isUpdateButtonEnable
                              ? const Text('Update Book')
                              : const Text('Add Book'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: isLoading
                        ? const Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 20,
                              ),
                              Text("  Fetching Books.....")
                            ],
                          ))
                        : _books.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  fetchBooks();
                                },
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _books.length,
                                  itemBuilder: (context, index) {
                                    final book = _books[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Card(
                                        elevation: 3,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Book Id : ${book.id}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    "Book Tittle : ${book.title}"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                                "Author Name : ${book.author}"),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isDeletingBookLoading =
                                                          true;
                                                      tapIndex = index;
                                                    });
                                                    deleteBook(bookId: book.id);
                                                  },
                                                  icon: isDeletingBookLoading &&
                                                          tapIndex == index
                                                      ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator())
                                                      : const Icon(
                                                          Icons.delete),
                                                  color: Colors.red,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    bookAuthorController.text =
                                                        book.author;
                                                    bookIdController.text =
                                                        book.id.toString();
                                                    bookTittleController.text =
                                                        book.title;
                                                    setState(() {
                                                      if (!isUpdateButtonEnable) {
                                                        isUpdateButtonEnable =
                                                            true;
                                                      } else {
                                                        isUpdateButtonEnable =
                                                            false;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  color: Colors.blue,
                                                ),
                                              ],
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                  child: const Text("Books Not found"),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
