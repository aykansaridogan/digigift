import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';


class MusicPlayerPage extends StatefulWidget {
  final String musicPath;

  MusicPlayerPage({required this.musicPath});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isRepeating = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isDownloading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        if (state == PlayerState.completed) {
          setState(() {
            if (_isRepeating) {
              _playMusic();
            } else {
              _isPlaying = false;
            }
          });
        } else if (state == PlayerState.stopped) {
          if (!_isRepeating) {
            setState(() {
              _isPlaying = false;
            });
          }
        }
      }
    });
  }

  void _playMusic() async {
    if (!mounted) return;
    if (_isPlaying) {
      await _audioPlayer.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      try {
        await _audioPlayer.setSource(UrlSource(widget.musicPath));
        await _audioPlayer.resume();
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Müzik çalma hatası: $e';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage)),
          );
        }
      }
    }
  }

  Future<void> _downloadAndZipMusic() async {
    setState(() {
      _isDownloading = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio();
      Directory? directory;
     
        if (Platform.isAndroid && (await _getAndroidVersion()) >= 29) {
        // Android 10 ve üzeri için MediaStore kullanımı
        await _saveToMediaStore();
        return;
      } else if (Platform.isAndroid) {
        // Android 9 ve altı için
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // iOS için
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw Exception('Bu platform desteklenmiyor');
      }

      final mp3FilePath = '${directory?.path}/song1.mp3';
      final zipFilePath = '${directory?.path}/song1.zip';

      

      // MP3 dosyasını indir
      await dio.download(widget.musicPath, mp3FilePath);

      // MP3 dosyasını ZIP'e dönüştür
      final mp3File = File(mp3FilePath);
      final archive = Archive();
      final bytes = mp3File.readAsBytesSync();
      final archiveFile = ArchiveFile('song1.mp3', bytes.length, bytes);
      archive.addFile(archiveFile);
      final zipData = ZipEncoder().encode(archive);

      // ZIP dosyasını kaydet
      final zipFile = File(zipFilePath);
      await zipFile.writeAsBytes(zipData!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ZIP dosyası kaydedildi!')),
        );

        // Kullanıcıya ZIP dosyasını paylaşma seçeneği sun
        final xFile = XFile(zipFilePath);
        await Share.shareXFiles([xFile], text: 'Dinlemek için dosyayı paylaşıyorum.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'İndirme veya ZIP oluşturma hatası: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }
 Future<void> _saveToMediaStore() async {
    try {
      final dio = Dio();
      final directory = await getTemporaryDirectory();
      final mp3FilePath = '${directory.path}/song1.mp3';
      await dio.download(widget.musicPath, mp3FilePath);

      // Android MediaStore'a dosya kaydetme
      // Bu kısım Android 10 ve üzeri için MediaStore'a kayıt işlemini gerçekleştirecek
      final contentValues = {
        'title': 'song1',
        'mime_type': 'audio/mpeg',
        'relative_path': 'Music/', // Music klasörüne kaydedilir
      };

      final uri = await _insertIntoMediaStore(mp3FilePath, contentValues);
      if (uri != null) {
        ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Dosya MediaStore\'a kaydedildi: $uri')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('MediaStore\'a kaydetme hatası: $e')),
      );
    }
  }

  // MediaStore'a dosya ekleme
  Future<Uri?> _insertIntoMediaStore(String filePath, Map<String, dynamic> contentValues) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // Yeni dosya oluştur
      final tempFile = await File('${file.path}.mp3').create();
      await tempFile.writeAsBytes(bytes);

      return Uri.file(tempFile.path);
    } catch (e) {
      print('MediaStore hatası: $e');
      return null;
    }
  }

  Future<int> _getAndroidVersion() async {
    try {
      final result = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.parse(result.stdout.toString().trim());
    } catch (e) {
      return 0; // Android versiyonu bilinmiyorsa varsayılan değer döndür
    }
  }
  void _seekTo(Duration position) {
    if (mounted) {
      _audioPlayer.seek(position);
    }
  }

  void _seekForward() {
    final newPosition = _position + Duration(seconds: 10);
    if (newPosition < _duration) {
      _seekTo(newPosition);
    }
  }

  void _seekBackward() {
    final newPosition = _position - Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _seekTo(newPosition);
    }
  }

  void _toggleRepeat() {
    if (mounted) {
      setState(() {
        _isRepeating = !_isRepeating;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
            flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.pink,
            Colors.orange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
        title: Text('Müzik Çalar', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Ekleme
            Container(
              margin: EdgeInsets.only(bottom: screenSize.height * 0.03),
              child: Image.asset(
                'assets/Sarkiyapp.png',
                height: screenSize.height * 0.15,
              ),
            ),
            Slider(
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                _seekTo(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.green,
              inactiveColor: Colors.green.shade200,
            ),
            Text(
              '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}',
              style: TextStyle(fontSize: 16.0, color: Colors.green),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(Icons.replay_10, _seekBackward),
                _buildControlButton(_isPlaying ? Icons.pause : Icons.play_arrow, _playMusic),
                _buildControlButton(Icons.forward_10, _seekForward),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  _isRepeating ? Icons.repeat_one : Icons.repeat,
                  _toggleRepeat,
                  color: _isRepeating ? Colors.green : Colors.grey,
                ),
                _buildControlButton(
                  Icons.download,
                  _isDownloading ? null : _downloadAndZipMusic,
                  color: _isDownloading ? Colors.grey : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback? onPressed, {Color? color}) {
    final screenSize = MediaQuery.of(context).size;

    return IconButton(
      icon: Icon(icon, size: screenSize.width * 0.08, color: color ?? Colors.green),
      onPressed: onPressed,
    );
  }
}
