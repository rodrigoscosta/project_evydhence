import 'package:flutter/material.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';

class VehicleTile extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleTile(this.vehicle, {super.key});

  @override
  Widget build(BuildContext context) {
    const avatarVehicle= CircleAvatar(child: Icon(Icons.directions_car));
    return ListTile(
      leading: avatarVehicle,
      title: Text(vehicle.placa),
      subtitle: Text(vehicle.modelo),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.vehicleForm, arguments: vehicle);
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Editar veículo',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              tooltip: 'Deletar veículo',
            ),
          ],
        ),
      ),
    );
  }
}
