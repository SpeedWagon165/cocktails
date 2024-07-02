import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StepIndicator extends StatelessWidget {
  final int activeStep;

  const StepIndicator({
    super.key,
    required this.activeStep,
  });

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      padding: EdgeInsets.symmetric(horizontal: 4),
      lineStyle: LineStyle(
        lineType: LineType.normal,
        lineWidth: 1,
        lineLength: MediaQuery.of(context).size.width * 0.3,
        finishedLineColor: const Color(0xff68C248),
        unreachedLineColor: Colors.white.withOpacity(0.2),
        activeLineColor: Colors.white,
      ),
      showLoadingAnimation: activeStep == 2 ? true : false,
      defaultStepBorderType: BorderType.normal,
      activeStepBorderColor: Colors.white,
      activeStepBackgroundColor:
          activeStep == 2 ? Colors.black : Colors.transparent,
      activeStep: activeStep,
      finishedStepBackgroundColor: const Color(0xff68C248),
      borderThickness: 2.0,
      stepRadius: 12,
      activeStepTextColor: Colors.white,
      unreachedStepTextColor: Color(0xffB7B7B7),
      finishedStepTextColor: Colors.white,
      unreachedStepBackgroundColor: Colors.white.withOpacity(0.2),
      unreachedStepBorderColor: Colors.white.withOpacity(0.2),
      steps: [
        EasyStep(
          title: 'Алкоголь',
          customStep: activeStep <= 0
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/check_icon.svg',
                  height: 10,
                  width: 10,
                ),
        ),
        EasyStep(
          title: 'Доп. ингредиенты',
          customStep: activeStep <= 1
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          activeStep == 1 ? Colors.white : Colors.transparent,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/check_icon.svg',
                  height: 10,
                  width: 10,
                ),
        ),
        EasyStep(
          title: 'Подбор',
          customStep: activeStep <= 2
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          activeStep == 2 ? Colors.white : Colors.transparent,
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/check_icon.svg',
                  height: 10,
                  width: 10,
                ),
        ),
      ],
    );
    ;
  }
}
