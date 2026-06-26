import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 94, 135, 238),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FF),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A56DB),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        fontFamily: 'SF Pro Display',
      ),
      themeMode: ThemeMode.system,
      home: const ConverterPage(),
    );
  }
}

// ── Data ─────────────────────────────────────────────────────────────────────

const Map<String, double> kRates = {
  'USD': 1.0,
  'EUR': 0.92,
  'GBP': 0.79,
  'JPY': 157.5,
  'CHF': 0.90,
  'CAD': 1.37,
  'AUD': 1.53,
  'NZD': 1.64,
  'CNY': 7.25,
  'HKD': 7.83,
  'SGD': 1.35,
  'KRW': 1370.0,
  'INR': 83.5,
  'BRL': 5.10,
  'MXN': 17.2,
  'ZAR': 18.6,
  'SEK': 10.6,
  'NOK': 10.7,
  'DKK': 6.88,
  'PLN': 3.95,
  'CZK': 23.2,
  'HUF': 363.0,
  'RON': 4.57,
  'TRY': 32.5,
  'RUB': 90.0,
  'AED': 3.67,
  'SAR': 3.75,
  'QAR': 3.64,
  'ILS': 3.70,
  'EGP': 47.5,
  'NGN': 1450.0,
  'KES': 130.0,
  'GHS': 15.2,
  'MAD': 9.93,
  'THB': 36.5,
  'MYR': 4.72,
  'IDR': 16200.0,
  'PHP': 58.5,
  'VND': 25400.0,
  'TWD': 32.3,
  'PKR': 278.0,
  'BDT': 110.0,
  'LKR': 308.0,
  'NPR': 133.0,
  'CLP': 940.0,
  'COP': 3950.0,
  'PEN': 3.72,
  'ARS': 900.0,
  'UYU': 39.5,
  'DZD': 134.5,
  'TND': 3.12,
  'KWD': 0.307,
  'BHD': 0.377,
  'OMR': 0.385,
  'JOD': 0.709,
  'LBP': 89500.0,
  'CRC': 520.0,
  'GTQ': 7.79,
  'HNL': 24.7,
  'NIO': 36.6,
  'BOB': 6.91,
  'PYG': 7450.0,
  'ISK': 138.0,
  'BGN': 1.80,
  'RSD': 107.5,
  'UAH': 39.8,
  'KZT': 450.0,
  'UZS': 12750.0,
  'GEL': 2.71,
  'AMD': 388.0,
  'AZN': 1.70,
  'MDL': 17.8,
  'BYN': 3.26,
};

const Map<String, String> kNames = {
  'USD': 'US Dollar',
  'EUR': 'Euro',
  'GBP': 'British Pound',
  'JPY': 'Japanese Yen',
  'CHF': 'Swiss Franc',
  'CAD': 'Canadian Dollar',
  'AUD': 'Australian Dollar',
  'NZD': 'New Zealand Dollar',
  'CNY': 'Chinese Yuan',
  'HKD': 'Hong Kong Dollar',
  'SGD': 'Singapore Dollar',
  'KRW': 'South Korean Won',
  'INR': 'Indian Rupee',
  'BRL': 'Brazilian Real',
  'MXN': 'Mexican Peso',
  'ZAR': 'South African Rand',
  'SEK': 'Swedish Krona',
  'NOK': 'Norwegian Krone',
  'DKK': 'Danish Krone',
  'PLN': 'Polish Złoty',
  'CZK': 'Czech Koruna',
  'HUF': 'Hungarian Forint',
  'RON': 'Romanian Leu',
  'TRY': 'Turkish Lira',
  'RUB': 'Russian Ruble',
  'AED': 'UAE Dirham',
  'SAR': 'Saudi Riyal',
  'QAR': 'Qatari Riyal',
  'ILS': 'Israeli Shekel',
  'EGP': 'Egyptian Pound',
  'NGN': 'Nigerian Naira',
  'KES': 'Kenyan Shilling',
  'GHS': 'Ghanaian Cedi',
  'MAD': 'Moroccan Dirham',
  'THB': 'Thai Baht',
  'MYR': 'Malaysian Ringgit',
  'IDR': 'Indonesian Rupiah',
  'PHP': 'Philippine Peso',
  'VND': 'Vietnamese Dong',
  'TWD': 'Taiwan Dollar',
  'PKR': 'Pakistani Rupee',
  'BDT': 'Bangladeshi Taka',
  'LKR': 'Sri Lankan Rupee',
  'NPR': 'Nepalese Rupee',
  'CLP': 'Chilean Peso',
  'COP': 'Colombian Peso',
  'PEN': 'Peruvian Sol',
  'ARS': 'Argentine Peso',
  'UYU': 'Uruguayan Peso',
  'DZD': 'Algerian Dinar',
  'TND': 'Tunisian Dinar',
  'KWD': 'Kuwaiti Dinar',
  'BHD': 'Bahraini Dinar',
  'OMR': 'Omani Rial',
  'JOD': 'Jordanian Dinar',
  'LBP': 'Lebanese Pound',
  'CRC': 'Costa Rican Colón',
  'GTQ': 'Guatemalan Quetzal',
  'HNL': 'Honduran Lempira',
  'NIO': 'Nicaraguan Córdoba',
  'BOB': 'Bolivian Boliviano',
  'PYG': 'Paraguayan Guaraní',
  'ISK': 'Icelandic Króna',
  'BGN': 'Bulgarian Lev',
  'RSD': 'Serbian Dinar',
  'UAH': 'Ukrainian Hryvnia',
  'KZT': 'Kazakhstani Tenge',
  'UZS': 'Uzbekistani Som',
  'GEL': 'Georgian Lari',
  'AMD': 'Armenian Dram',
  'AZN': 'Azerbaijani Manat',
  'MDL': 'Moldovan Leu',
  'BYN': 'Belarusian Ruble',
};

