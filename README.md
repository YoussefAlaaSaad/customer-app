# Multi-Vendor E-Commerce — Customer App

Flutter mobile app for shoppers to browse products, manage their cart, and place orders on the multi-vendor marketplace.

## Features

- **Home** — browsing with promotional banners and product recommendations
- **Categories** — browse by category and subcategory
- **Product Details** — images, description, ratings, and related products
- **Cart** — add/remove items, manage quantities
- **Wishlist** — save products for later
- **Checkout** — delivery address, payment selection, order confirmation
- **Order History** — track order status from processing to delivery
- **Stores** — browse products from individual vendors
- **Authentication** — sign up, sign in, persistent sessions

## Tech Stack

- Flutter 3.5.3 (Dart)
- Riverpod — state management
- flutter_stripe — card payment processing
- Cash on Delivery (COD) support
- REST API via `http` package
- shared_preferences — local token storage
- google_fonts, custom_rating_bar

## Related Repositories

| Repo | Role |
|------|------|
| [backend-api](https://github.com/YoussefAlaaSaad/backend-api) | Node.js/Express REST API + MongoDB |
| **customer-app** | Flutter mobile app for shoppers |
| [vendor-app](https://github.com/YoussefAlaaSaad/vendor-app) | Flutter mobile app for vendors |
| [admin-panel](https://github.com/YoussefAlaaSaad/admin-panel) | Flutter web dashboard for admins |

## Getting Started

```bash
flutter pub get
flutter run
```

Update the API base URL in the providers/services layer to point to your backend before running.
