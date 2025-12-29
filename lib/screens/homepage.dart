import 'package:flutter/material.dart';
import '../services/api_serv.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const HomePage({super.key, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController ipController = TextEditingController();
  Map<String, dynamic>? geoData;
  List<String> history = [];
  Set<String> selectedIps = {};
  bool get isAllSelected =>
      history.isNotEmpty && selectedIps.length == history.length;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGeo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IP Geolocation System"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      labelText: "Enter IP address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: fetchGeo,
                  child: const Text("Search"),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: clearSearch,
                  child: const Text("Clear"),
                ),
              ],
            ),

            const SizedBox(height: 16),
            if (geoData != null) geoInfo(),

            const SizedBox(height: 12),
            if (selectedIps.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedIps.length} selected",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: deleteSelected,
                    ),
                  ],
                ),
              ),

            const Divider(),

            if (history.isNotEmpty)
              CheckboxListTile(
                title: const Text("Select All"),
                value: isAllSelected,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedIps = history.toSet();
                    } else {
                      selectedIps.clear();
                    }
                  });
                },
              ),

            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        "No history yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : historyList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget geoInfo() {
    return Column(
      children: [
        // IP ADDRESS
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.public, color: Colors.blue),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "IP Address",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(geoData!['ip'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),

        // CITY
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.location_city, color: Colors.green),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "City",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(geoData!['city'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),

        // REGION
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.map, color: Colors.orange),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Region",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(geoData!['region'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),

        // COUNTRY
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.flag, color: Colors.purple),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Country",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(geoData!['country'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),

        // POSTAL
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.local_post_office, color: Colors.red),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Postal Code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(geoData!['postal'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget historyList() {
    return ListView(
      children: history.map((ip) {
        return GestureDetector(
          onLongPress: () {
            setState(() {
              selectedIps.add(ip);
            });
          },
          child: CheckboxListTile(
            title: Text(ip),
            value: selectedIps.contains(ip),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  selectedIps.add(ip);
                } else {
                  selectedIps.remove(ip);
                }
              });
            },
            secondary: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ipController.text = ip;
                fetchGeo();
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  bool isValidIP(String ip) {
    final regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    return regex.hasMatch(ip);
  }

  Future<void> fetchGeo() async {
    final ip = ipController.text.trim();

    if (ip.isNotEmpty && !isValidIP(ip)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid IP address")));
      return;
    }

    final data = await ApiService.getGeo(ip);

    if (data != null) {
      setState(() {
        geoData = data;
        if (ip.isNotEmpty && !history.contains(ip)) {
          history.add(ip);
        }
      });
    }
  }

  void clearSearch() {
    ipController.clear();
    fetchGeo();
  }

  void deleteSelected() {
    setState(() {
      history.removeWhere((ip) => selectedIps.contains(ip));
      selectedIps.clear();
    });
  }
}