const Map<String, String> kFlags = {
  'USD': '🇺🇸',
  'EUR': '🇪🇺',
  'GBP': '🇬🇧',
  'JPY': '🇯🇵',
  'CHF': '🇨🇭',
  'CAD': '🇨🇦',
  'AUD': '🇦🇺',
  'NZD': '🇳🇿',
  'CNY': '🇨🇳',
  'HKD': '🇭🇰',
  'SGD': '🇸🇬',
  'KRW': '🇰🇷',
  'INR': '🇮🇳',
  'BRL': '🇧🇷',
  'MXN': '🇲🇽',
  'ZAR': '🇿🇦',
  'SEK': '🇸🇪',
  'NOK': '🇳🇴',
  'DKK': '🇩🇰',
  'PLN': '🇵🇱',
  'CZK': '🇨🇿',
  'HUF': '🇭🇺',
  'RON': '🇷🇴',
  'TRY': '🇹🇷',
  'RUB': '🇷🇺',
  'AED': '🇦🇪',
  'SAR': '🇸🇦',
  'QAR': '🇶🇦',
  'ILS': '🇮🇱',
  'EGP': '🇪🇬',
  'NGN': '🇳🇬',
  'KES': '🇰🇪',
  'GHS': '🇬🇭',
  'MAD': '🇲🇦',
  'THB': '🇹🇭',
  'MYR': '🇲🇾',
  'IDR': '🇮🇩',
  'PHP': '🇵🇭',
  'VND': '🇻🇳',
  'TWD': '🇹🇼',
  'PKR': '🇵🇰',
  'BDT': '🇧🇩',
  'LKR': '🇱🇰',
  'NPR': '🇳🇵',
  'CLP': '🇨🇱',
  'COP': '🇨🇴',
  'PEN': '🇵🇪',
  'ARS': '🇦🇷',
  'UYU': '🇺🇾',
  'DZD': '🇩🇿',
  'TND': '🇹🇳',
  'KWD': '🇰🇼',
  'BHD': '🇧🇭',
  'OMR': '🇴🇲',
  'JOD': '🇯🇴',
  'LBP': '🇱🇧',
  'CRC': '🇨🇷',
  'GTQ': '🇬🇹',
  'HNL': '🇭🇳',
  'NIO': '🇳🇮',
  'BOB': '🇧🇴',
  'PYG': '🇵🇾',
  'ISK': '🇮🇸',
  'BGN': '🇧🇬',
  'RSD': '🇷🇸',
  'UAH': '🇺🇦',
  'KZT': '🇰🇿',
  'UZS': '🇺🇿',
  'GEL': '🇬🇪',
  'AMD': '🇦🇲',
  'AZN': '🇦🇿',
  'MDL': '🇲🇩',
  'BYN': '🇧🇾',
};

