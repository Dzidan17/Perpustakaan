import 'package:crud_perpustakaan/pages/insert_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = []; //(books) adalah nama database di dalam supabase

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future fetchBooks() async {
    final response = await Supabase.instance.client
        .from('books') // nama table di dalam supabase
        .select(); // fungsi yang akan digunakan untuk mengambil data dari database (bisa disesuai dengan kebutuhan)

    setState(() {
      books = List<Map<String, dynamic>>.from(
          response); // digunakan untuk merespon hasil dari pemanggilan data dari database
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Buku',
          style: GoogleFonts.notoSansGeorgian(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:
                fetchBooks, // Ketika tombol ditekan, panggil fungsi fetchBooks(merespon hasil dari pemanggilan data dari database)
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // if / Jika data masih kosong maka tampilkan loading
          : ListView.builder(
              // else / Jika data sudah ada maka tampilkan daftar buku
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                    color: Colors.grey.shade300,
                  ))),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          book['title'] ?? "Not Title",
                          style: GoogleFonts.ptSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['author'] ?? "No Author",
                              style: GoogleFonts.ptSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              book['description'] ?? "No Description",
                              style: GoogleFonts.ptSans(
                                fontSize: 10,
                                color: Colors.black,
                                // fontFamily: 'Poppins',
                              ),
                            )
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => BookDetailPage(
                                  //       book: book,
                                  //     ),
                                  //   ),
                                  // ).then((_) {
                                  //   fetchBooks(); // Mengambil data buku terbaru setelah kembali ke halaman utama
                                  // });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.blue,
                                )),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    // Ketika tombol ditekan, maka menampilkan notifikasi
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Book'),
                                        content: const Text(
                                          'Are you sure you want to delete this book?',
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () async {
                                              // await deleteBook(book['id']);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          )
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            // Memindahkan user ke halaman tambah buku
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookPage(),
            ),
          );
        },
        child: const Icon(Icons.post_add_outlined),
      ),
    );
  }
}
