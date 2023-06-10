import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/delegates/search_match_delegate.dart';
import 'package:tfg_app/delegates/search_date_delegate.dart';

import 'package:tfg_app/services/match_service.dart';
import 'package:tfg_app/widgets/widgets.dart';





class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final matchService = Provider.of<MatchService>(context);
    
   
    return Scaffold(
      body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            children: [
              _Header(),
              FutureBuilder(
                  future: matchService.getItems(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == false) {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Cargando partidos...'),
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: size.height),
                      child: ListView.builder(
                        itemCount: matchService.matches.length,
                        itemBuilder: (context, index) {
                          if (index == matchService.matches.length - 1) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 200),
                              child: FadeInLeft(
                                  child: MatchCard(
                                match: matchService.matches[index],
                              )),                              
                            );
                          }
                          return FadeInLeft(
                            
                            child: MatchCard(
                            match: matchService.matches[index],
                          )
                          );
                        },
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    )
    );
  }
}




class _HeaderState extends State<_Header> {
  

  @override
  void initState() {
    super.initState();
  }

  void _onIconTap(BuildContext context) {
    Navigator.pushNamed(context, 'main');
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          InkWell(
              onTap: () => _onIconTap(context),
              child: Row(
                children: [
                  Icon(
                    Icons.sports_soccer_outlined,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Partidos',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'statistics');
            },
            icon: Icon(
              Icons.analytics_outlined,
              size: 30,
            ),
          ),
          
          IconButton(
            onPressed: () {
              Provider.of<MatchService>(context, listen: false).sort();
            },
            icon: Icon(
              Icons.sort,
              size: 30,
            ),
          ),
        
        
        IconButton(
          onPressed: () async {
            final result = await showSearch(
              context: context,
              delegate: SearchMatchDelegate(),
            );
          },
          icon: Icon(
            Icons.search,
            size: 30,
          ),
        ),
        IconButton(
          onPressed: () async {
            final result = await showSearch(
              context: context,
              delegate: SearchDateDelegate(),
            );
          },
          icon: Icon(
            Icons.calendar_today,
            size: 30,
          ),
        ),
      ],
    ),
  );
}

}

class _Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();

}



