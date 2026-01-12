import '../models/category.dart';
import '../models/product.dart';

const List<Category> CATEGORIES = [
  Category(id: "chicken", label: "Chicken", icon: "assets/category_icons/chicken.png"),
  Category(id: "mutton", label: "Mutton", icon: "assets/category_icons/mutton.png"),
  Category(id: "fish", label: "Fish/Sea", icon: "assets/category_icons/fish.png"),
  Category(id: "prawns", label: "Prawns", icon: "assets/category_icons/prawn.png"),
  Category(id: "crabs", label: "Crabs", icon: "assets/category_icons/crab.png"),
  Category(id: "egg", label: "Eggs", icon: "assets/category_icons/eggs.png"),
  Category(id: "coldcuts", label: "Cold Cuts", icon: "assets/category_icons/cold_cuts.png"),
  Category(id: "ready", label: "Ready to Cook", icon: "assets/category_icons/kebab.png"),
  Category(id: "masala", label: "Masala", icon: "assets/category_icons/masala.png"),
];

const List<Product> PRODUCTS = [
  Product(
    id: "1",
    category: "prebook",
    name: "Country Chicken Curry Cut (Skinless)",
    weight: "550-600 Gms",
    price: 349,
    oldPrice: 399,
    elite: true,
    image: "assets/products/curry-cut-chicken.png",
    netWeight: "500g",
    grossWeight: "550g",
    deliveryTime: "45 min",
    discountPercentage: 12,
  ),
  Product(
    id: "2",
    category: "mutton",
    name: "Goat Heart",
    weight: "150–180 Gms",
    price: 149,
    image: "assets/products/goat-heart.png",
    netWeight: "150g",
    grossWeight: "180g",
    deliveryTime: "60 min",
  ),
  Product(
    id: "3",
    category: "mutton",
    name: "Mutton Kapura",
    weight: "150–180 Gms",
    price: 119,
    oldPrice: 129,
    elite: true,
    image: "assets/products/mutton-kapura.png",
    netWeight: "150g",
    grossWeight: "180g",
    deliveryTime: "60 min",
    discountPercentage: 8,
  ),
  Product(
    id: "4",
    category: "elite",
    name: "Black Pomfret",
    weight: "150–180 Gms",
    price: 419,
    image: "assets/products/black-pomfret.jpg",
    netWeight: "300g",
    grossWeight: "350g",
    deliveryTime: "30 min",
  ),
  Product(
    id: "5",
    category: "chicken",
    name: "Country Chicken Curry Cut (Skinless)",
    weight: "550-600 Gms",
    price: 349,
    oldPrice: 399,
    elite: true,
    image: "assets/products/curry-cut-chicken.png",
    netWeight: "500g",
    grossWeight: "550g",
    deliveryTime: "45 min",
    discountPercentage: 15,
  ),
];

const List<Map<String, String>> FEATURED_COLLECTIONS = [
  {
    'title': 'Biryani Specials',
    'subtitle': 'Perfect cuts for aromatic biryani',
    'image': 'assets/products/curry-cut-chicken.png',
  },
  {
    'title': 'Grill & BBQ',
    'subtitle': 'Marinated & ready to grill',
    'image': 'assets/products/goat-heart.png',
  },
  {
    'title': 'Healthy Picks',
    'subtitle': 'Lean cuts & high protein',
    'image': 'assets/products/black-pomfret.jpg',
  },
];
