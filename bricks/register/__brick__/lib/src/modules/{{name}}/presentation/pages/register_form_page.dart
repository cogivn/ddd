import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../../../../../generated/colors.gen.dart';
import '../widgets/register_form_body.dart';

class RegisterFormPage extends StatelessWidget {
  const RegisterFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: Container(
            width: 1.sw,
            height: 1.sh * .15,
            color: ColorName.primary,
          ),
        ),
        const RegisterFormBody(),
      ],
    );
  }
}
