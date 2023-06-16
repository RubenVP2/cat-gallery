import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../model/Cat.dart';
import '../service/cat_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextStyle textStyle = const TextStyle(fontFamily: 'FiraCode');
  late Future<Cat> futureCat;

  void _loadCatImage() {
    futureCat = CatApi().fetchCatImage();
  }

  void _saveImage() async {
    final cat = await futureCat;
    final url = cat.url;

    final response = await CatApi().fetchBytes(url);
    await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "cat_image_$url",
    );
  }


  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _buildData(String url) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(url)
          )
      ),
    );
  }

  Widget _buildError(String error) {
    return Text(error);
  }

  Widget _buildNoData() {
    return const Center(
      child: Text('No data found.'),
    );
  }

  AwesomeDialog _buildPopUpSuccess(BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.rightSlide,
      dialogType: DialogType.success,
      title: 'Succès',
      desc: 'Téléchargement réussi !',
      autoHide: const Duration(seconds: 2),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
      )..show();
  }

  AwesomeDialog _buildPopUpLike(BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      dialogType: DialogType.success,
      title: 'Succès',
      desc: 'Ajouté aux favoris !',
      autoHide: const Duration(seconds: 2),
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    )..show();
  }

  @override
  void initState() {
    super.initState();
    _
    _loadCatImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 15,
            child: Image.asset('assets/cat_logo.png')
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.green,
                    Colors.greenAccent
                  ])
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: FutureBuilder<Cat>(
                        future: futureCat,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return _buildLoader();
                          } else if (snapshot.hasData) {
                            return _buildData(snapshot.data!.url);
                          } else if (snapshot.hasError) {
                            return _buildError('${snapshot.error}');
                          }
                          // Handle no data
                          return _buildNoData();
                        },
                      )
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.favorite),
                    onPressed: () {
                      setState(() {
                        // Permet de télécharger l'image
                        try {
                          _buildPopUpLike(context);
                        } on Exception catch (_) {
                          rethrow;
                        }
                      });
                    },
                  ),
                  FloatingActionButton.large(
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      // Récupère une nouvelle Image
                      setState(() {
                        // Réinitialise le CatPicture() state pour avoir une nouvelle image
                        _loadCatImage();
                      });
                    },
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.download),
                    onPressed: () {
                      setState(() {
                        // Permet de télécharger l'image
                        try {
                          _saveImage();
                          _buildPopUpSuccess(context);
                        } on Exception catch (_) {
                          rethrow;
                        }
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
