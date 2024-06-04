import 'dart:io';
import 'dart:developer';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'dart:convert' show json, utf8;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSnackbar(BuildContext context, String message, [int? time]) {
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.all(12),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: time ?? 3),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<File?> storeText(String fileName, String text, String folder, Directory directory) async {
  Uint8List fileBytes = Uint8List.fromList(utf8.encode(text));
  File? storedFile = await storeFile(fileBytes, '${fileName.split('.').first}.txt', folder, directory);
  return storedFile;
}

Future<String?> createFolder(String folderName, Directory directory) async {
  final Directory folder = Directory('${directory.path}/$folderName/');

  try {
    if (await folder.exists()) {
      return folder.path;
    } else {
      final Directory newFolder = await folder.create(recursive: true);
      return newFolder.path;
    }
  } catch (error) {
    log('Error creating folder: $error');
    return null;
  }
}

Future<File?> storeFile(Uint8List fileBytes, String fileName, String folder, Directory directory) async {
  await createFolder(folder, directory);
  String filePath = '${directory.path}/$folder/$fileName';
  File newFile = File(filePath);

  try {
    await newFile.writeAsBytes(fileBytes);
    log('File was stored successfully at: [$filePath]');
    return newFile;
  } catch (error) {
    log('Error storing file: $error');
    return null;
  }
}

Future<bool?> deleteFile(String fileName, String folder, Directory directory) async {
  String filePath = '${directory.path}/$folder/$fileName';
  File fileToDelete = File(filePath);

  try {
    if (await fileToDelete.exists()) {
      await fileToDelete.delete();
      log('File [$fileName] deleted successfully from: [$filePath]');
      return true;
    } else {
      log('File [$fileName] does not exist');
      return null;
    }
  } catch (error) {
    log('Error deleting file: $error');
    return false;
  }
}

Future<File?> moveFile(String fileName, String sourceFolder, String destinationFolder, Directory directory) async {
  // Create source and destination folder paths
  String sourcePath = '${directory.path}/$sourceFolder/$fileName';
  String destinationPath = '${directory.path}/$destinationFolder/$fileName';

  // Create a File instance for the source file
  File sourceFile = File(sourcePath);

  try {
    // Check if the source file exists
    if (await sourceFile.exists()) {

      // Ensure the destination folder exists
      await createFolder(destinationFolder, directory);

      // Construct a File instance for the destination file
      File destinationFile = File(destinationPath);

      // Perform the file move by renaming the file
      await sourceFile.rename(destinationPath);

      log('File moved successfully');
      return destinationFile;
    } else {
      log('Source file does not exist');
      return null;
    }
  } catch (error) {
    log('Error moving file: $error');
    return null;
  }
}

Future<List<File>?> getDirectoryFiles(String folder, Directory directory, [String? extension]) async {
  try {
    String folderPath = '${directory.path}/$folder/';
    Directory targetFolder = Directory(folderPath);

    // Check if the target folder exists
    if (await targetFolder.exists()) {
      List<File> files = [];

      // List all files in the folder
      List<FileSystemEntity> entities = targetFolder.listSync(recursive: true, followLinks: false);

      // Iterate through each file and filter by extension
      for (var entity in entities) {
        if (entity is File) {
          if (extension != null) {
            // Check if the file has the specified extension
            if (entity.path.endsWith('.$extension')) {
              files.add(entity);
            }
          } else {
            // If no extension specified, include all files
            files.add(entity);
          }
        }
      }

      return files;
    } else {
      log('Folder [${targetFolder.path}] does not exist');
      return null;
    }
  } catch (error) {
    log('Error retrieving files: $error');
    return null;
  }
}

Future<List<String>?> getDirectoryFileNames(String folder, Directory directory, [String? extension]) async {
  try {
    String folderPath = '${directory.path}/$folder/';
    Directory targetFolder = Directory(folderPath);

    // Check if the target folder exists
    if (await targetFolder.exists()) {
      List<String> fileNames = [];

      // List all files in the folder
      List<FileSystemEntity> entities = targetFolder.listSync(recursive: true, followLinks: false);

      // Iterate through each file and filter by extension
      for (var entity in entities) {
        if (entity is File) {
          if (extension != null) {
            // Check if the file has the specified extension
            if (entity.path.endsWith('.$extension')) {
              fileNames.add(entity.path.split('/').last);
            }
          } else {
            // If no extension specified, include all files
            fileNames.add(entity.path.split('/').last);
          }
        }
      }

      return fileNames;
    } else {
      log('Folder [${targetFolder.path}] does not exist');
      return null;
    }
  } catch (error) {
    log('Error retrieving files: $error');
    return null;
  }
}

double getTotalHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getTotalWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void showInFullScreen(String imagePath, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenImage(imagePath: imagePath),
    ),
  );
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({
    Key? key,
    required this.imagePath
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imagePath,
            child: PhotoView(
              imageProvider: FileImage(File(imagePath)),
              enableRotation: true,
              tightMode: true,
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}

class SafeMenuButton extends StatefulWidget {
  final String defaultItem;
  final List<String> items;
  final Function(String)? onChanged;
  final String recoveryKey;

  const SafeMenuButton({
    Key? key,
    required this.defaultItem,
    required this.items,
    this.onChanged,
    required this.recoveryKey,
  }) : super(key: key);

  @override
  SafeMenuButtonState createState() => SafeMenuButtonState();
}

class SafeMenuButtonState extends State<SafeMenuButton> {
  late String selectedItem;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadSelectedItem();
  }

  Future<void> _loadSelectedItem() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedItem = prefs.getString(widget.recoveryKey) ?? widget.defaultItem;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
    ? const CircularProgressIndicator() // Show a loading indicator while loading from SharedPreferences
    : ElevatedButton(
      style: selectedItem == widget.defaultItem
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            )
          : null,
      onPressed: () {
        _showDropdownMenu(context);
      },
      child: Text(selectedItem),
    );
  }

  void _showDropdownMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.items[index]),
                onTap: () {
                  _updateSelectedItem(widget.items[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _updateSelectedItem(String newItem) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.recoveryKey, newItem);
    setState(() {
      selectedItem = newItem;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(selectedItem);
    }
  }
}


class SmartCheckboxListTile extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool?>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final bool isThreeLine;
  final bool dense;
  final Widget? secondary;
  final bool selected;
  final Color? activeColor;
  final Color? checkColor;
  final ListTileControlAffinity controlAffinity;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;

  SmartCheckboxListTile({
    Key? key,
    this.initialValue = false,
    this.onChanged,
    required this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense = false,
    this.secondary,
    this.selected = false,
    this.activeColor,
    this.checkColor,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
  }) : super(key: key);

  @override
  _SmartCheckboxListTileState createState() => _SmartCheckboxListTileState();
}

class _SmartCheckboxListTileState extends State<SmartCheckboxListTile> {
  bool check = false;

