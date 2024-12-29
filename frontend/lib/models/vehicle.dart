class Vehicle {
  int? household_id;
  String? license_plate;
  String? vehicle_type;
  int? vehicles_id;

  Vehicle(this.household_id, this.license_plate, this.vehicle_type,this.vehicles_id);

  Vehicle.fromJson(Map<String, dynamic> json) {
    household_id = json['household_id'];
    license_plate = json['license_plate'];
    vehicle_type = json['vehicle_type'];
    vehicles_id = json['vehicles_id'];
  }
}
