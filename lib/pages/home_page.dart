import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_page_view_dots_indicator_example/pages/request_money_page.dart';
import 'package:slide_page_view_dots_indicator_example/pages/send_money_page.dart';

import '../bloc/home_page_bloc.dart';
import '../constants/svg_assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider View'),
        centerTitle: true,
      ),
      body: const SliderView(),
    );
  }
}


class SliderView extends StatefulWidget {
  const SliderView({super.key});

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late PageController _pageController;
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9,
    )..addListener(() {
        setState(() {
          _pageOffset = _pageController.page!;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: 406,
              // color: Colors.red,
              // margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 20),
              child: PageView.builder(
                controller: _pageController,
                padEnds: false,
                physics: const BouncingScrollPhysics(),
            
                onPageChanged: (value) {
                  context.read<HomePageBloc>().add(HomePageDots(value));
                },
                itemCount: _getListOfSliderContainer(context).length,
                itemBuilder: (context, index) {
                  // final double relativePosition = index - _pageOffset;

                  // // Apply scaling based on the relative position
                  // final scaleFactor =
                  //     0.7 + 0.5 * (1 - relativePosition.abs());
                  // return Transform.scale(
                  //   scale: scaleFactor,
                  //   child: _getListOfSliderContainer(context)[index],
                  // );

                  return _getListOfSliderContainer(context)[index];
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DotsIndicator(
              dotsCount: 2,
              position: state.index,
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: Colors.blue,
                size: const Size.square(5),
                activeSize: const Size(17, 5),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


Widget _sliderContainer({
  String path = SvgAssetsConstant.requestMoney,
  String bodyText = 'Send Money',
  required String buttonTitle,
  required void Function()? onPressed,
}) {
  return Container(
    width: double.maxFinite,
    height: 406,
    
    margin: const EdgeInsets.only(top: 20,  right: 24),
    padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 24),
    decoration: BoxDecoration(
      color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 248,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SvgPicture.asset(
              path,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(bodyText),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Center(
            child: Text(buttonTitle),
          ),
        ),
      ],
    ),
  );
}

// List<Widget> _listOfSliderContainer = [
//   _sliderContainer(
   
//     buttonTitle: 'Send Money',
//     bodyText: 'Send Money',
//     onPressed: () {
//       debugPrint('I am send money');
//       Navigator.pop(context)
//     },
//   ),
//   _sliderContainer(
//     buttonTitle: 'Request Money',
//     bodyText: 'Request Money',
//     onPressed: () {
//       debugPrint('I am request money');
//     },
//   ),
// ];

List<Widget> _getListOfSliderContainer(BuildContext context) {
  return [
  _sliderContainer(
   
    buttonTitle: 'Send Money',
    bodyText: 'Send Money',
    onPressed: () {
      debugPrint('I am send money');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SendMoneyPage()));
    },
  ),
  _sliderContainer(
    buttonTitle: 'Request Money',
    bodyText: 'Request Money',
    onPressed: () {
      debugPrint('I am request money');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestMoneyPage()));
    },
  ),
];
}
