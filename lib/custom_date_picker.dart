import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final bool isFromDate;
  final DateTime? fromDate;

  const CustomDatePicker({
    Key? key,
    required this.isFromDate,
    required this.fromDate,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  String currentHeaderText = '';
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  int selectedDateIndex = 0;
  bool isToDateSelected = false;
  DateTime? initialFromDate;

  @override
  void initState() {
    super.initState();
    selectedFromDate = widget.isFromDate ? widget.fromDate : DateTime.now();
    initialFromDate = widget.fromDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFromDateSection(),
            _buildCalendarSection(),
            const SizedBox(height: 4),
            Divider(
              color: Theme.of(context).dividerColor,
            ),
            _buildSelectedDateSection(),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }


  @override
  Widget _buildFromDateSection() {
    if (widget.isFromDate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildDateButton('Today', 0, () {
                setState(() {
                  selectedFromDate = DateTime.now();
                  selectedDateIndex = 0;
                });
              }),
              SizedBox(
                width: 8.w,
              ),
              _buildDateButton('Next', 1, () {
                setState(() {
                  selectedFromDate = DateTime.now().add(Duration(days: 1));
                  selectedDateIndex = 1;
                });
              }),
            ],
          ),
          Row(
            children: [
              _buildDateButton('Next', 2, () {
                setState(() {
                  selectedFromDate = DateTime.now().add(Duration(days: 2));
                  selectedDateIndex = 2;
                });
              }),
              SizedBox(
                width: 8.w,
              ),
              _buildDateButton('After 1 week', 3, () {
                setState(() {
                  selectedFromDate = DateTime.now().add(Duration(days: 7));
                  selectedDateIndex = 3;
                });
              }),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDateButton('No date', 0, () {
            setState(() {
              selectedToDate = null;
              selectedDateIndex = 0;
            });
          }),
          SizedBox(
            width: 8.w,
          ),
          _buildDateButton('Today', 1, () {
            setState(() {
              selectedToDate = DateTime.now();
              selectedDateIndex = 1;
            });
          }),
        ],
      );
    }
  }

  Widget _buildCalendarSection() {
    return SingleChildScrollView(
      child: Container(
        height: 350.w,
        child: CalendarCarousel(
          weekdayTextStyle: TextStyle(color: Colors.black),
          daysTextStyle: TextStyle(color: Colors.black),
          weekendTextStyle: TextStyle(color: Colors.black),
          headerTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18.w),
          leftButtonIcon: Icon(Icons.arrow_left, color: Colors.black),
          rightButtonIcon: Icon(Icons.arrow_right, color: Colors.black),
          todayBorderColor: Colors.transparent,
          todayButtonColor: Theme.of(context).primaryColor,
          selectedDateTime: widget.isFromDate ? selectedFromDate : selectedToDate,
          selectedDayButtonColor:  Theme.of(context).primaryColor,
          selectedDayBorderColor:  Theme.of(context).primaryColor,
          selectedDayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          minSelectedDate: widget.isFromDate ? null : (initialFromDate!.month==selectedFromDate!.month)?initialFromDate:selectedToDate,
          onDayPressed: (DateTime date, List<EventInterface> events) {
            setState(() {
              print(initialFromDate!.month>selectedFromDate!.month);
              if (widget.isFromDate) {
                selectedFromDate = date;
              } else {
                selectedToDate = date;
              }
              selectedDateIndex = _calculateSelectedDateIndex(date);
              isToDateSelected = !widget.isFromDate;
            });
          },
          onCalendarChanged: (DateTime start) {
            setState(() {
              selectedDateIndex = _calculateSelectedDateIndex(start);
            });
          },
        ),
      ),
    );
  }

  int _calculateSelectedDateIndex(DateTime selectedDate) {
    final todayday = DateTime.now().day;
    final today = DateTime.now();
    if (selectedDate.day == todayday) {
      return widget.isFromDate ? 0 : 1; // Today
    } else if (selectedDate.difference(today).inDays == 0) {
      return widget.isFromDate ? 1 : 2; // Next Day
    } else if (selectedDate.difference(today).inDays == 1) {
      return 2; // Next 2nd Day
    } else if (selectedDate.difference(today).inDays >= 7) {
      return 3; // After 1 week
    } else {
      return -1; // Not in the predefined dates
    }
  }

  Widget _buildSelectedDateSection() {
    DateTime? selectedDate =
        widget.isFromDate ? selectedFromDate : selectedToDate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.date_range,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              selectedDate != null
                  ? DateFormat('dd MMM yyyy').format(selectedDate)
                  : 'No Date',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                foregroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).canvasColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
              ),
              onPressed: () {
                Navigator.pop(context, widget.isFromDate ? selectedFromDate : selectedToDate);
              },
              child: Text(
                'Save',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateButton(String label, int index, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            onPressed();
          });
        },
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          backgroundColor: _calculateButtonBackgroundColor(index),
        ),
        child: Text(
          _buildDynamicLabel(label, index),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: _calculateButtonTextColor(index),
          ),
        ),
      ),
    );
  }

  Color _calculateButtonBackgroundColor(int index) {
    if (index == selectedDateIndex) {
      return Theme.of(context).primaryColor;
    } else if (index == 0 && selectedDateIndex == 0) {
      return Theme.of(context).primaryColor; // Set the background color for "No date" button when selected
    } else {
      return Theme.of(context).cardColor;
    }
  }

  Color _calculateButtonTextColor(int index) {
    return (index == selectedDateIndex || (index == 0 && selectedDateIndex == 0))
        ? Colors.white // Set the text color for "No date" button when selected
        : Theme.of(context).primaryColor;
  }

  String _buildDynamicLabel(String label, int index) {
    if (widget.isFromDate) {
      // Handle buttons for "from_date" calendar
      if (index == 1) {
        return '$label ' +
            DateFormat('EEEE').format(DateTime.now().add(Duration(days: 1)));
      } else if (index == 2) {
        return '$label ' +
            DateFormat('EEEE').format(DateTime.now().add(Duration(days: 2)));
      } else {
        return label;
      }
    } else {
      // Handle buttons for "to_date" calendar
      if (index == 0) {
        return 'No date';
      } else if (index == 1) {
        return 'Today';
      } else {
        return label;
      }
    }
  }
  @override
  void dispose() {
    initialFromDate = null; // Clear the reference when the widget is disposed
    super.dispose();
  }
}
