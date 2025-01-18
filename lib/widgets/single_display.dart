import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/model/todo.dart';


class SingleDisplay extends StatelessWidget{

  SingleDisplay(this.todo,this.onToggleComplete,{super.key});

  final Todo todo;
  final void Function() onToggleComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Checkbox(
                value: todo.isCompleted,
                onChanged: (_) {
                  onToggleComplete();
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      todo.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      todo.formattedDate,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }  
}