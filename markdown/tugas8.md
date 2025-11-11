## Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

Navigator.push() ini berguna buat nambahin halaman baru ke stack navigasi, sehingga halaman sebelumnya tetep ada di bawahnya jadinya user dapat kembali dgn tombol back

kalau Navigator.pushReplacement() itu mengganti halaman saat di stack dgn halamn baru sehingga halaman sebelumnya dihapus dan tidak bisa kembali secara otomatis

Kalau Navigator.push sebaiknya ya digunakan untuk navigasi yang ada tombol back-nya kalau disini contohnya pas di tambahproduk itu dia kan bisa back ya dia pakai ini

kalau navigator.pushreplacement cocoknya kalau misal login/logout jadi dari splash screen ke menu utama jadinya dia gak bisa balik scr otomatis gitu

## Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

AppBar digunain di setiap halaman untuk judul dan navigasi
Drawer (left drawer) digunain buat menyediakan menu global yang disamping (Halaman utama dan tambah produk bisa diakses dari sini)
Nah kalau scaffold contohnya digunakan buat bungkus ListView dengan kartu produk dengan AppBar dan Drawer. di add_product_page.dart, scaffold utk buat form dgn appbar

## Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

Padding nambahin ruangan di sekitar widget untuk ngehindarin elemen nempel ke tepi layar biar ningkatin style ama readability
SingleChildScrollView ngebuat kontent scrollable jika tinggi form melebih layar utk cegah overflow (misal kalau devicenya kecil masih bagus gitu)
ListView ini bisa dibilang widget yang efisien buat nampilin halaman dinamis karena pake lazy loading jadi dia hanya render elemen yang terlihat dilayar

contohnya di aplikasi, di add_product_page.dart padding ngebungkus column form untuk margin. SingleChildScrollView ngebungkus column biar form scrollable kalau listview digunain di menu.dart buat daftar card product kalau di add_product_page dia buat container scrollable buat daftar elemen form (mirip ama singlechildscrol) tapi lebih dinamis

## Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

Tema yang disesuain di maindart pake ThemeData dgn colorSchemenya disini saya pake-nya hitam putih soalnya di yang sebelumnya saya pakai warna hitam dan putih juga. Warna primer hitam digunain buat AppBar, tombol ama drawer kalau putih untuk background ama teks(yang nimpa hitam tapi kalau yang dia backgroundnya putih tetep hitam teks/tulisannya) ini diterapin global sehingga semua widget mengikuti skema
