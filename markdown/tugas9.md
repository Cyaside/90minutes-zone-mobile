## Jelaskan mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?

Ketika aplikasi Flutter/Dart berinteraksi dengan API, responsnya biasanya berupa JSON, Jika kita langsung dengan Map<String, dynamic> bakal ada yang hilang gitu benefit dari sistem tipe dartnya. kalau dgn memakai model dart bakal safety, readbility sama maintanability. Dengan menggunakan type safety bakal ngurangin runtime error (kalau gak ya bisa crash gitu kalau misal name = int padahal namenya string) (nama bakal dijamin string) kalau null safety kita bisa pakai required, ? dan initializer yg mana nanti errornya muncul di compile time bukan saat run time kalau gk pakai. maintanability ini negmudahin kita pelihara saat api berubah jadi kita cukup edit di model dan seluruh app otomatis ngikut kalau gk dipake ya harus peerbaiki satu file

## Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.

fungsi utama package http itu buat rquest ke server dan baca response server kalau cookie request buat nyimpen cookie dari django abis itu ngirim cookie tsb di setiap request selanjutnya.
http biasanya buat request biasa tidak butuh autentikasi dan tidak simpan session/cookie kalau cookie request buat login,logout dan request yang butuh session django.

## Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.

Instance CookieRequest harus dibagiin ke seluruh komponen flutter karena ia nyimpen cookie dan session login Django. Jika setiap widget membuat instance sendiri sesi login tidak bakal terbawa antar halaman sehingga request ke be-nya dianggap berasal dari user berbeda dan menyebabkan error (unautherized error lah). Dengan membagikan satu instance untuk seluruh aplikasi, semua halaman memakai session yang sama, menjaga konsistensi status login dan membuat komunikasi stabil

## Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?

Biar flutter dapat komunikasi dgn django diperluin konfigurasi buat connectionnya karena flutter dan django runnya di enviroment berbeda. nambahin 10.0.2.2 pada allowed host mungkinin django agar mengizinkan request dari emulator android. mengaktifkan cors ini agar browser atau flutter web dapat saling request lintas origin. Sedangkan samesite dan cookie mastiin session login atau cookie autentikasi dapat dikirim dan diterima antar domain. selain itu, nambahin izin akses internet ini agar apk flutter dapat akses jaringan jika tidak request flutter ke django bakal gagal, muncul errornya connection refused sih harusnya. cooki/session kgk kebawa, login gk works atau browser block req lintas origin

## Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.

pertama data dimasukin melalui widget input di aplikasi flutter lalu data dikumpul oleh controller atau state widget lalu dikirim ke django dgn httprequest atau cookie request. django nerima dan proses data, simpen di database, dan return response berupa json. flutter nerima response, parsing json lalu bakal simpen data di state management atau langsung di state wdiget. akhirnya widget terkait refresh dan data hasil input muncul

## Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.

saat user masukan data akun di flutter melalui widget input, data dikirim ke django pakai cookie request(post) agar session cookie tersimpen. pada register, django nerima data , buat user baru di database dan balikin response sukses kalau works. abis itu ke login kita pada login masukin kredensial akun yang dibuat tdi, nanti django verifikasi kredensialnya abis itu buat session lalu ngirim reponse json ke flutter. instance cookie request nyimpen cookie ini sehingga ini seluruh request dianggap dari user sama. Lalu saat logout flutter ngirim request logout ke django. django ngapus session dan cookierequest juga hapus cookie dan flutter kemudian navigasiin user ke halam login kembali

## Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).

Untuk saya juga based on tutorial untuk step by step tapi ya sesuain punya saya. pertama buat authenticationnya dlu di django lalu ya tentu buat halam register dan login di flutternya dan ya integrasiin lah. lanjut kita buat model kustom yang mana based on json saya dan ya tentu lanjut buat halaman utk tiap data jsonnya
