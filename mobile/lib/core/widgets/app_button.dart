import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  const AppButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,
          disabledBackgroundColor: Colors.blue.shade200,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          )
        ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: .bold
              ),
            ),
            if (isLoading)
              Center( // Ensures the SizedBox can determine its alignment
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.grey.shade100
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}