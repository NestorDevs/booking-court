import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../data/datasources/weather_remote.dart';
import '../controllers/sheduling_controller.dart';
import 'add_scheduling_screen.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherRemote = WeatherService();
  String rainAnimationFile = 'moderate_rain.json';

  @override
  void initState() {
    super.initState();
    final schedulingProvider =
        Provider.of<SchedulingController>(context, listen: false);
    schedulingProvider.loadScheduling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Court Reservation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Consumer<SchedulingController>(
                builder: (context, provider, _) {
                  final scheduling = provider.sheduling;
                  scheduling.sort((a, b) => a.date.compareTo(b.date));
                  if (scheduling.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 100,
                            ),
                            Text(
                              "You don't have schedules, add here",
                              style: TextStyle(fontSize: 19),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: scheduling.length,
                    itemBuilder: (BuildContext context, int index) {
                      final schedule = scheduling[index];
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(DateTime.parse(schedule.date));

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/cancha.jpg'),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      'Court: ${schedule.court}',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'User: ${schedule.user}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15),
                                          ),
                                          const SizedBox(height: 10),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Container(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 1),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.date_range,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Date: $formattedDate',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 15),
                                                  FutureBuilder<int>(
                                                    future: weatherRemote
                                                        .getRainProbability(
                                                            'Caracas',
                                                            formattedDate),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return const Text(
                                                          'Chance of rain: 0%',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      } else {
                                                        final rainProbability =
                                                            snapshot.data;

                                                        return Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.cloud,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                'Probabilidad de lluvia: $rainProbability%',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Confirm'),
                                              content: const Text(
                                                  'Do you want to delete the schedule?'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed: () {
                                                    final schedulingProvider =
                                                        Provider.of<
                                                                SchedulingController>(
                                                            context,
                                                            listen: false);
                                                    schedulingProvider
                                                        .deleteScheduling(
                                                            schedule.id);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddSchedulingScreen()),
          );
        },
        child: const Icon(Icons.border_color_outlined),
      ),
    );
  }
}
