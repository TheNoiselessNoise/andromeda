// App {
//   // Základní konfigurace
//   config {
//     name: "MyEspoCRM"
//     version: "1.0.0"
//     apiUrl: "https://..."
//     theme: "light"
//   }

//   // Globální state dostupný napříč aplikací
//   globalState {
//     $currentUser: null
//     $permissions: []
//     $settings: {}
//   }

//   // Globální error handling
//   onError ($error) {
//     #log($error)
//     #show_error($error)
//   }

//   // Definice routingu
//   routing {
//     initialRoute: "/dashboard"
    
//     routes {
//       "/dashboard": $dashboardPage
//       "/goods": $goodsListPage
//       "/settings": $settingsPage
//     }
//   }

//   // Hlavní layout aplikace
//   layout {
//     // Drawer konfigurace
//     drawer {
//       enabled: true
//       items: [
//         { label: "Dashboard", route: "/dashboard" },
//         { label: "Goods", route: "/goods" }
//       ]
//     }

//     // Bottom navigation
//     bottomNav {
//       enabled: false
//     }
//   }

//   // Inicializační logika
//   init {
//     $user = #auth_get_current_user()
//     globalState.$currentUser = $user
//     globalState.$permissions = #auth_get_permissions($user)
//   }

//   // API konfigurace
//   api {
//     interceptors {
//       request ($req) {
//         #add_header($req, "Authorization", #get_token())
//       }
      
//       response ($res) {
//         if (#status_code($res) == 401) {
//           #navigate("/login")
//         }
//       }
//     }
//   }
// }