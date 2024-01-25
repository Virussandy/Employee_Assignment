class UiState {
  final bool hasData;
  final bool isLoading;
  final String? error;

  UiState({
    required this.hasData,
    this.isLoading = false,
    this.error,
  });

  factory UiState.noData() {
    return UiState(hasData: false);
  }

  factory UiState.loading() {
    return UiState(hasData: true, isLoading: true);
  }

  factory UiState.loaded() {
    return UiState(hasData: true, isLoading: false);
  }

  factory UiState.error(String error) {
    return UiState(hasData: false, isLoading: false, error: error);
  }
}