  @override
  void initState() {
    super.initState();
    check = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: check,
      onChanged: (bool? value) {
        setState(() {
          check = value ?? false;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      title: widget.title,
      subtitle: widget.subtitle,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      secondary: widget.secondary,
      selected: widget.selected,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      controlAffinity: widget.controlAffinity,
      autofocus: widget.autofocus,
      contentPadding: widget.contentPadding,
      shape: widget.shape,
      tileColor: widget.tileColor,
      selectedTileColor: widget.selectedTileColor,
    );
  }
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  //return 0925 for 9h25m
  return '${timeOfDay.hour.toString().padLeft(2, '0')}${timeOfDay.minute.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dateTime) {
  //return 092532 for 9h25m32s
  return '${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
}

String formatTimeOfDayAlt(TimeOfDay timeOfDay) {
  //return 09h25m
  return '${timeOfDay.hour.toString().padLeft(2, '0')}h${timeOfDay.minute.toString().padLeft(2, '0')}m';
}

String formatDateTimeAlt(DateTime dateTime) {
  //return 09h25m32s
  return '${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}m${dateTime.second.toString().padLeft(2, '0')}s';
}

Future<void> requestPermissions() async {
  await requestPermission(Permission.storage);
  await requestPermission(Permission.manageExternalStorage);
  await requestPermission(Permission.mediaLibrary);
  await requestPermission(Permission.camera);
  await requestPermission(Permission.photos);
}

Future<void> requestPermission(Permission permission) async {
  if (!await permission.status.isGranted) {
    await permission.request();
  }
}

MaterialColor orangeColor = MaterialColor(
  0xFFf07f34,
  <int, Color>{
    50: Colors.orange[50]!,
    100: Colors.orange[100]!,
    200: Colors.orange[200]!,
    300: Colors.orange[300]!,
    400: Colors.orange[400]!,
    500: Colors.orange[500]!,
    600: Colors.orange[600]!,
    700: Colors.orange[700]!,
    800: Colors.orange[800]!,
    900: Colors.orange[900]!,
  },
);

class CameraPage extends StatefulWidget {
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  bool isCameraInitialized = false;
  Uint8List? fileBytes;
  bool isFlashOn = false;
  int selectedCameraIndex = 0;
  double currentZoomLevel = 1.0;
  double maxZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.high,
      );

      initializeControllerFuture = cameraController.initialize();
      await initializeControllerFuture;

      // Get the maximum zoom level
      maxZoomLevel = await cameraController.getMaxZoomLevel();

      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      log('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !isCameraInitialized
          ? const CircularProgressIndicator()
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (fileBytes == null)
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            handleScaleUpdate(details);
                          },
                          child: CameraPreview(cameraController),
                        ),
                      ),

                    if (fileBytes == null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFlashOn = !isFlashOn;
                                  });
                                },
                                child: Icon(
                                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (fileBytes == null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: selectFromGallery,
                                child: const Icon(
                                  Icons.photo_library,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: takePicture,
                                child: const Icon(
                                  Icons.camera_outlined,
                                  size: 70,
                                  color: Colors.orange,
                                ),
                              ),
                              GestureDetector(
                                onTap: switchCamera,
                                child: const Icon(
                                  Icons.switch_camera,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (fileBytes != null)
                      Center(
                        child: Hero(
                          tag: fileBytes.toString(),
                          child: PhotoView(
                            imageProvider: Image.memory(fileBytes!).image,
                            enableRotation: true,
                            tightMode: true,
                            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                          ),
                        ),
                      ),

                    if (fileBytes != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: discardPhoto,
                                child: const Icon(
                                  CupertinoIcons.clear_circled,
                                  size: 70,
                                  color: Colors.redAccent,
                                ),
                              ),
                              GestureDetector(
                                onTap: confirmPhoto,
                                child: const Icon(
                                  CupertinoIcons.check_mark_circled,
                                  size: 70,
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Future<void> takePicture() async {
    if (isFlashOn) {
      cameraController.setFlashMode(FlashMode.torch);
    }

    try {
      await initializeControllerFuture;
      final XFile image = await cameraController.takePicture();
      File file = File(image.path);
      Uint8List fileData = await file.readAsBytes();

      setState(() {
        fileBytes = fileData;
      });
    } catch (e) {
      log('Error taking picture: $e');
    }

    if (isFlashOn) {
      cameraController.setFlashMode(FlashMode.off);
    }
  }

  void discardPhoto() {
    if (mounted) {
      setState(() {
        fileBytes = null;
      });
    }
  }

  void confirmPhoto() {
    Navigator.pop(context, fileBytes);
  }

  void switchCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await initializeCamera();
  }

  Future<void> selectFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        PlatformFile pickedFile = result.files.first;
        Uint8List fileData;

        if (pickedFile.bytes != null) {
          fileData = pickedFile.bytes!;
        } else {
          File file = File(pickedFile.path!);
          fileData = await file.readAsBytes();
        }

        setState(() {
          fileBytes = fileData;
        });
      } else {
        log('No file selected');
      }
    } catch (e) {
      log('Error selecting from gallery: $e');
    }
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    double sensitivityFactor = 0.05; // Adjust this value to control sensitivity
    double newZoomLevel = currentZoomLevel + (details.scale - 1.0) * sensitivityFactor;

    if (newZoomLevel < 1.0) {
      newZoomLevel = 1.0;
    } else if (newZoomLevel > maxZoomLevel) {
      newZoomLevel = maxZoomLevel;
    }

    setState(() {
      currentZoomLevel = newZoomLevel;
      cameraController.setZoomLevel(currentZoomLevel);
    });
  }
}

Future<Uint8List?> takePhoto(BuildContext context) async {
  final Uint8List? fileBytes = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraPage()),
  );

  return fileBytes;
}

Future<bool> takePhotoAndStore(BuildContext context, String prefix, String folder, Directory directory) async {
  final Uint8List? fileBytes = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraPage()),
  );

  if (fileBytes != null) {
    File? storedFile = await storeFile(fileBytes, '${prefix}_IMG_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.jpg', folder, directory);
    if (storedFile != null) {
      showSnackbar(context, 'Foto armazenada com sucesso');
      return true;
    }
  }

  return false;
}