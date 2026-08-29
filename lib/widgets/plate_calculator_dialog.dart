import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

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

  Map<double, bool> _inventoryKg = {
    25.0: true,
    20.0: true,
    15.0: true,
    10.0: true,
    5.0: true,
    2.5: true,
    1.25: true,
  };

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
    final savedKg = prefs.getString('trainer_plate_inventory_kg');
    if (savedKg != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedKg);
      setState(() {
        _inventoryKg = decoded.map(
          (key, value) => MapEntry(double.parse(key), value as bool),
        );
      });
    }
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
          () => _errorMsg = "Mínimo $_barWeight${_useLbs ? 'lbs' : 'kg'}",
        );
      }
      return;
    }

    double weightToLoad = target - _barWeight;
    double perSide = weightToLoad / 2;

    final currentInventory = _useLbs ? _inventoryLbs : _inventoryKg;

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
    final palette = getPalette(AppTheme.deepSlate);

    return AlertDialog(
      backgroundColor: palette.cardBg,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Calculadora",
            style: AppleDesignSystem.headline.copyWith(
              color: palette.textPrimary,
            ),
          ),
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: palette.fill,
              borderRadius: BorderRadius.circular(AppleDesignSystem.radiusS),
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
            if (_calculatedPlates.isNotEmpty)
              Container(
                height: 120,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: palette.fillSecondary,
                  borderRadius: BorderRadius.circular(AppleDesignSystem.radiusM),
                ),
                child: CustomPaint(
                  painter: BarbellPainter(
                    plates: _calculatedPlates,
                    accentColor: widget.accentColor,
                    isLbs: _useLbs,
                  ),
                ),
              ),
            Text(
              "Inventario (${_useLbs ? 'Lbs' : 'Kg'}):",
              style: AppleDesignSystem.caption1.copyWith(
                color: palette.textTertiary,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: currentInventory.keys.map((weight) {
                bool active = currentInventory[weight]!;
                return GestureDetector(
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
                  child: AnimatedContainer(
                    duration: AppleDesignSystem.animFast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? widget.accentColor.withValues(alpha: 0.15)
                          : palette.fill,
                      borderRadius: BorderRadius.circular(
                        AppleDesignSystem.radiusXS,
                      ),
                    ),
                    child: Text(
                      _formatNum(weight),
                      style: AppleDesignSystem.caption1.copyWith(
                        color: active
                            ? widget.accentColor
                            : palette.textTertiary,
                        fontWeight:
                            active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: AppleDesignSystem.headline.copyWith(
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
              decoration: AppleComponents.inputDecoration(
                palette: palette,
                hintText: "Peso Objetivo",
              ).copyWith(
                suffixText: _useLbs ? "lbs" : "kg",
                suffixStyle: AppleDesignSystem.caption1.copyWith(
                  color: palette.textTertiary,
                ),
              ),
              onChanged: (v) => _calculatePlates(),
            ),
            if (_errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _errorMsg,
                  style: AppleDesignSystem.caption1.copyWith(
                    color: palette.error,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (_calculatedPlates.isNotEmpty) _buildGroupedBoxes(),
            if (_calculatedPlates.isEmpty)
              Center(
                child: Text(
                  "Solo barra",
                  style: AppleDesignSystem.caption1.copyWith(
                    color: palette.textTertiary,
                  ),
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
    final palette = getPalette(AppTheme.deepSlate);
    return GestureDetector(
      onTap: () {
        setState(() {
          _useLbs = text == "LBS";
          _calculatePlates();
        });
      },
      child: AnimatedContainer(
        duration: AppleDesignSystem.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? widget.accentColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppleDesignSystem.radiusXS),
        ),
        child: Text(
          text,
          style: AppleDesignSystem.caption3.copyWith(
            color: active ? widget.accentColor : palette.textQuaternary,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedBoxes() {
    final palette = getPalette(AppTheme.deepSlate);
    Map<double, int> counts = {};
    for (var p in _calculatedPlates) {
      counts[p] = (counts[p] ?? 0) + 1;
    }
    List<double> keys = counts.keys.toList()..sort((a, b) => b.compareTo(a));

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: keys.map((weight) {
        int count = counts[weight]!;
        Color color = Colors.grey;
        if (_useLbs) {
          if (weight >= 45) {
            color = const Color(0xFF0A84FF);
          } else if (weight >= 35) {
            color = palette.warning;
          } else if (weight >= 25) {
            color = palette.textPrimary;
          } else if (weight >= 10) {
            color = palette.textPrimary;
          }
        } else {
          if (weight >= 25) {
            color = palette.error;
          } else if (weight >= 20) {
            color = const Color(0xFF0A84FF);
          } else if (weight >= 15) {
            color = palette.warning;
          } else if (weight >= 10) {
            color = palette.success;
          }
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: palette.fillSecondary,
                borderRadius: BorderRadius.circular(AppleDesignSystem.radiusS),
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: widget.getPlateVisual(weight),
            ),
            const SizedBox(height: 4),
            Text(
              _formatNum(weight),
              style: AppleDesignSystem.subheadline.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "x $count",
              style: AppleDesignSystem.caption1.copyWith(
                color: palette.textTertiary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatNum(double n) {
    if (n % 1 == 0) {
      return n.toInt().toString();
    }
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
    final Paint barPaint = Paint()..color = const Color(0xFF636366);
    final double centerY = size.height / 2;
    final double barHeight = 12.0;

    canvas.drawRect(
      Rect.fromLTWH(0, centerY - barHeight / 2, size.width, barHeight),
      barPaint,
    );

    final double collarWidth = 10;
    final double collarHeight = 28;
    canvas.drawRect(
      Rect.fromLTWH(10, centerY - collarHeight / 2, collarWidth, collarHeight),
      Paint()..color = const Color(0xFF48484A),
    );

    double currentX = 10 + collarWidth + 2;

    for (double p in plates) {
      double pHeight = 40;
      Color pColor = accentColor;

      if (isLbs) {
        if (p >= 45) {
          pHeight = 90;
          pColor = const Color(0xFF0A84FF);
        } else if (p >= 35) {
          pHeight = 80;
          pColor = const Color(0xFFFFD60A);
        } else if (p >= 25) {
          pHeight = 70;
          pColor = const Color(0xFF30D158);
        } else if (p >= 10) {
          pHeight = 50;
          pColor = const Color(0xFFE5E5EA);
        } else {
          pHeight = 35;
          pColor = const Color(0xFF8E8E93);
        }
      } else {
        if (p >= 25) {
          pHeight = 90;
          pColor = const Color(0xFFFF453A);
        } else if (p >= 20) {
          pHeight = 85;
          pColor = const Color(0xFF0A84FF);
        } else if (p >= 15) {
          pHeight = 75;
          pColor = const Color(0xFFFFD60A);
        } else if (p >= 10) {
          pHeight = 65;
          pColor = const Color(0xFF30D158);
        } else if (p >= 5) {
          pHeight = 50;
          pColor = const Color(0xFFE5E5EA);
        } else {
          pHeight = 35;
          pColor = const Color(0xFF8E8E93);
        }
      }

      double pWidth = 14;

      canvas.drawRect(
        Rect.fromLTWH(currentX, centerY - pHeight / 2, pWidth, pHeight),
        Paint()..color = pColor,
      );

      canvas.drawRect(
        Rect.fromLTWH(currentX, centerY - pHeight / 2, pWidth, pHeight),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      currentX += pWidth + 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
