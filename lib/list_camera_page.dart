import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tp9/camera_page.dart';
import 'package:tp9/main.dart';

class ListCameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ListCameraPage({super.key, required this.cameras});

  @override
  State<ListCameraPage> createState() => _ListCameraPageState();
}

class _ListCameraPageState extends State<ListCameraPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'List Camera',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: cameras.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CameraPage(
                              cameras: cameras,
                              indexCam: index,
                            )),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Camera name : ${cameras[index].name}',
                      style: const TextStyle(color: Colors.blue, fontSize: 24),
                    ),
                    Text(
                      'Sensor orientation : ${cameras[index].sensorOrientation}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
