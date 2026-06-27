String priceFormat(num nombre) {
  return nombre.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ' ',
  );
}

// Utilisation :
// print(priceFormat(2300000)); // Résultat : "2 300 000"
