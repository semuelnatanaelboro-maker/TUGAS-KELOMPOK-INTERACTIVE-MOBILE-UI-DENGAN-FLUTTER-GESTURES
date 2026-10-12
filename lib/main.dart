import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Solar Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SolarDashboardScreen(),
    );
  }
}

class SolarDashboardScreen extends StatefulWidget {
  const SolarDashboardScreen({super.key});

  @override
  State<SolarDashboardScreen> createState() => _SolarDashboardScreenState();
}

class _SolarDashboardScreenState extends State<SolarDashboardScreen> {

  bool isBookmarked = false;

  double scaleFactor = 1.0;
  double baseScaleFactor = 1.0;

  double dragOffset = 0.0;
  bool isCardDismissed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Energy Monitor (SDG 7)'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              '1. Swipe / Horizontal Drag (Dismiss Notifikasi)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (!isCardDismissed)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    dragOffset += details.delta.dx;
                  });
                },
                onHorizontalDragEnd: (details) {
                  if (dragOffset.abs() > 100) {
                    setState(() {
                      isCardDismissed = true;
                    });
                  } else {
                    setState(() {
                      dragOffset = 0.0;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(dragOffset, 0),
                  child: Card(
                    color: Colors.amber.shade100,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Peringatan: Geser (Swipe) kartu ini ke kanan/kiri untuk menghilangkan notifikasi efisiensi.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isCardDismissed = false;
                    dragOffset = 0.0;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tampilkan Kembali Notifikasi'),
              ),

            const SizedBox(height: 24),

            const Text(
              '2. Double Tap Gesture (Simpan Kartu Favorit)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
              },
              child: Card(
                elevation: 4,
                color: isBookmarked ? Colors.green.shade50 : Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isBookmarked ? Colors.green : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Daya Terhasilkan',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '14.5 kWh',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isBookmarked
                                ? 'Disimpan di Favorit'
                                : 'Ketuk 2x (Double Tap) untuk Bookmark',
                            style: TextStyle(
                              fontSize: 11,
                              color: isBookmarked ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.green : Colors.grey,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '3. Scale / Pinch Gesture (Zoom In/Out Grafik/Panel)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                baseScaleFactor = scaleFactor;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  scaleFactor = (baseScaleFactor * details.scale).clamp(0.8, 2.0);
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Skala Zoom: ${(scaleFactor * 100).toStringAsFixed(0)}% (Cubit Layar / Gunakan Tombol)',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 12),

                    ClipRect(
                      child: Transform.scale(
                        scale: scaleFactor,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar(40, Colors.orange),
                                  _buildBar(70, Colors.orange),
                                  _buildBar(90, Colors.green),
                                  _buildBar(60, Colors.orange),
                                  _buildBar(30, Colors.red),
                                ],
                              ),
                              const Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  'Grafik Output Inverter',
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () {
                            setState(() {
                              scaleFactor = (scaleFactor - 0.2).clamp(0.8, 2.0);
                            });
                          },
                          icon: const Icon(Icons.zoom_out),
                          tooltip: 'Zoom Out',
                        ),
                        const SizedBox(width: 16),
                        IconButton.filledTonal(
                          onPressed: () {
                            setState(() {
                              scaleFactor = (scaleFactor + 0.2).clamp(0.8, 2.0);
                            });
                          },
                          icon: const Icon(Icons.zoom_in),
                          tooltip: 'Zoom In',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    );
  }
}