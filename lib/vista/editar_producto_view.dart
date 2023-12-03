// ignore_for_file: use_key_in_widget_constructors

import 'package:ecosecha/controlador/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductoEditView extends StatelessWidget {
  final TextEditingController productoController;
  final TextEditingController cantidadController;
  final TextEditingController descripcionController;
  final TextEditingController precioController;
  final VoidCallback updatePressed;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductoEditView({
    required this.productoController,
    required this.cantidadController,
    required this.descripcionController,
    required this.precioController,
    required this.updatePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffold para la vista de edición de producto
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 246),
      appBar: AppBar(
        title: const Text('Editar producto'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            // Lista expandida para contener los elementos del formulario
            Expanded(
              child: ListView(children: [
                const SizedBox(height: 5),
                // Campo de texto para el nombre del producto
                TextFormField(
                  controller: productoController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tv),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del producto';
                    }
                    return null;
                  },
                  // Filtro para permitir solo caracteres alfabéticos
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[ a-zA-Z0-9]')),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el cantidad del producto
                TextFormField(
                  controller: cantidadController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.business),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la cantidad';
                    }
                    return null;
                  },
                  // Filtro para permitir solo numeros
                  keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                        LengthLimitingTextInputFormatter(10),
                      ],
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para la descripcion del producto
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.unfold_more_double_sharp),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la descripcion del producto';
                    }
                    return null;
                  },
                  // Filtro para permitir caracteres alfanuméricos
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[ a-zA-Z0-9]')),
                  ],
                  readOnly: false, // Permite edición del campo
                ),
                const SizedBox(height: 16.0),
                // Campo de texto para el precio del producto
                TextFormField(
                  controller: precioController,
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.energy_savings_leaf),
                  ),
                  // Validación del campo
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el precio de producto';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.singleLineFormatter,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  readOnly: false, // Permite edición del campo
                ),
              ]),
            ),
            // Botón elevado para guardar cambios del producto
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updatePressed();
                } else {
                  showPersonalizedAlert(
                      context,
                      "Corrija los errores en el formulario",
                      AlertMessageType.error);
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ]),
        ),
      ),
    );
  }
}
