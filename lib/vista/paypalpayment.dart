import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';


class PayPalPayment extends StatefulWidget {
  final String nombreProducto;
  final String cantidad;
  final String precio;
  final String pago;

  const PayPalPayment(
       this.nombreProducto, this.cantidad, this.precio, this.pago,{Key? key})
      : super(key: key);

  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}


class _PayPalPaymentState extends State<PayPalPayment> {
  late String nombreProducto = widget.nombreProducto;
  late String cantidad = widget.cantidad;
  late String precio = widget.precio;
  late String pago = widget.pago;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaypalPaymentDemp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: "AcwdoaRTmWm5uGLAhw0oL05BsZcMj2yiBLuKqVygxxKLB7ws08MW1awtuHG7WMSDFQ7OOoVd0yqFf-NX",
                  secretKey: "EOd4aPvFSurYf1WwVHLtbFP3Fbs5rJuuO2BucHtD6ecoBSJOAZKO6g-czOr1HIf9aqZMlTzg7sw3jeWd",
                  transactions: [
                    {
                      "amount": {
                        "total": pago,
                        "currency": "USD",
                        "details": {
                          "subtotal": pago,
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "Compra de ${cantidad} ${nombreProducto} por un valor de ${pago}}}",
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": {
                        "items": [
                          {
                            "name": "${nombreProducto}",
                            "quantity": "${cantidad}",
                            "price": '${precio}',
                            "currency": "USD"
                          }
                        ],

                        // Optional
                        //   "shipping_address": {
                        //     "recipient_name": "Tharwat samy",
                        //     "line1": "tharwat",
                        //     "line2": "",
                        //     "city": "tharwat",
                        //     "country_code": "EG",
                        //     "postal_code": "25025",
                        //     "phone": "+00000000",
                        //     "state": "ALex"
                        //  },
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    log("onSuccess: $params");
                    Navigator.pop(context);
                  },
                  onError: (error) {
                    log("onError: $error");
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    print('cancelled:');
                    Navigator.pop(context);
                  },
                ),
              ));
            },
            child: const Text('Pay with paypal'),
          ),
        ),
      ),
    );
  }
}
