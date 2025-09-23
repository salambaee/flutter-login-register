# Implementasi Form Login dan Registrasi pada Flutter

## Laporan latihan

**Validasi Input**
---
menambahkan validasi yang lebih baik. Misalnya dengan cek apakah emaill memiliki format yang benar atau password memiliki panjang minimal 6 karakter. Untuk menambahkan validasi input tambahkan *if statement* pada fungsi `void _register()` seperti contoh berikut.

`lib/register_page.dart`

```dart
void _register() {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    bool validasiAt = email.contains('@gmail.com');
    bool validasiPanjang = _passwordController.text.length > 6;
    if (fullName.isNotEmpty && email.isNotEmpty && password.isNotEmpty && validasiAt && validasiPanjang) {
        //Kondisi true
    } else {
        //Kondisi false
    }
}
```

**Hasil penambahan kode diatas**

![Screenshot](images/01.gif)

Data `fullName`, `email`, dan `password` diambil dari *controller* masing-masing. Setelah itu, divalidasi melalui variabel boolean `validasiAt` dan `validasiPanjang`.

**Tampilkan atau Sembunyikan Password**
---
menambahkan ikon mata pada `TextField` password yang bisa ditekan untuk menampilkan atau menyembunyikan teks password. Pada bagian class `TextField` tambahakan `suffixIcon` dan `IconButton` kode berikut

`lib/register_page.dart`

```dart
TextField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    hintText: 'Password',
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    prefixIcon: Icon(Icons.lock),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    )
  ),
),
```

`lib/login_page.dart`

```dart
TextField(
  controller: _passwordController,
  obscureText: _obsecurePassword,
  decoration: InputDecoration(
    hintText: 'Password',
    filled: true,
    fillColor: Colors.white.withOpacity(0.9),
    prefixIcon: Icon(Icons.lock),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    suffixIcon: IconButton(
      icon: Icon(
        _obsecurePassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _obsecurePassword = !_obsecurePassword;
        });
      },
    ),
  ),
),
```

**Hasil dari penambahan kode diatas**

![Screenshot](images/02.gif)

Properti `obscureText` artinya teks yang ditulis diubah jadi karakter titik supaya tidak terlihat. Jika false, teks akan tampil seperti biasa. `suffixIcon` muncul di ujung kanan `TextField` karena menggunakan `IconButton` dengan ikon `Icons.visibility_off` atau `Icons.visibility`, ikon yang muncul tergantung dengan kondisi `_obscurePassword`. `onPressed` ketika ikon ditekan, `setState()` dijalankan untuk membalikan nilai `_obscurePassword`. Kalau sebelumnya `true`, maka akan jadi `false`, dan juga sebaliknya.

**Animasi Sederhana**
-
Menambahkan `Hero` widget pada ikon di halaman login dan registrasi agar ada transisi animasi yang halus.

`lib/register_page.dart`

```dart
child: Center(
    child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                    tag: "appIcon",
                    child: Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
                ),
              ]
            //..
        ),
    ),
),
```

`lib/login_page.dart`

```dart
child: Center(
    child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                    tag: "appIcon",
                    child: Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
                ),
              ]
            //..
        ),
    ),
),
```

**Hasil dari penambahan kode diatas**

![Screenshot](images/03.gif)

Hero membutuhkan `tag` yang sama di dua halaman, sebagai jembatan supaya flutter tahu bahwa kedua widget tersebut adalah widget yang sama di dua layar berbeda. Saat user berpindah halaman flutter akan mencocokan Hero dengan `tag` yang sama di kedua halaman.

**Simpan Sesi Login**
-
Gunakan *package* `shared_preferences` untuk menyimpan status login. Jadi, saat aplikasi ditutup dan dibuka lagi, pengguna tidak perlu login ulang jika sesinya masih aktif.

`lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  final String? fullName = prefs.getString("fullName");

  runApp(MyApp(isLoggedIn: isLoggedIn, fullName: fullName));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? fullName;
  const MyApp({super.key, required this.isLoggedIn, this.fullName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage(fullName: fullName ?? "Guest") : LoginPage(),
    );
  }
}
```

`lib/login_page.dart`

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecurePassword = true;

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (userData.containsKey(email) && userData[email]!['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("fullName", userData[email]!['fullName']!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(fullName: userData[email]!['fullName']!,),
          ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text('Email atau password salah.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
```

**Hasil dari penambahan kode diatas**
![Screenshot](images/04.gif)


Pertama kali buka aplikasi, dicek apakah `isLoggedIn` di SharedPreferences. Jika ada dan kondisi `true` maka masuk ke `HomePage`, jika tidak ada atau `false` masuk ke `LoginPage`. Saat login berhasil simpan data login ke SharedPreferences. Saat aplikasi ditutup lalu dibuka lagi, data login masih tersimpan dan user langsung diarahkan ke `HomePage` tanpa login ulang.