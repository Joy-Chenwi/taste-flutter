import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({ super.key });

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider (
			create: (context) => MyAppState(),
			child: MaterialApp(
				title: "The app-bro",
				theme: ThemeData (
					colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
					),
				home: MyHomePage(),
			)
		);
	}
}

class MyAppState extends ChangeNotifier {
	var current = WordPair.random();

	void getNext() {
		current = WordPair.random();
		notifyListeners();
	}

	var favorites = <WordPair>[];
	var boyCot = <WordPair>[];

	void toggleFavorite() {
		if(favorites.contains(current)) {
				favorites.remove(current);
			} else {
				favorites.add(current);
			}
		notifyListeners();
	}

	void toggleBoyCot() {
		if(boyCot.contains(current)) {
			boyCot.remove(current);
		} else {
			boyCot.add(current);
		}
	}
}

class BigCard extends StatelessWidget {
	const BigCard({super.key, required this.pair});

	final WordPair pair;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final style = theme.textTheme.displayMedium!.copyWith(
			color: theme.colorScheme.surface,
		);

		return Card(
			color: theme.colorScheme.primary,
			elevation: 5,
			child: Padding(
			padding: const EdgeInsets.all(25),
			child: Text(
					pair.asLowerCase,
					style: style,
					semanticsLabel: "${pair.first} ${pair.second}",
				),
		),
		);
	}
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	var selectedIndex = 0;

	@override
	Widget build(BuildContext context) {

		Widget page;
		switch (selectedIndex) {
			case 0:
				page = GeneratorPage();
				break;
			case 1:
				page = FavoritePage();
				break;
			case 2:
				page = BoyCotPage();
				break;
			default:
				throw UnimplementedError('no widget for $selectedIndex');
		}

	return LayoutBuilder(builder: (context, constraints) {
		return Scaffold(
			body: Row(
				children: [
					SafeArea(
				
						child: NavigationRail(
						extended: constraints.maxWidth >= 600,
							destinations: [
								NavigationRailDestination(
									icon: Icon(Icons.home),
									label: Text('Home')
								),
								NavigationRailDestination(
									icon: Icon(Icons.favorite),
									label: Text('Favorite'),
								),
								NavigationRailDestination(
									icon: Icon(Icons.boy),
									label: Text('BoyCot'),
								),
							],

							selectedIndex: selectedIndex,
							onDestinationSelected: (value) {
								setState(() {
									selectedIndex = value;
							});

							}
						),
					),

					Expanded(
						child: Container(
							color: Theme.of(context).colorScheme.primaryContainer,
							child: page,
						)
					)
				],
			),
		);
	});
	}
}

class FavoritePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();

		if(appState.favorites.isEmpty) {
			return Center(
				child: Text('No favorite yet'),
			);
		}

		return ListView(
			children: [
				Padding(
					padding: const EdgeInsets.all(20),
					child: Text("You have "
						"${appState.favorites.length} favorites:"),
					),
				for(var pair in appState.favorites) 
					ListTile(
						leading: Icon(Icons.favorite),
						title: Text(pair.asLowerCase),
					),
			]
		);
	}
}

class BoyCotPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var boycotState = context.watch<MyAppState>();

		if(boycotState.boyCot.isEmpty) {
			print("This stuff is empty");
			return Center(
				child: Text("The is no boycotted word"),	
			);
		}

		return ListView(
			children: [
				Padding(
					padding: const EdgeInsets.all(20),
					child: Text("You have "
						"${boycotState.boyCot.length} boyCot:"),
					),
				for(var pair in boycotState.boyCot) 
					ListTile(
						leading: Icon(Icons.boy),
						title: Text(pair.asLowerCase),
					),
			]
		);
	}
}

class GeneratorPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		var pair = appState.current;

		IconData iconA;
		IconData iconB;

		if(appState.favorites.contains(pair)) {
			iconA = Icons.favorite;
		} else {
			iconA = Icons.favorite_border;
		}

		if(appState.boyCot.contains(pair)) {
			iconB = Icons.boy;
		} else {
			iconB = Icons.lock;
		}

		return Scaffold(
			body: Center( 
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						BigCard(pair: pair),

						SizedBox(height: 10),

						Row(
							mainAxisSize: MainAxisSize.min,

							children: [
								ElevatedButton.icon(
									onPressed: () {
										appState.toggleFavorite();
									},
									icon: Icon(iconA),
									label: Text('like'),
								),
								ElevatedButton.icon(
									onPressed: () {
										appState.toggleBoyCot();
									},
									icon: Icon(iconB),
									label: Text("boycot"),
								),
								ElevatedButton(
								onPressed: () {
									appState.getNext();
								},
								child: Text('Next'),
							),
							]
						),//The Row ends here
					],
				),
			),
		);
	}
}

// Estas Seguro
