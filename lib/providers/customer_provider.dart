import 'package:flutter/material.dart';
import 'package:wareflow/models/customer_model.dart';

class CustomerProvider extends ChangeNotifier {
  String _customerId = '';
  String _customerName = '';
  String _customerEmail = '';
  String _customerContact = '';
  String _customerAddress = '';
  String _organizationId = '';
  //supplier state
  final Map<String, CustomerModel> _customers = {};
  //getter
  Map<String, CustomerModel> get customers {
    return {..._customers};
  }

  // set the selected supplier
  void setSelectedCustomer({
    required String id,
    required String name,
    required String email,
    required String contact,
    required String address,
    required String organizationId,
  }) {
    _customers[id] = CustomerModel(
      id: id,
      name: name,
      email: email,
      contact: contact,
      address: address,
      organizationId: organizationId,
    );

    _customerId = id;
    _customerName = name;
    _customerEmail = email;
    _customerContact = contact;
    _customerAddress = address;
    _organizationId = organizationId;
    print("id $id name $name");
    notifyListeners();
  }

  // getters
  String get customerId => _customerId;
  String get customerName => _customerName;
  String get customerEmail => _customerEmail;
  String get customerContact => _customerContact;
  String get customerAddress => _customerAddress;
  String get organizationId => _organizationId;
  //clear selected supplier
  void clearSelectedCustomer() {
    customers.clear();
    _customerId = '';
    _customerName = '';
    _customerEmail = '';
    _customerContact = '';
    _customerAddress = '';
    _organizationId = '';
    notifyListeners();
  }
}
