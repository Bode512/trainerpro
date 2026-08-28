import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlateCalculatorDialog extends StatefulWidget {
  final Color accentColor;
  final Color cardColor;
  final Widget Function(double) getPlateVisual;

  const PlateCalculatorDialog({
    super.key,
    required this.accentColor,
    required this.cardColor,
    required this.getPlateVisual,
  });

  @override
  State<PlateCalculatorDialog> createState() => _PlateCalculatorDialogState();
}

class _PlateCalculatorDialogState extends State<PlateCalculatorDialog> {
  final TextEditingController _weightCtrl = TextEditingController();
  List<double> _calculatedPlates = [];
  double _barWeight = 20.0;
  String _errorMsg = "";

  bool _useLbs = false;

  // Kg Inventory
  Map<double, bool> _inventoryKg = {
    25.0: true,
    20.0: true,
    15.0: true,
    10.0: true,
    5.0: true,
    2.5: true,
    1.25: true,
  };

  // Lbs Inventory
  Map<double, bool> _inventoryLbs = {
    45.0: true,
    35.0: true,
    25.0: true,
    10.0: true,
    5.0: true,
    2.5: true,
  };

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    // Load Kg
    final savedKg = prefs.getString('trainer_plate_inventory_kg');
    if (savedKg != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedKg);
      setState(() {
        _inventoryKg = decoded.map(
          (key, value) => MapEntry(double.parse(key), value as bool),
        );
      });
    }
    // Load Lbs
    final savedLbs = prefs.getString('trainer_plate_inventory_lbs');
    if (savedLbs != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedLbs);
      setState(() {
        _inventoryLbs = decoded.map(
          (key, value) => MapEntry(double.parse(key), value as bool),
        );
      });
    }
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedKg = jsonEncode(
      _inventoryKg.map((key, value) => MapEntry(key.toString(), value)),
    );
    await prefs.setString('trainer_plate_inventory_kg', encodedKg);

    final encodedLbs = jsonEncode(
      _inventoryLbs.map((key, value) => MapEntry(key.toString(), value)),
    );
    await prefs.setString('trainer_plate_inventory_lbs', encodedLbs);
  }

  void _calculatePlates() {
    setState(() {
      _errorMsg = "";
      _calculatedPlates = [];
    });

    double target = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0;
    _barWeight = _useLbs ? 45.0 : 20.0;

    if (target < _barWeight) {
      if (_weightCtrl.text.isNotEmpty) {
        setState(
          () => _errorMsg = "Mínimo ${_barWeight}${_useLbs ? 'lbs' : 'kg'}",
        );
      }
      return;
    }

    double weightToLoad = target - _barWeight;
    double perSide = weightToLoad / 2;

    // Select Inventory
    final currentInventory = _useLbs ? _inventoryLbs : _inventoryKg;

    // Get available plates sorted descending
    List<double> available =
        currentInventory.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList()
          ..sort((a, b) => b.compareTo(a));

    List<double> result = [];

    for (var p in available) {
      while (perSide >= p) {
        result.add(p);
        perSide -= p;
        perSide = double.parse(perSide.toStringAsFixed(2));
      }
    }

    if (perSide > 0) {
      setState(
        () => _errorMsg =
            "Imposible exacto (sobran ${perSide * 2}${_useLbs ? 'lbs' : 'kg'})",
      );
    }

    setState(() {
      _calculatedPlates = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentInventory = _useLbs ? _inventoryLbs : _inventoryKg;

    return AlertDialog(
      backgroundColor: widget.cardColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Calculadora",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          // LBS/KG TOGGLE
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildToggleBtn("KG", !_useLbs),
                _buildToggleBtn("LBS", _useLbs),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // VISUAL BARBELL
            if (_calculatedPlates.isNotEmpty)
              Container(
                height: 120, // Height for the visual
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomPaint(
                  painter: BarbellPainter(
                    plates: _calculatedPlates,
                    accentColor: widget.accentColor,
                    isLbs: _useLbs,
                  ),
                ),
              ),

            // INVENTORY TOGGLES
            Text(
              "Inventario (${_useLbs ? 'Lbs' : 'Kg'}):",
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: currentInventory.keys.map((weight) {
                bool active = currentInventory[weight]!;
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (_useLbs) {
                        _inventoryLbs[weight] = !active;
                      } else {
                        _inventoryKg[weight] = !active;
                      }
                      _saveInventory();
                      _calculatePlates();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? widget.accentColor.withOpacity(0.2)
                          : Colors.black12,
                      border: Border.all(
                        color: active ? widget.accentColor : Colors.white10,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${_formatNum(weight)}",
                      style: TextStyle(
                        fontSize: 10,
                        color: active ? Colors.white : Colors.white38,
                        fontWeight: active
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "Peso Objetivo",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black26,
                suffixText: _useLbs ? "lbs" : "kg",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: widget.accentColor),
                ),
              ),
              onChanged: (v) => _calculatePlates(),
            ),
            if (_errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMsg,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),
            // VISUALIZACIÓN (CAJAS AGRUPADAS - Texto)
            if (_calculatedPlates.isNotEmpty) _buildGroupedBoxes(),
            if (_calculatedPlates.isEmpty)
              const Center(
                child: Text(
                  "Solo barra",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CERRAR"),
        ),
      ],
    );
  }

  Widget _buildToggleBtn(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _useLbs = text == "LBS";
          _calculatePlates();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? widget.accentColor.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: active ? widget.accentColor : Colors.white24,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedBoxes() {
    Map<double, int> counts = {};
    for (var p in _calculatedPlates) {
      counts[p] = (counts[p] ?? 0) + 1;
    }
    // Sort keys descending
    List<double> keys = counts.keys.toList()..sort((a, b) => b.compareTo(a));

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: keys.map((weight) {
        int count = counts[weight]!;
        Color color = Colors.grey;
        if (_useLbs) {
          if (weight >= 45)
            color = Colors.blue;
          else if (weight >= 35)
            color = Colors.yellow;
          else if (weight >= 25)
            color = Colors.green;
          else if (weight >= 10)
            color = Colors.white;
        } else {
          if (weight >= 25)
            color = Colors.red;
          else if (weight >= 20)
            color = Colors.blue;
          else if (weight >= 15)
            color = Colors.yellow;
          else if (weight >= 10)
            color = Colors.green;
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color, width: 2),
              ),
              child: widget.getPlateVisual(
                weight,
              ), // Using the generic visual for reference
            ),
            const SizedBox(height: 4),
            Text(
              "${_formatNum(weight)}",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "x $count",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatNum(double n) {
    if (n % 1 == 0) return n.toInt().toString();
    return n.toString();
  }
}

class BarbellPainter extends CustomPainter {
  final List<double> plates;
  final Color accentColor;
  final bool isLbs;

  BarbellPainter({
    required this.plates,
    required this.accentColor,
    required this.isLbs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint barPaint = Paint()..color = Colors.grey;
    final double centerY = size.height / 2;
    final double barHeight = 15.0;

    // Draw Bar Sleeve (left side only shown for simplicity, or we show one side)
    // Let's show the right side sleeve starting from left
    canvas.drawRect(
      Rect.fromLTWH(0, centerY - barHeight / 2, size.width, barHeight),
      barPaint,
    );

    // Draw Collar
    final double collarWidth = 10;
    final double collarHeight = 30;
    canvas.drawRect(
      Rect.fromLTWH(10, centerY - collarHeight / 2, collarWidth, collarHeight),
      Paint()..color = Colors.grey[700]!,
    );

    double currentX = 10 + collarWidth + 2; // Start after collar

    for (double p in plates) {
      // Determine height and color based on weight
      double pHeight = 40;
      Color pColor = accentColor;

      if (isLbs) {
        if (p >= 45) {
          pHeight = 90;
          pColor = Colors.blue;
        } else if (p >= 35) {
          pHeight = 80;
          pColor = Colors.yellow;
        } else if (p >= 25) {
          pHeight = 70;
          pColor = Colors.green;
        } else if (p >= 10) {
          pHeight = 50;
          pColor = Colors.white;
        } else {
          pHeight = 35;
          pColor = Colors.grey;
        }
      } else {
        if (p >= 25) {
          pHeight = 90;
          pColor = Colors.red;
        } else if (p >= 20) {
          pHeight = 85;
          pColor = Colors.blue;
        } else if (p >= 15) {
          pHeight = 75;
          pColor = Colors.yellow;
        } else if (p >= 10) {
          pHeight = 65;
          pColor = Colors.green;
        } else if (p >= 5) {
          pHeight = 50;
          pColor = Colors.white;
        } else {
          pHeight = 35;
          pColor = Colors.grey;
        }
      }

      double pWidth = 15;

      canvas.drawRect(
        Rect.fromLTWH(currentX, centerY - pHeight / 2, pWidth, pHeight),
        Paint()..color = pColor,
      );

      // Border
      canvas.drawRect(
        Rect.fromLTWH(currentX, centerY - pHeight / 2, pWidth, pHeight),
        Paint()
          ..color = Colors.black45
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      currentX += pWidth + 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
