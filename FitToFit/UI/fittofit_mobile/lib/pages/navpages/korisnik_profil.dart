import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fittofit_mobile/models/ocjene.dart';
import 'package:fittofit_mobile/models/ocjeneRequest.dart';
import 'package:fittofit_mobile/models/rezervacije.dart';
import 'package:fittofit_mobile/models/search_result.dart';
import 'package:fittofit_mobile/models/treneri.dart';
import 'package:fittofit_mobile/models/treninzi.dart';
import 'package:fittofit_mobile/pages/change_password.dart';
import 'package:fittofit_mobile/pages/change_username.dart';
import 'package:fittofit_mobile/providers/ocjene_provider.dart';
import 'package:fittofit_mobile/providers/rezervacije_provider.dart';
import 'package:fittofit_mobile/providers/treneri_provider.dart';
import 'package:fittofit_mobile/providers/treninzi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fittofit_mobile/models/korisnici.dart';
import 'package:fittofit_mobile/providers/korisnici_provider.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:fittofit_mobile/widgets/custom_avatar.dart';
import 'package:fittofit_mobile/widgets/master_screen_widget.dart';
import 'package:image/image.dart' as img;

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  const ProfilePage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late KorisniciProvider _korisniciProvider;
  late RezervacijeProvider _rezervacijeProvider;
  late TreninziProvider _treninziProvider;
  late OcjeneProvider _ocjeneProvider;
  late TreneriProvider _treneriProvider;
  late Korisnici korisnik;
  List<Rezervacije> _aktivneRezervacijeList = [];
  List<Rezervacije> _draftRezervacijeList = [];
  List<Rezervacije> _arhiviraneRezervacijeList = [];
  List<Rezervacije> _odbijeneRezervacijeList = [];
  List<Rezervacije> _otkazaneRezervacijeList = [];
  List<Ocjene> _ocjeneList = [];
  String? korisnickoIme = '';
  bool isLoading = true;
  List<String> vrsteRezervacija = [
    'Aktivne',
    'Na obradi', //draft
    'Arhivirane',
    'Odbijene',
    'Otkazane'
  ];

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _treninziProvider = context.read<TreninziProvider>();
    _ocjeneProvider = context.read<OcjeneProvider>();
    _treneriProvider = context.read<TreneriProvider>();
    initForm();
    _loadData();
  }

  Future initForm() async {
    setState(() {
      isLoading = true;
    });
  }

  void _loadData() async {
    korisnickoIme = await getUserName();
    var user = await _korisniciProvider
        .get(filter: {'korisnickoIme': korisnickoIme, 'isAdmin': false});

    setState(() {
      korisnik = user.result[0];
      isLoading = false;
    });
    if (korisnik != null) {
      var aktivneRezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'active',
        'isTerminiIncluded': true
      });
      var draftRezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'draft',
        'isTerminiIncluded': true
      });
      var arhiviraneRezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'archived',
        'isTerminiIncluded': true
      });
      var odbijeneRezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'refused',
        'isTerminiIncluded': true
      });
      var otkazaneRezervacije = await _rezervacijeProvider.get(filter: {
        'korisnikId': korisnik.korisnikId,
        'stateMachine': 'canceled',
        'isTerminiIncluded': true
      });

      var ocjene = await _ocjeneProvider
          .get(filter: {'korisnikId': korisnik.korisnikId});
      setState(() {
        _aktivneRezervacijeList = aktivneRezervacije.result;
        _draftRezervacijeList = draftRezervacije.result;
        _arhiviraneRezervacijeList = arhiviraneRezervacije.result;
        _odbijeneRezervacijeList = odbijeneRezervacije.result;
        _otkazaneRezervacijeList = otkazaneRezervacije.result;
        _ocjeneList = ocjene.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Profil'),
            backgroundColor: Colors.deepPurple.shade300),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(children: [
                        const SizedBox(width: 30),
                        korisnik.slika != '' && korisnik.slika != null
                            ? CustomAvatar(
                                radius: 42, base64Image: korisnik.slika!)
                            : const CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                              ),
                        const SizedBox(width: 30),
                        Column(children: [
                          Text(
                            '${korisnik.ime} ${korisnik.prezime}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () =>
                                _showEditProfileBottomSheet(context),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlue.shade300,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                "Uredi",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _buildInfoCard('${korisnik.visina}cm', 'Visina'),
                      const SizedBox(width: 20),
                      _buildInfoCard('${korisnik.tezina}kg', 'Težina'),
                      const SizedBox(width: 20),
                      _buildInfoCard(
                          "${calculateAge(korisnik.datumRodjenja!)}", 'Godine'),
                    ]),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLink(context, Icons.person, 'Lični podaci'),
                          const Divider(),
                          _buildLink(
                              context, Icons.bookmark, 'Moje rezervacije'),
                          const Divider(),
                          _buildLink(context, Icons.star, 'Moje ocjene'),
                          const Divider(),
                          _buildLink(
                              context, Icons.policy, 'Pravila korištenja'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLink(context, Icons.person_outline,
                              'Promijeni korisničko ime'),
                          const Divider(),
                          _buildLink(context, Icons.password_outlined,
                              'Promijeni lozinku')
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 106, 150, 251)),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, IconData icon, String text) {
    return TextButton(
      onPressed: () {
        if (text == 'Lični podaci') {
          _showUserDetailsBottomSheet(context);
        } else if (text == 'Moje rezervacije') {
          _showReservationsBottomSheet(context);
        } else if (text == 'Moje ocjene') {
          _showRatingsBottomSheet(context);
        } else if (text == 'Pravila korištenja') {
          _showTermsOfServiceBottomSheet(context);
        } else if (text == 'Promijeni lozinku') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(
                userId: korisnik.korisnikId,
              ),
            ),
          );
        } else if (text == 'Promijeni korisničko ime') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChangeUsernameScreen(
                userId: korisnik.korisnikId,
              ),
            ),
          );
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 20.0),
          const SizedBox(width: 16.0),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    final TextEditingController imeController =
        TextEditingController(text: korisnik.ime);
    final TextEditingController prezimeController =
        TextEditingController(text: korisnik.prezime);
    final TextEditingController telefonController =
        TextEditingController(text: korisnik.telefon);
    final TextEditingController emailController =
        TextEditingController(text: korisnik.email);
    final TextEditingController adresaController =
        TextEditingController(text: korisnik.adresa);
    final TextEditingController visinaController =
        TextEditingController(text: korisnik.visina);
    final TextEditingController tezinaController =
        TextEditingController(text: korisnik.tezina);
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uredi Profil',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 20.0),
                  FormBuilderTextField(
                    name: 'ime',
                    controller: imeController,
                    decoration: const InputDecoration(
                      labelText: 'Ime',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'Ovo polje je obavezno!'),
                      FormBuilderValidators.match(context, r'^[A-Z]',
                          errorText: 'Ime mora početi velikim slovom.'),
                      FormBuilderValidators.match(context, r'^[A-Za-z]*$',
                          errorText: 'Ime može sadržavati samo slova.'),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'prezime',
                    controller: prezimeController,
                    decoration: const InputDecoration(
                      labelText: 'Prezime',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'Ovo polje je obavezno!'),
                      FormBuilderValidators.match(context, r'^[A-Z]',
                          errorText: 'Prezime mora početi velikim slovom.'),
                      FormBuilderValidators.match(context, r'^[A-Za-z]*$',
                          errorText: 'Prezime može sadržavati samo slova.'),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'telefon',
                    controller: telefonController,
                    decoration: const InputDecoration(
                      labelText: 'Telefon',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(context,
                          errorText: 'Ovo polje može sadržavati samo brojeve.'),
                      FormBuilderValidators.maxLength(context, 10,
                          errorText:
                              'Broj telefona može imati maksimalno 10 cifara.'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'email',
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.email(context,
                          errorText: 'Unesite validnu e-mail adresu.'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'adresa',
                    controller: adresaController,
                    decoration: const InputDecoration(
                      labelText: 'Adresa',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.match(context, r'^[A-Z]',
                          errorText: 'Adresa mora početi velikim slovom.'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'visina',
                    controller: visinaController,
                    decoration: const InputDecoration(
                      labelText: 'Visina (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'Ovo polje je obavezno!'),
                      FormBuilderValidators.numeric(context,
                          errorText: 'Visina mora biti broj.'),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'tezina',
                    controller: tezinaController,
                    decoration: const InputDecoration(
                      labelText: 'Težina (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'Ovo polje je obavezno!'),
                      FormBuilderValidators.numeric(context,
                          errorText: 'Težina mora biti broj.'),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );

                      if (result != null && result.files.isNotEmpty) {
                        PlatformFile file = result.files.first;
                        File imageFile = File(file.path!);
                        Uint8List imageBytes = await imageFile.readAsBytes();
                        img.Image resizedImage = img.decodeImage(imageBytes)!;
                        int maxWidth = 800;
                        img.Image smallerImage =
                            img.copyResize(resizedImage, width: maxWidth);

                        List<int> smallerImageBytes =
                            img.encodeJpg(smallerImage);

                        String base64Image = base64Encode(smallerImageBytes);
                        setState(() {
                          korisnik.slika = base64Image;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade500,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                            color: Color.fromRGBO(0, 154, 231, 1)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload_file),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Izaberite novu sliku',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.saveAndValidate()) {
                          korisnik.ime = formKey.currentState!.value['ime'];
                          korisnik.prezime =
                              formKey.currentState!.value['prezime'];
                          korisnik.email = formKey.currentState!.value['email'];
                          korisnik.telefon =
                              formKey.currentState!.value['telefon'];
                          korisnik.adresa =
                              formKey.currentState!.value['adresa'];
                          korisnik.visina =
                              formKey.currentState!.value['visina'];
                          korisnik.tezina =
                              formKey.currentState!.value['tezina'];

                          _korisniciProvider.update(
                              korisnik.korisnikId, korisnik);
                          _showAlertDialog(
                              "Uspješan edit",
                              "Podaci o korisniku uspješno ažurirani.",
                              Colors.green);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue.shade700,
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      child: const Text('Spremi'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showUserDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  child: Text(
                    'Lični podaci',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text('Ime: ${korisnik.ime}'),
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Prezime: ${korisnik.prezime}'),
                  leading: const Icon(Icons.person_outline),
                ),
                ListTile(
                  title: Text('Spol: ${korisnik.spol}'),
                  leading: const Icon(Icons.male),
                ),
                ListTile(
                  title: Text('Telefon: ${korisnik.telefon}'),
                  leading: const Icon(Icons.phone),
                ),
                ListTile(
                  title: Text('Email: ${korisnik.email}'),
                  leading: const Icon(Icons.email),
                ),
                ListTile(
                  title: Text('Adresa: ${korisnik.adresa}'),
                  leading: const Icon(Icons.home),
                ),
                ListTile(
                  title: Text('Visina: ${korisnik.visina} cm'),
                  leading: const Icon(Icons.height),
                ),
                ListTile(
                  title: Text('Težina: ${korisnik.tezina} kg'),
                  leading: const Icon(Icons.width_full),
                ),
                ListTile(
                  title: Text(
                      'Datum rođenja: ${DateFormat('dd.MM.yyyy').format(korisnik.datumRodjenja!)}'),
                  leading: const Icon(Icons.cake),
                ),
                ListTile(
                    title: Text(
                        'Datum početka treninranja: ${DateFormat('dd.MM.yyyy').format(korisnik.datumPocetkaTreniranja!)}'),
                    leading: const Icon(Icons.accessibility)),
                ListTile(
                  title: Text('Korisničko ime: ${korisnik.korisnickoIme}'),
                  leading: const Icon(Icons.person_pin),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 248, 248, 248)),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Treninzi?> getTrainingByTrainingId(id) async {
    Treninzi t = await _treninziProvider.getById(id);
    return t;
  }

  void _showReservationsBottomSheet(BuildContext context) {
    String selectedStatus = 'Aktivne';

    List<Rezervacije> getFilteredReservations() {
      switch (selectedStatus) {
        case 'Na obradi':
          return _draftRezervacijeList;
        case 'Arhivirane':
          return _arhiviraneRezervacijeList;
        case 'Odbijene':
          return _odbijeneRezervacijeList;
        case 'Otkazane':
          return _otkazaneRezervacijeList;
        case 'Aktivne':
        default:
          return _aktivneRezervacijeList;
      }
    }

    void _cancelReservation(Rezervacije reservation) async {
      try {
        await _rezervacijeProvider.cancel(reservation.rezervacijaId);
        _showAlertDialog("Uspješano otkazivanje",
            "Rezervacija uspješno otkazana.", Colors.green);
      } catch (e) {
        _showAlertDialog("Greška", e.toString(), Colors.red);
      }
      _loadData();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final reservations = getFilteredReservations();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moje Rezervacije',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButton<String>(
                        value: selectedStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue!;
                          });
                        },
                        items: vrsteRezervacija
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      if (reservations.isEmpty) ...[
                        Center(
                          child: Text(
                            'Nema rezervacija za odabrani status.',
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 248, 248, 248)),
                              child: const Icon(
                                Icons.arrow_downward,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 16.0),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = reservations[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${DateFormat('dd.MM.yyyy').format(reservation.datum)} - ${DateFormat('dd.MM.yyyy').format(reservation.datumIsteka!)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    if (reservation.rezervacijaStavkes !=
                                        null) ...[
                                      ...reservation.rezervacijaStavkes!
                                          .map((item) {
                                        final termin = item.termin;
                                        return FutureBuilder<Treninzi?>(
                                          future: getTrainingByTrainingId(
                                              termin!.treningId),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return ListTile(
                                                title: Text(
                                                  '${termin.dan} u ${termin.sat ?? 'N/A'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                subtitle: const Text(
                                                    'Trening: Loading...'),
                                              );
                                            } else if (snapshot.hasError) {
                                              return ListTile(
                                                title: Text(
                                                  '${termin.dan} u ${termin.sat ?? 'N/A'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                subtitle: const Text(
                                                    'Trening: Error'),
                                              );
                                            } else if (!snapshot.hasData) {
                                              return ListTile(
                                                title: Text(
                                                  '${termin.dan} u ${termin.sat ?? 'N/A'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                subtitle: const Text(
                                                    'Trening: Not found'),
                                              );
                                            } else {
                                              final training = snapshot.data!;
                                              return ListTile(
                                                title: Text(
                                                  '${termin.dan} u ${termin.sat ?? 'N/A'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                                subtitle: Text(
                                                  '${training.naziv} trening',
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }).toList()
                                    ],
                                    if (selectedStatus == 'Aktivne') ...[
                                      const SizedBox(height: 8.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          _cancelReservation(reservation);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey.shade700,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: const Text('Otkaži'),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 248, 248, 248)),
                              child: const Icon(
                                Icons.arrow_downward,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Treneri?> getTrainerByTrainerId(id) async {
    Treneri t = await _treneriProvider.getById(id);
    return t;
  }

  void _showRatingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Moje Ocjene',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _ocjeneList.length,
                  itemBuilder: (context, index) {
                    final rating = _ocjeneList[index];

                    return FutureBuilder<Treneri?>(
                      future: getTrainerByTrainerId(rating.trenerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Loading...'),
                          );
                        } else if (snapshot.hasError) {
                          return const ListTile(
                            title: Text('Error fetching trainer details'),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final trainer = snapshot.data!;
                          final trainerName =
                              '${trainer.ime} ${trainer.prezime}';
                          return ListTile(
                            title: Text('$trainerName - ${rating.ocjena}'),
                            subtitle: Text(
                              DateFormat('dd.MM.yyyy').format(rating.datum),
                            ),
                          );
                        } else {
                          return const ListTile(
                            title: Text('No trainer data available'),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<SearchResult<Treneri>>(
                future: _fetchAvailableTrainers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching trainers');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final trainers = snapshot.data!;
                    final ratedTrainerIds =
                        _ocjeneList.map((e) => e.trenerId).toSet();

                    final availableTrainers = trainers.result
                        .where((trainer) =>
                            !ratedTrainerIds.contains(trainer.trenerId))
                        .toList();

                    return Column(
                      children: [
                        DropdownButtonFormField<Treneri>(
                          decoration: const InputDecoration(
                            labelText: 'Odaberi trenera',
                            border: OutlineInputBorder(),
                          ),
                          items: availableTrainers.map((trainer) {
                            return DropdownMenuItem<Treneri>(
                              value: trainer,
                              child: Text('${trainer.ime} ${trainer.prezime}'),
                            );
                          }).toList(),
                          onChanged: (selectedTrainer) {
                            if (selectedTrainer != null) {
                              _showRatingDialog(context, selectedTrainer);
                            }
                          },
                          hint: const Text('Odaberi trenera'),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  } else {
                    return const Text('Svi treneri već ocijenjeni');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 248, 248, 248),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<SearchResult<Treneri>> _fetchAvailableTrainers() async {
    return await _treneriProvider.get();
  }

  void _showRatingDialog(BuildContext context, Treneri trainer) {
    final _ratingController = TextEditingController();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(DateTime.now().toUtc());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ocijeni ${trainer.ime} ${trainer.prezime}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ocjena (1-5)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Odustani'),
            ),
            TextButton(
              onPressed: () async {
                final ratingValue = int.tryParse(_ratingController.text) ?? 0;
                if (ratingValue >= 1 && ratingValue <= 5) {
                  try {
                    OcjeneRequest ocjena = OcjeneRequest(
                        datum: formattedDate,
                        korisnikId: korisnik.korisnikId,
                        ocjena: ratingValue,
                        trenerId: trainer.trenerId);
                    await _ocjeneProvider.insert(ocjena);
                    _showAlertDialog("Ocjena spremljena",
                        "Uspješno ocijenjen trener.", Colors.green);
                    _loadData();
                    _fetchAvailableTrainers();
                  } catch (e) {
                    _showAlertDialog("Greška", e.toString(), Colors.red);
                  }
                } else {
                  _showAlertDialog("Greška",
                      "Molimo unesite ocjenu između 1 i 5.", Colors.red);
                }
              },
              child: const Text('Potvrdi'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfServiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  child: Text(
                    'Pravila korištenja',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Text(
                        '1. Novosti',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'U sklopu "home" sekcije možete vidjeti novosti vezane za treninge koje ste prethodno rezervisali, te opšte novosti. \nPoželjno je da se izjasnite o dolasku na trening u adekvatno vrijeme kako bi treneri mogli pripremiti svu potrebnu opremu. \nSvoj dolazak možete potvrditi lajkanjem određene novosti. ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        '2. Rezervacije',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'U isto vrijeme možete imati maksimalno ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: '3 aktivne',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            TextSpan(
                              text:
                                  ' rezervacije. \nU sklopu tih rezervacija morate odabrati različite vrste treninga, dok se članarine mogu ponavljati. \nTermini koji se prikazuju odnose se na trening koji ste prethodno odabrali sa dropdown-a.\nAko je neki od termina prekrižen (X), to znači da su sva mjesta već rezervisana. \nNa jednom terminu mogu biti članovi sa različitim vrstama članarine. \nUkoliko ste odabrali dnevnu članarinu onda ćete moći rezervisati ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'samo jedan termin',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                ),
                                TextSpan(
                                  text:
                                      ' od ponuđenih. \nAko ste odabrali bilo koju drugu članarinu onda ćete morati rezervisati ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '2-5 termina',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' od ponuđenih. \nKada se radi o dnevnoj članarini, taj termin možete rezervisati ako je po rasporedu sutra jer ova članarina vrijedi 24h. \nSedmičnu članarinu možete rezervisati bilo kada, ali ona se odnosi na period koji traje 7 dana od datuma kreiranja rezervacije i ističe kada prođe taj period. \nMjesečnu članarinu možete rezervisati bilo kada, a odnosi se na narednih 30 dana od datuma kreiranja rezervacije. \nRezervacija kada istekne prelazi u arhivu, te se oslobađa po jedno mjesto na tim terminima.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        '3. Akcije',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Ako se neki od rezervisanih treninga nalazi na akciji, za iznos (%) će se umanjiti ukupna cijena. Također, ako se trening nalazi na više akcija, sve će biti uračunato u konačnu cijenu. Da li je trening na akciji možete provjeriti pod sekcijom "Treninzi", te nakon što odaberete jedan od njih, akcije (ako postoje), će se prikazati.  ',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 248, 248, 248)),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(String naslov, String poruka, Color boja) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 238, 247, 255),
        title: Text(
          naslov,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: boja,
          ),
        ),
        content: Text(
          poruka,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              primary: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            child: const Text("OK"),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
