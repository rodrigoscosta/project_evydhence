import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/views/dashboard_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomePage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitializing = true;
  final zoomProvider = GetIt.I<ZoomProvider>();

  @override
  void didChangeDependencies() {
    if (_isInitializing) {
      _initialization();
    }
    super.didChangeDependencies();
  }

  void _initialization() {
    _isInitializing = false;
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 24.0 * zoomProvider.scaleFactor,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          tooltip: 'Voltar',
          iconSize: 28.0 * zoomProvider.scaleFactor,
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: _buildAppBarActions(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0 * zoomProvider.scaleFactor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildLargeButton(
              text: 'CLIENTES',
              icon: Icons.people,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.clientPage);
              },
            ),
            const SizedBox(height: 20),
            _buildLargeButton(
              text: 'DASHBOARD',
              icon: Icons.dashboard,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.dashboardPage);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
                color: widget.isDarkMode ? Colors.white : Colors.black,
                size: 28.0 * zoomProvider.scaleFactor,
              ),
              Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  _toggleTheme(value);
                },
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
                activeTrackColor: Colors.blueAccent,
              ),
              // Botão de Zoom
              IconButton(
                iconSize: 28.0 * zoomProvider.scaleFactor,
                tooltip: 'Aumentar zoom',
                icon: Icon(
                  Icons.zoom_in,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    zoomProvider.increaseZoom();
                  });
                },
              ),
              IconButton(
                iconSize: 28.0 * zoomProvider.scaleFactor,
                tooltip: 'Diminuir zoom',
                icon: Icon(
                  Icons.zoom_out,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    zoomProvider.decreaseZoom();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }

  Widget _buildLargeButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Button(
      flavor: ButtonFlavor.elevated,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 24 * zoomProvider.scaleFactor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color.fromRGBO(250, 70, 22, 1),
        //backgroundColor: widget.isDarkMode ? Colors.blueGrey[800] : Colors.blue,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28 * zoomProvider.scaleFactor,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16.0 * zoomProvider.scaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}
