import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class AddToCartDialog extends StatefulWidget {
  final MenuItem item;
  final ValueChanged<int> onAdd;

  const AddToCartDialog({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  late final TextEditingController _quantityController;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int value) {
    final clamped = value.clamp(1, 999);
    setState(() {
      _quantity = clamped;
      _quantityController.text = _quantity.toString();
      _quantityController.selection = TextSelection.fromPosition(
        TextPosition(offset: _quantityController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 220,
              height: 140,
              child: Image.asset(
                widget.item.imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: _quantity > 1 ? () => _updateQuantity(_quantity - 1) : null,
              ),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    final parsed = int.tryParse(value) ?? 1;
                    _updateQuantity(parsed);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _quantity < 999 ? () => _updateQuantity(_quantity + 1) : null,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(_quantity);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}