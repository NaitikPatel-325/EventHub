import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  final _eventLocationController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _eventNameController,
                label: 'Event Name',
                hintText: 'Enter the event name',
                icon: Icons.event,
              ),
              const SizedBox(height: 16.0),
              _buildDateTimePicker(
                context: context,
                controller: _eventDateController,
                label: 'Event Date',
                icon: Icons.calendar_today,
                onTap: () => _selectDate(context),
                hintText: _selectedDate == null
                    ? 'Select event date'
                    : _formatDate(_selectedDate!),
              ),
              const SizedBox(height: 16.0),
              _buildDateTimePicker(
                context: context,
                controller: _eventTimeController,
                label: 'Event Time',
                icon: Icons.access_time,
                onTap: () => _selectTime(context),
                hintText: _selectedTime == null
                    ? 'Select event time'
                    : _formatTime(_selectedTime!),
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _eventLocationController,
                label: 'Event Location',
                hintText: 'Enter the event location',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _eventDescriptionController,
                label: 'Event Description',
                hintText: 'Enter a brief description',
                icon: Icons.description,
                maxLines: 4,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final eventName = _eventNameController.text;
                    final eventDate = _eventDateController.text;
                    final eventTime = _eventTimeController.text;
                    final eventLocation = _eventLocationController.text;
                    final eventDescription = _eventDescriptionController.text;

                    print('Event Name: $eventName');
                    print('Event Date: $eventDate');
                    print('Event Time: $eventTime');
                    print('Event Location: $eventLocation');
                    print('Event Description: $eventDescription');

                    _eventNameController.clear();
                    _eventDateController.clear();
                    _eventTimeController.clear();
                    _eventLocationController.clear();
                    _eventDescriptionController.clear();
                    _selectedDate = null;
                    _selectedTime = null;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event created successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required String hintText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _eventDateController.text = _formatDate(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _eventTimeController.text = _formatTime(pickedTime);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.toLocal()}'.split(' ')[0];
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
