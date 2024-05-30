
import 'package:easy_pos_r5/widgets/card_header_item.dart';
import 'package:easy_pos_r5/widgets/row_header.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar:AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height/3 +18,
                  color: Theme.of(context).primaryColor,
                  child:  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowHeader(),
                        const SizedBox(height: 12,),
                        CardHeaderItem(
                          title: "Exchange Rate",
                          subTitle: "1 USD = 50 Egp",
                        ),
                        CardHeaderItem(
                          title: "Today's Sales",
                          subTitle: "1000 EGP",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




