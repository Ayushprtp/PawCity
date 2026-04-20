import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appointments = [
      ('Vet Checkup', 'Tomorrow · 5:30 PM'),
      ('Grooming Session', 'Fri · 11:00 AM'),
      ('Dental Consult', 'Apr 28 · 2:15 PM'),
    ];

    return PawScaffold(
      title: 'My Appointments',
      currentNavIndex: 3,
      body: ListView.separated(
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return PawAsymCard(
            onTap: () => context.go('/booking-confirmation'),
            child: Row(
              children: [
                const Icon(Icons.event_available_rounded),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.$1,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSizes.xs),
                      Text(appointment.$2),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}