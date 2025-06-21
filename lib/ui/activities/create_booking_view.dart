import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample_app/ui/payment/payment.dart';
// Add this import if you use the contacts_service package
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';

class CreateBookingView extends StatefulWidget {
  const CreateBookingView({super.key});

  @override
  State<CreateBookingView> createState() => _CreateBookingViewState();
}

class _CreateBookingViewState extends State<CreateBookingView> {
  String? selectedCourt;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isPublic = true;
  String eventName = '';
  int peopleLimit = 10;
  List<String> invitedPhones = [];
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  // Dummy courts for selection
  final List<String> courts = [
    'Downtown Basketball Court',
    'Westside Tennis Club',
    'Greenfield Badminton Courts',
    'Lakeside Soccer Field',
    'Sunset Volleyball Courts',
  ];

  @override
  void dispose() {
    _eventNameController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _pickContact() async {
    // Uncomment and use this if you add contacts_service and permission_handler

    final status = await Permission.contacts.request();
    if (status.isGranted) {
      final contact = await ContactsService.openDeviceContactPicker();
      if (contact != null &&
          contact.phones != null &&
          contact.phones!.isNotEmpty) {
        final phone = contact.phones!.first.value ?? '';
        if (phone.isNotEmpty && !invitedPhones.contains(phone)) {
          setState(() {
            invitedPhones.add(phone);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Booking'),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.08),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Choose available courts
                  Text('Choose Court',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCourt,
                    isExpanded: true, // <-- This prevents overflow!
                    items: courts
                        .map((court) => DropdownMenuItem(
                              value: court,
                              child: Text(
                                court,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCourt = value;
                        if (isPublic) {
                          _eventNameController.text = value ?? '';
                        }
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: theme.colorScheme.primary.withOpacity(0.05),
                      hintText: 'Select a court',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Choose date and time
                  Text('Choose Date & Time',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(selectedDate == null
                              ? 'Select Date'
                              : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(selectedTime == null
                              ? 'Select Time'
                              : selectedTime!.format(context)),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Radio button public/private
                  Text('Event Type',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Public'),
                        selected: isPublic,
                        onSelected: (selected) {
                          setState(() {
                            isPublic = true;
                            if (selectedCourt != null) {
                              _eventNameController.text = selectedCourt!;
                            }
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isPublic
                              ? Colors.white
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.08),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('Private'),
                        selected: !isPublic,
                        onSelected: (selected) {
                          setState(() {
                            isPublic = false;
                            _eventNameController.clear();
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: !isPublic
                              ? Colors.white
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.08),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 5. If public, rename event
                  if (isPublic) ...[
                    Text('Event Name',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _eventNameController,
                      decoration: InputDecoration(
                        hintText: selectedCourt ?? 'Event Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: theme.colorScheme.primary.withOpacity(0.05),
                        prefixIcon: const Icon(Icons.edit),
                      ),
                      onChanged: (val) => setState(() => eventName = val),
                    ),
                    const SizedBox(height: 20),
                    Text('Invite Users',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmall = constraints.maxWidth < 400;
                        return isSmall
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: _inviteController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter phone number',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: theme.colorScheme.primary
                                          .withOpacity(0.05),
                                      prefixIcon:
                                          const Icon(Icons.person_add_alt_1),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final phone =
                                                _inviteController.text.trim();
                                            if (phone.isNotEmpty &&
                                                !invitedPhones
                                                    .contains(phone)) {
                                              setState(() {
                                                invitedPhones.add(phone);
                                                _inviteController.clear();
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                          ),
                                          child: const Text('Add'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Tooltip(
                                        message: 'Pick from contacts',
                                        child: IconButton(
                                          icon: const Icon(Icons.contacts),
                                          color: theme.colorScheme.primary,
                                          onPressed: _pickContact,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _inviteController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'Enter phone number',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        filled: true,
                                        fillColor: theme.colorScheme.primary
                                            .withOpacity(0.05),
                                        prefixIcon:
                                            const Icon(Icons.person_add_alt_1),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      final phone =
                                          _inviteController.text.trim();
                                      if (phone.isNotEmpty &&
                                          !invitedPhones.contains(phone)) {
                                        setState(() {
                                          invitedPhones.add(phone);
                                          _inviteController.clear();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                    ),
                                    child: const Text('Add'),
                                  ),
                                  const SizedBox(width: 8),
                                  Tooltip(
                                    message: 'Pick from contacts',
                                    child: IconButton(
                                      icon: const Icon(Icons.contacts),
                                      color: theme.colorScheme.primary,
                                      onPressed: _pickContact,
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: invitedPhones
                          .map((phone) => Chip(
                                label: Text(phone),
                                backgroundColor:
                                    theme.colorScheme.primary.withOpacity(0.15),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () {
                                  setState(() {
                                    invitedPhones.remove(phone);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // 7. Set limit on number of people
                    Text('Set People Limit',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: peopleLimit.toDouble(),
                            min: 2,
                            max: 50,
                            divisions: 48,
                            label: '$peopleLimit',
                            onChanged: (val) {
                              setState(() {
                                peopleLimit = val.round();
                              });
                            },
                            activeColor: theme.colorScheme.primary,
                            inactiveColor:
                                theme.colorScheme.primary.withOpacity(0.2),
                          ),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$peopleLimit',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 8. If private, hide public features (already handled by if above)

                  // 9. Proceed to payment button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PaymentPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        label: const Text('Proceed to Payment'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
