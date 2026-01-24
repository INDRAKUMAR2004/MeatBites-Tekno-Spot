// ignore_for_file: constant_identifier_names

import '../models/category.dart';
import '../models/product.dart';

const List<Category> CATEGORIES = [
  Category(id: "chicken", name: "Chicken", image: "assets/category_icons/chicken.png", cutTypes: [], items: 0),
  Category(id: "mutton", name: "Mutton", image: "assets/category_icons/mutton.png", cutTypes: [], items: 0),
  Category(id: "fish", name: "Fish/Sea", image: "assets/category_icons/fish.png", cutTypes: [], items: 0),
  Category(id: "prawns", name: "Prawns", image: "assets/category_icons/prawn.png", cutTypes: [], items: 0),
  Category(id: "crabs", name: "Crabs", image: "assets/category_icons/crab.png", cutTypes: [], items: 0),
  Category(id: "egg", name: "Eggs", image: "assets/category_icons/eggs.png", cutTypes: [], items: 0),
  Category(id: "coldcuts", name: "Cold Cuts", image: "assets/category_icons/cold_cuts.png", cutTypes: [], items: 0),
  Category(id: "ready", name: "Ready to Cook", image: "assets/category_icons/kebab.png", cutTypes: [], items: 0),
  Category(id: "masala", name: "Masala", image: "assets/category_icons/masala.png", cutTypes: [], items: 0),
];

const List<Product> PRODUCTS = [
  Product(
    id: "1",
    category: "prebook",
    name: "Country Chicken Curry Cut (Skinless)",
    description: "Fresh country chicken, skinless curry cut.",
    weight: "550-600 Gms",
    price: 349,
    oldPrice: 399,
    elite: true,
    image: "assets/products/curry-cut-chicken.png",
    netWeight: "500g",
    grossWeight: "550g",
    deliveryTime: "45 min",
    discountPercentage: 12,
    isBestseller: true,
  ),
  Product(
    id: "2",
    category: "mutton",
    name: "Goat Heart",
    description: "Fresh goat heart, rich in protein.",
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
    description: "Delicacy mutton kapura.",
    weight: "150–180 Gms",
    price: 119,
    oldPrice: 129,
    elite: true,
    image: "assets/products/mutton-kapura.png",
    netWeight: "150g",
    grossWeight: "180g",
    deliveryTime: "60 min",
    discountPercentage: 8,
    isBestseller: true,
  ),
  Product(
    id: "4",
    category: "elite",
    name: "Black Pomfret",
    description: "Premium Black Pomfret fish.",
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
    description: "Fresh country chicken.",
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
