# Inventory Management UI - Clean Architecture

## Overview

This is a pure **Presentation Layer** UI implementation following **Clean Architecture** principles. The code is designed to be maintainable, testable, and easily adaptable to your business logic.

## File Structure

```
lib/presentation/inventory/
├── pages/
│   └── inventory_page.dart          # Main page screen
└── widgets/
    ├── ask_ai_fab.dart              # Floating Action Button (Ask AI)
    ├── category_filter_tabs.dart     # Filter tabs (All, Low Stock, Out)
    ├── product_list_item.dart        # Individual product card
    ├── product_search_bar.dart       # Search input widget
    └── stock_status_badge.dart       # Status badge (In Stock, Low, Out)
```

## Component Breakdown

### 1. **inventory_page.dart** (Main Screen)
- **Purpose**: Orchestrates all UI components and mock data
- **State Management**: Uses `StatefulWidget` with local state for filtering and searching
- **Features**:
  - Product list with mock data
  - Real-time filtering by category
  - Search functionality (by product name or SKU)
  - Empty state handling
  - AppBar with back button and action icons

### 2. **product_list_item.dart** (Product Card)
- **Purpose**: Displays individual product information
- **Contains**:
  - Product image (with placeholder fallback)
  - Product name and price
  - Stock status badge
  - Edit and delete action buttons
- **Customization**: Pass different `Product` objects with various data

### 3. **stock_status_badge.dart** (Status Badge)
- **Purpose**: Renders colored status indicators
- **Status Types**:
  - ✅ `inStock` (Green) → "15 IN STOCK"
  - ⚠️ `lowStock` (Orange) → "3 IN STOCK"
  - ❌ `outOfStock` (Red) → "OUT OF STOCK"
- **Reusable**: Can be used anywhere status needs to be displayed

### 4. **product_search_bar.dart** (Search Input)
- **Purpose**: Provides real-time search functionality
- **Features**:
  - Live filtering as user types
  - Clear button for easy reset
  - Placeholder text for UX guidance
  - Accessible and responsive

### 5. **category_filter_tabs.dart** (Filter Tabs)
- **Purpose**: Allows filtering products by category
- **Options**:
  - All Products
  - Low Stock
  - Out of Stock
- **Visual Feedback**: Active tab is highlighted in purple

### 6. **ask_ai_fab.dart** (Floating Action Button)
- **Purpose**: Floating action button for AI assistance
- **Styling**: Purple background with white icon
- **Extensible**: Easy to connect to AI logic later

## Color Palette

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary | Purple | #5E49BF |
| Background | Light Gray | #F5F5F5 |
| Text Primary | Dark Gray | #1A1A1A |
| Text Secondary | Medium Gray | #666666 |
| Status In Stock | Green | #2E7D32 |
| Status Low | Orange | #E65100 |
| Status Out | Red | #C62828 |
| Border | Light | #E0E0E0 |

## Typography

- **Titles**: 16sp, FontWeight.w700
- **Subtitles**: 14sp, FontWeight.w600
- **Body**: 13-14sp, FontWeight.w400 to w600
- **Labels**: 11-12sp, FontWeight.w600

## Mock Data

The `inventory_page.dart` includes 6 sample products:

```dart
1. Velocity Elite Running Shoes - $149.00 (15 IN STOCK)
2. Nordic Desk Lamp - $85.00 (3 IN STOCK) ⚠️
3. Studio Pro Wireless Headphones - $299.00 (OUT OF STOCK) ❌
4. Horizon Watch Classic - $210.00 (42 IN STOCK)
5. Premium USB-C Cable - $29.99 (1 IN STOCK) ⚠️
6. Smart Home Hub Pro - $189.00 (OUT OF STOCK) ❌
```

## Key Features

✅ **Responsive Design**: Uses `flutter_screenutil` for all dimensions
✅ **Modular Widgets**: Each component is independent and reusable
✅ **Mock Data**: Pre-populated with realistic product data
✅ **Real-time Filtering**: Live search and category filtering
✅ **Status Indicators**: Color-coded stock status
✅ **Empty States**: Graceful handling when no products match filters
✅ **User Interactions**: Clickable elements with snackbar feedback (for demo)
✅ **Smooth Animations**: Rounded corners and subtle shadows

## How to Integrate with Business Logic

### Step 1: Connect State Management (BLoC)
Replace the `StatefulWidget` in `inventory_page.dart` with `BlocBuilder`:

```dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<ProductsBloc, ProductsState>(
    builder: (context, state) {
      if (state is ProductsLoading) return const LoadingWidget();
      if (state is ProductsError) return ErrorWidget(error: state.message);
      if (state is ProductsSuccess) {
        return _buildProductList(state.products);
      }
      return const SizedBox();
    },
  );
}
```

### Step 2: Connect API Data
Replace `_getMockProducts()` with API calls:

```dart
void _fetchProducts() {
  context.read<ProductsBloc>().add(FetchProductsEvent());
}
```

### Step 3: Connect Actions
Update button callbacks to trigger real actions:

```dart
onEditPressed: () {
  context.read<ProductsBloc>().add(EditProductEvent(product));
  context.router.push(EditProductRoute(product: product));
}
```

## Customization

### Changing Colors
Update the color hex codes in each widget:
```dart
backgroundColor: const Color(0xFF5E49BF),  // Change this
```

### Adding More Filters
Extend `FilterCategory` enum in `category_filter_tabs.dart`:
```dart
enum FilterCategory {
  all,
  lowStock,
  outOfStock,
  onSale,  // ← New category
}
```

### Custom Product Fields
Extend the `Product` class in `product_list_item.dart`:
```dart
class Product {
  // ...existing fields...
  final String? sku;
  final String? category;
  final DateTime? createdAt;
}
```

## Performance Considerations

- **ListView.builder**: Renders only visible items (memory efficient)
- **Image Caching**: Uses Flutter's built-in network image caching
- **Memoization**: Filters are applied only when dependencies change
- **Lazy Loading**: Empty state checks prevent unnecessary rendering

## Testing

Each widget can be tested independently:

```dart
testWidgets('ProductListItem renders correctly', (WidgetTester tester) async {
  final product = Product(...);
  await tester.pumpWidget(
    MaterialApp(home: ProductListItem(product: product))
  );
  expect(find.byType(ProductListItem), findsOneWidget);
});
```

## Next Steps

1. ✅ UI Layer (Complete - this file)
2. ⏭️ Connect BLoC State Management
3. ⏭️ Implement Data Layer (API/Database)
4. ⏭️ Add Navigation Routes
5. ⏭️ Implement Real Search/Filter Logic
6. ⏭️ Add Unit & Widget Tests

---

**Author Notes**: This UI is production-ready for the presentation layer. All business logic integration points are clearly marked with comments. Enjoy building! 🚀

