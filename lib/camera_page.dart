import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tp9/image_view_page.dart';
import 'package:tp9/main.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int indexCam;
  const CameraPage({
    super.key,
    required this.cameras,
    required this.indexCam,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late XFile? imageFile;
  bool isBackCamera = true;
  int otherCamera = 1;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initializeCamera() {
    if (cameras[widget.indexCam].lensDirection == CameraLensDirection.front) {
      otherCamera = 0;
    }
    controller = CameraController(
      isBackCamera ? cameras[widget.indexCam] : cameras[otherCamera],
      ResolutionPreset.max,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access');
            break;
          default:
            print('Camera error: ${e.description}');
            break;
        }
      }
    });
  }

  void _switchCamera() async {
    await controller.dispose();

    setState(() {
      isBackCamera = !isBackCamera;
    });

    _initializeCamera();
  }

  void _takePicture() async {
    try {
      final XFile picture = await controller.takePicture();
      setState(() {
        imageFile = picture;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageViewPage(imagePath: imageFile!.path),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Astro Camera',
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                )),
            actions: [
              IconButton(
                icon: const Icon(Icons.switch_camera),
                onPressed: _switchCamera,
              ),
            ],
          ),
          body: Center(child: CameraPreview(controller)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _takePicture();
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            child: const Icon(Icons.camera),
          ),
        ),
      ),
    );
  }
}
