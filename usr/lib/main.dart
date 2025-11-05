import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Converter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.amber,
        hintColor: Colors.amber,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.amber,
          secondary: Colors.amber,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.amber),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'JMPT';
  String _toCurrency = 'INR';
  String _result = '';
  String _conversionRate = '';

  // Using USD as a base for conversion rates for simplicity
  final Map<String, double> _rates = {
    'JMPT': 1.88, // 1 JMPT = 1.88 USD
    'BTC': 68000.0, // 1 BTC = 68000 USD
    'ETH': 3800.0, // 1 ETH = 3800 USD
    'INR': 1 / 83.5, // 1 INR = 1/83.5 USD
    'USD': 1.0,
  };

  final List<String> _currencies = ['JMPT', 'BTC', 'ETH', 'INR', 'USD'];

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _result = 'Please enter a valid amount';
        _conversionRate = '';
      });
      return;
    }

    final fromRate = _rates[_fromCurrency]!;
    final toRate = _rates[_toCurrency]!;
    
    final convertedAmount = amount * fromRate / toRate;
    final rate = fromRate / toRate;

    setState(() {
      _result = '${convertedAmount.toStringAsFixed(2)} $_toCurrency';
      _conversionRate = '1 $_fromCurrency = ${rate.toStringAsFixed(6)} $_toCurrency';
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Converter'),
        centerTitle: true,
        backgroundColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Convert Your Crypto & Fiat',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount to Convert',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                onChanged: (value) {
                  setState(() {
                    _result = '';
                    _conversionRate = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCurrencyDropdown(isFrom: true),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: Colors.amber, size: 30),
                    onPressed: _swapCurrencies,
                  ),
                  _buildCurrencyDropdown(isFrom: false),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _convert,
                child: const Text('Convert'),
              ),
              const SizedBox(height: 40),
              if (_result.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Converted Amount:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 16),
                     if (_conversionRate.isNotEmpty)
                      Text(
                        _conversionRate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({required bool isFrom}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: isFrom ? _fromCurrency : _toCurrency,
            isExpanded: true,
            items: _currencies.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  if (isFrom) {
                    _fromCurrency = newValue;
                  } else {
                    _toCurrency = newValue;
                  }
                  _result = '';
                  _conversionRate = '';
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
