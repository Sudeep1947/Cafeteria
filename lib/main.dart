import 'package:flutter/material.dart';

void main() {
  runApp(const CafeApp());
}

class CafeApp extends StatefulWidget {
  const CafeApp({super.key});

  @override
  State<CafeApp> createState() => _CafeAppState();
}

class _CafeAppState extends State<CafeApp> {
  // --- ✨ Dark Theme Management ---
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Cafe',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark().copyWith(
        // Custom dark theme styling
        primaryColor: Colors.brown[800],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
          primary: Colors.brown[600]!,
          secondary: Colors.amber[300]!,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.brown[900]),
        cardColor: Colors.brown[700],
      ) : ThemeData.light().copyWith(
        // Custom light theme styling
        primaryColor: Colors.brown[300],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
          primary: Colors.brown[500]!,
          secondary: Colors.amber[600]!,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.brown[400]),
      ),
      home: MainScreen(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  // --- ✨ Navigation bar (Home, Menu, About, Contact) ---
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MenuPage(),
    AboutPage(),
    ContactPage(),
    // Placeholder for Login/Admin, handled by state logic below
  ];
  
  bool _isLoggedIn = false;
  bool _isAdmin = false; // Mock admin status

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // --- Login Simulation ---
  void _login(String username, String password) {
    if (username == 'admin' && password == 'password') {
      setState(() {
        _isLoggedIn = true;
        _isAdmin = true;
        _selectedIndex = 0; // Go to home after login
      });
    } else if (username == 'user' && password == 'password') {
       setState(() {
        _isLoggedIn = true;
        _isAdmin = false;
        _selectedIndex = 0; // Go to home after login
      });
    } else {
      // Show error (in a real app)
    }
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _isAdmin = false;
    });
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // --- ✨ Animations setup ---
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Stylish Cafe'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
        ],
      ),
      // Use a custom view based on state
      body: _isLoggedIn && _isAdmin && _selectedIndex == 4 ? AdminPanelPage() :
            _isLoggedIn && !_isAdmin && _selectedIndex == 4 ? OnlineOrderingPage() :
            !_isLoggedIn && _selectedIndex == 4 ? LoginPage(onLogin: _login) :
            Center(child: _widgetOptions.elementAt(_selectedIndex)),
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
           BottomNavigationBarItem(
            icon: Icon(_isLoggedIn ? (_isAdmin ? Icons.admin_panel_settings : Icons.shopping_cart) : Icons.login),
            label: _isLoggedIn ? (_isAdmin ? 'Admin' : 'Order') : 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Essential for web layout
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
    );
  }
}

// --- Home Page with Animations ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example of a simple animation using an existing widget
            Hero(
              tag: 'cafe_logo',
              child: Icon(
                Icons.coffee,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Stylish Cafe!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your daily dose of caffeine and elegance.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Menu Page ---
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  final List<Map<String, String>> menuItems = const [
    {'name': 'Espresso', 'price': '\$2.50', 'desc': 'Strong coffee shot.'},
    {'name': 'Latte', 'price': '\$4.00', 'desc': 'Espresso with steamed milk.'},
    {'name': 'Cappuccino', 'price': '\$4.00', 'desc': 'Espresso, milk, and foam.'},
    {'name': 'Cheesecake', 'price': '\$5.50', 'desc': 'Classic New York style.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text(item['name']!),
            subtitle: Text(item['desc']!),
            trailing: Text(item['price']!, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
            onTap: () {
              // Online ordering interaction placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Added ${item['name']} to cart (Placeholder)')),
              );
            },
          ),
        );
      },
    );
  }
}

// --- About Page ---
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'We started in 2023 with a mission to serve the best coffee in town. We focus on sustainable sourcing and great customer experiences.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// --- Contact Page ---
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Cafeteria , Bengaluru, Anjananagar'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('+91 1234567891'),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('contact@stylishcafe.com'),
          ),
        ],
      ),
    );
  }
}

// --- ✨ Login Page UI ---
class LoginPage extends StatefulWidget {
  final Function(String, String) onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 400, // Constrain width for web aesthetic
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login to Your Account',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username (try "admin" or "user")',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password (use "password")',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      widget.onLogin(
                        _usernameController.text,
                        _passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// --- ✨ Online Ordering UI (User View) ---
class OnlineOrderingPage extends StatelessWidget {
  const OnlineOrderingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 100, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 20),
          Text('Your Order Cart', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          const Text('Items in cart: 2'), // Mock data
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Checkout Logic
              ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Proceeding to checkout... (Placeholder)')),
              );
            },
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}

// --- ✨ Admin Panel UI (Admin View) ---
class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.add_box, color: Theme.of(context).colorScheme.primary),
              title: const Text('Add New Menu Item'),
              subtitle: const Text('Click here to manage inventory and add items.'),
              onTap: () {
                // Add Item Logic UI
                 ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Opening Add Item Form... (Placeholder)')),
                );
              },
            ),
          ),
           Card(
            child: ListTile(
              leading: Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
              title: const Text('View Sales Analytics'),
              subtitle: const Text('Monitor daily/weekly sales reports.'),
              onTap: () {
                // View Analytics Logic
                 ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Loading Analytics Dashboard... (Placeholder)')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}