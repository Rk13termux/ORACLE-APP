import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/features/finanzas/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transaction;
  final Function(Transaction) onSubmit;

  const TransactionForm({
    Key? key,
    this.transaction,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  
  late String _title;
  late double _amount;
  late DateTime _date;
  late TransactionType _type;
  late TransactionCategory _category;
  String? _description;
  
  @override
  void initState() {
    super.initState();
    
    // Si estamos editando, inicializar con los valores de la transacción
    if (widget.transaction != null) {
      _title = widget.transaction!.title;
      _amount = widget.transaction!.amount;
      _date = widget.transaction!.date;
      _type = widget.transaction!.type;
      _category = widget.transaction!.category;
      _description = widget.transaction!.description;
    } else {
      // Valores por defecto para una nueva transacción
      _title = '';
      _amount = 0.0;
      _date = DateTime.now();
      _type = TransactionType.expense;
      _category = TransactionCategory.other;
      _description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppThemes.primaryBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.transaction == null ? 'Nueva Transacción' : 'Editar Transacción',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Tipo de transacción (ingreso o gasto)
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      type: TransactionType.income,
                      isSelected: _type == TransactionType.income,
                      label: 'Ingreso',
                      icon: Icons.arrow_upward,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeButton(
                      type: TransactionType.expense,
                      isSelected: _type == TransactionType.expense,
                      label: 'Gasto',
                      icon: Icons.arrow_downward,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Título
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              
              // Monto
              TextFormField(
                initialValue: _amount > 0 ? _amount.toString() : '',
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto';
                  }
                  try {
                    double.parse(value);
                    return null;
                  } catch (e) {
                    return 'Por favor ingresa un número válido';
                  }
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 16),
              
              // Fecha
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_date),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Categoría
              DropdownButtonFormField<TransactionCategory>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _getCategoryDropdownItems(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona una categoría';
                  }
                  return null;
                },
                dropdownColor: Colors.black87,
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 16),
              
              // Descripción (opcional)
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 24),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTypeButton({
    required TransactionType type,
    required bool isSelected,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _type = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.white30,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<DropdownMenuItem<TransactionCategory>> _getCategoryDropdownItems() {
    List<DropdownMenuItem<TransactionCategory>> items = [];
    
    for (final category in TransactionCategory.values) {
      // Crear una transacción temporal para obtener icono y color
      final tempTransaction = Transaction(
        id: '',
        title: '',
        amount: 0,
        date: DateTime.now(),
        type: _type,
        category: category,
      );
      
      // Convertir nombre de enum a texto presentable
      String categoryName = category.name;
      categoryName = categoryName[0].toUpperCase() + categoryName.substring(1);
      
      items.add(
        DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Icon(
                tempTransaction.categoryIcon,
                color: tempTransaction.categoryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                categoryName,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
    
    return items;
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppThemes.primaryBlue,
              onPrimary: Colors.white,
              surface: AppThemes.primaryBlack,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppThemes.primaryBlack,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final transaction = Transaction(
        id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        amount: _amount,
        date: _date,
        type: _type,
        category: _category,
        description: _description,
      );
      
      widget.onSubmit(transaction);
    }
  }
}