const List<String> kPopular = [
  'USD',
  'EUR',
  'GBP',
  'JPY',
  'CHF',
  'CAD',
  'AUD',
  'CNY',
  'INR',
  'BRL',
];

double convert(double amount, String from, String to) {
  return amount / (kRates[from] ?? 1.0) * (kRates[to] ?? 1.0);
}

String fmt(double v) {
  if (v == 0) return '0';
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(4)}M';
  if (v >= 1) {
    return v
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
  return v.toStringAsFixed(6);
}

// ── Page ──────────────────────────────────────────────────────────────────────

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage>
    with SingleTickerProviderStateMixin {
  final _amountCtrl = TextEditingController(text: '1');
  String _from = 'USD';
  String _to = 'EUR';
  final bool _swapping = false;

  late AnimationController _swapAnim;
  late Animation<double> _swapRot;

  @override
  void initState() {
    super.initState();
    _swapAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _swapRot = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _swapAnim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _swapAnim.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountCtrl.text) ?? 0;
  double get _result => convert(_amount, _from, _to);
  double get _rate => convert(1, _from, _to);
  double get _rateBack => convert(1, _to, _from);

  void _swap() async {
    _swapAnim.forward(from: 0);
    setState(() {
      final t = _from;
      _from = _to;
      _to = t;
    });
  }

  void _pickCurrency(bool isFrom) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencySheet(
        selected: isFrom ? _from : _to,
        label: isFrom ? 'Convert from' : 'Convert to',
      ),
    );
    if (result != null) {
      setState(() => isFrom ? _from = result : _to = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F7FF);
    final cardColor = isDark ? const Color(0xFF1C1F2A) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.07);
    final accentBg = cs.primary.withOpacity(0.08);
    final mutedText = isDark
        ? Colors.white.withOpacity(0.4)
        : Colors.black.withOpacity(0.4);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.6)
        : Colors.black.withOpacity(0.55);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ─────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.currency_exchange,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency Converter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '70+ world currencies',
                        style: TextStyle(fontSize: 13, color: mutedText),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Main Card ──────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Amount input
                    _SectionLabel(text: 'Amount', mutedColor: mutedText),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF8FAFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _from == 'EUR'
                                ? '€'
                                : _from == 'GBP'
                                ? '£'
                                : _from == 'JPY' || _from == 'CNY'
                                ? '¥'
                                : '\$',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: mutedText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _amountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: mutedText,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // From / Swap / To
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _CurrencyButton(
                            label: 'FROM',
                            code: _from,
                            flag: kFlags[_from] ?? '🏳',
                            name: kNames[_from] ?? _from,
                            cardColor: cardColor,
                            borderColor: borderColor,
                            mutedText: mutedText,
                            primaryColor: cs.primary,
                            isDark: isDark,
                            onTap: () => _pickCurrency(true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: AnimatedBuilder(
                            animation: _swapRot,
                            builder: (_, child) => Transform.rotate(
                              angle: _swapRot.value * 3.14159,
                              child: child,
                            ),
                            child: GestureDetector(
                              onTap: _swap,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.swap_horiz,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CurrencyButton(
                            label: 'TO',
                            code: _to,
                            flag: kFlags[_to] ?? '🏳',
                            name: kNames[_to] ?? _to,
                            cardColor: cardColor,
                            borderColor: borderColor,
                            mutedText: mutedText,
                            primaryColor: cs.primary,
                            isDark: isDark,
                            onTap: () => _pickCurrency(false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Result Card ────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.primary.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fmt(_amount)} $_from =',
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.primary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${fmt(_result)} $_to',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(color: cs.primary.withOpacity(0.15), height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 $_from = ${fmt(_rate)} $_to',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.primary.withOpacity(0.65),
                          ),
                        ),
                        Text(
                          '1 $_to = ${fmt(_rateBack)} $_from',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.primary.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Quick Amounts ──────────────────────────────────────────
              Text(
                'Quick amounts',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                ),
                itemCount: 6,
                itemBuilder: (_, i) {
                  final amt = [10, 50, 100, 500, 1000, 5000][i].toDouble();
                  final res = convert(amt, _from, _to);
                  return GestureDetector(
                    onTap: () {
                      _amountCtrl.text = amt.toInt().toString();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${fmt(amt)} $_from',
                            style: TextStyle(fontSize: 11, color: mutedText),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${fmt(res)} $_to',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Currency Button ───────────────────────────────────────────────────────────

class _CurrencyButton extends StatelessWidget {
  final String label, code, flag, name;
  final Color cardColor, borderColor, mutedText, primaryColor;
  final bool isDark;
  final VoidCallback onTap;

  const _CurrencyButton({
    required this.label,
    required this.code,
    required this.flag,
    required this.name,
    required this.cardColor,
    required this.borderColor,
    required this.mutedText,
    required this.primaryColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: mutedText,
              ),
            ),

            const SizedBox(height: 4),
            Text(
              code,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 11, color: mutedText),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Icon(Icons.expand_more, color: mutedText, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color mutedColor;

  const _SectionLabel({required this.text, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.9,
          color: mutedColor,
        ),
      ),
    );
  }
}

// ── Currency Picker Sheet ─────────────────────────────────────────────────────

class _CurrencySheet extends StatefulWidget {
  final String selected;
  final String label;

  const _CurrencySheet({required this.selected, required this.label});

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  String _query = '';

  List<String> get _popular => kPopular;

  List<String> get _rest {
    final all = kRates.keys.toList()..sort();
    return all.where((c) => !kPopular.contains(c)).toList();
  }

  List<String> _filter(List<String> list) {
    if (_query.isEmpty) return list;
    final q = _query.toUpperCase();
    return list.where((c) {
      return c.contains(q) || (kNames[c] ?? '').toUpperCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor = isDark
        ? const Color(0xFF1C1F2A)
        : const Color(0xFFF8FAFF);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.07);
    final mutedText = isDark
        ? Colors.white.withOpacity(0.4)
        : Colors.black.withOpacity(0.4);

    final filteredPopular = _filter(_popular);
    final filteredRest = _filter(_rest);

    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by name or code…',
                      hintStyle: TextStyle(fontSize: 15, color: mutedText),
                      prefixIcon: Icon(
                        Icons.search,
                        color: mutedText,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              children: [
                if (_query.isEmpty && filteredPopular.isNotEmpty) ...[
                  _SheetSectionLabel(text: 'Popular', mutedColor: mutedText),
                  ...filteredPopular.map(
                    (c) => _CurrencyTile(
                      code: c,
                      selected: widget.selected,
                      isDark: isDark,
                      borderColor: borderColor,
                      mutedText: mutedText,
                      accentColor: cs.primary,
                      onTap: () => Navigator.pop(context, c),
                    ),
                  ),
                  _SheetSectionLabel(
                    text: 'All currencies',
                    mutedColor: mutedText,
                  ),
                  ...filteredRest.map(
                    (c) => _CurrencyTile(
                      code: c,
                      selected: widget.selected,
                      isDark: isDark,
                      borderColor: borderColor,
                      mutedText: mutedText,
                      accentColor: cs.primary,
                      onTap: () => Navigator.pop(context, c),
                    ),
                  ),
                ] else ...[
                  ...[...filteredPopular, ...filteredRest].map(
                    (c) => _CurrencyTile(
                      code: c,
                      selected: widget.selected,
                      isDark: isDark,
                      borderColor: borderColor,
                      mutedText: mutedText,
                      accentColor: cs.primary,
                      onTap: () => Navigator.pop(context, c),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetSectionLabel extends StatelessWidget {
  final String text;
  final Color mutedColor;

  const _SheetSectionLabel({required this.text, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          color: mutedColor,
        ),
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final String code;
  final String selected;
  final bool isDark;
  final Color borderColor, mutedText, accentColor;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.code,
    required this.selected,
    required this.isDark,
    required this.borderColor,
    required this.mutedText,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = code == selected;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

      title: Text(
        code,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: isSelected
              ? accentColor
              : (isDark ? Colors.white : const Color(0xFF0F172A)),
        ),
      ),
      subtitle: Text(
        kNames[code] ?? '',
        style: TextStyle(fontSize: 12, color: mutedText),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: accentColor, size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
