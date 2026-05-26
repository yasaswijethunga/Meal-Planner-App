String? validateSearch(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a search term';
  }
  if (value.trim().length < 2) {
    return 'Search term must be at least 2 characters';
  }
  if (value.trim().length > 50) {
    return 'Search term is too long (max 50 characters)';
  }
  final validPattern = RegExp(r"^[a-zA-Z0-9\s\-']+$");
  if (!validPattern.hasMatch(value.trim())) {
    return 'Only letters, numbers, spaces, and hyphens allowed';
  }
  return null;
}
