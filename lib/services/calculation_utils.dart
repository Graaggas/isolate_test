List<int> sieveOfEratosthenes(int n) {
  final primes = List<bool>.filled(n + 1, true);
  for (var i = 2; i * i < n; i++) {
    if (primes[i]) {
      for (var j = i * i; j <= n; j += i) {
        primes[j] = false;
      }
    }
  }
  final res = <int>[];
  for (var i = 2; i <= n; i++) {
    if (primes[i]) {
      res.add(i);
    }
  }

  return res;
}
