# Pertanyaan dan Jawaban Tugas 7

## Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.

Widget tree adalah struktur pohon (hierarki) dari widget-widget yang membentuk UI aplikasi Flutter. Setiap widget adalah node, widget yang berada di atas disebut parent (induk), widget yang berada di bawah disebut child (anak). UI-nya itu bakal di bangun dengan ngecompose widget ini satu sama lain. Parent-nya ni bakal ngebuat constraints (batasan) buat si child. Child-nya ni bakal memilih ukuran dan membangun dirinya sendiri sesuai batasan tersebut.

## Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.

Material app -> Widget Root
Theme data/color scheme -> pemngaturan tema (warna,typografi)
MyApp -> custom widget (statelessWidget) sbg root apk membungkus material app
MyHomePage -> stateless widget yang napilin hal utama
scaffold -> layout dasar halaman
appbar -> bar atas apk
Padding -> memberi ruang disekitar widget child
column -> menyusun child scr vertikal
row -> menyusun child scr horizontal
infocard -> statelessWidget yang membungkus card dan container (yang namiplin informasi NPM, Name, class)
Container -> kotak buat padding, ukuran,dekorasi
MediaQuery -> untuk baca ukuran layar/informasi media
sizedbox -> berikan ruang kosong dgn ukuran tertentu
Center -> pusatkan child
Text -> nampilin text
GridView.count -> grid layout
ItemCard -> stateless widget utk setiap tombol/kartu di grid
Material -> menyediakan surface material
InkWell -> widget buat nanganin tap dgn efek ripple
scaffoldmessager -> nampilin snackbar

## Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.

MaterialApp ini widget yang definisiin banyak konfigurasi tingkat atas aplikasi:

1. tema (theme) color scheme, font deault,dsb
2. Navigator dan routing
3. Integrasi dgn material design widget (seperti scaffold, AppBar) sehingga behaviour-nya ni konsisten
4. Localizations, directionality (LTR/RTL), MediaQuery default, dsb

nah karena si MAterialAPpnya ini ngesetup banyak infrastruktu penting (yang diatas ni). Dia bagus dipakai sebagai root aplikasi kalau mau menggunakan material Design. Tanpa MaterialApp ada banyak infrastruktu yang harus disiapin scr manual

## Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?

StatelessWidget ini tidak punya state internal yang berubah selama lifecycle widget. build() cuman bergantung pada parameter konstruktor sama buildContext
Kalau StatefulWidhget ini dia memiliki state terpisah yang menyimpan data yang bisa berubah. dia pakal memanggil setState() untuk memicu rebuild

Nah StatelessWidget ini digunaik ketika semua datanyanya ini berasal dari parent atau state management eksternaljadinya widget ini tidak menyimpan state (basiclly uinya ini nampilin data yang tidak berubah atau data perubahan datang dari luar melalui parent)
Kalau statefulwidget itu kalau mau tampilan harus bereaksi terhadapt event lokal (kek toggle/animation/input gitu)

## Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?

BuildContext adalah handle terhadap posisi widget saat ini di widgettree. dia bakal izinin widget buat akes parent widgets, akses InheritedWidget atau dependency Injection sama mencari navigator buat navigasi. hal ini penting karena banyak helper API memerlukan BuildContext biar mereka tahu subtree mana pemanggilan dilakuin. context ini juga ngerepresentasiin lokasi widget saat ini.

Penggunaan di build() itu misal Widget build(BuildContext context){.......} disini kita bakal dapat context yang valid untuk cari ancestornya.
ex :
Theme.of(context).colorScheme.primary
ini buat ngambil warna tema

## Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart"

Hot Reload ini memuat ulang perubahan code Dart ke apk yang sedang berjalan, menjaga state (jadi nilai variabel di statefulWidget kgk di reset) nah ini biasanay diapakai saat edit layout styling, sebagian besar logic fungsi/widget karena cepat juga. Limitasinya ini perubahan top level state initialization, main(), global static initialiation kgk muncul.

nah kalau hot restart baru dia ngerestart apk dartnya jadi semua semua state di reset ke keaadaan awal (jadi apknya dijalanin ulang namun proses masih pertahanin apk terhubung yang ke device/emulator daripada full install). Nah hal ini benar benar ngerestart ulang semuanya dan perubahan yang sebelumnya hot reload gk bisa disini di hot restart bisa gitu.
