enum ServiceStatus {
  unknown(value: -1, name: 'Desconocido'),
  pending(value: 1, name: 'Pendiente'),
  finished(value: 2, name: 'Terminado'),
  delivered(value: 3, name: 'Entregado');

  const ServiceStatus({
    required int value,
    required String name,
  })  : _value = value,
        _name = name;

  final int _value;
  final String _name;

  int get value => _value;
  String get name => _name;

  static ServiceStatus getStatus(int value) {
    return ServiceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ServiceStatus.unknown,
    );
  }

  static List<ServiceStatus> get validStatuses {
    return [
      ServiceStatus.pending,
      ServiceStatus.finished,
      ServiceStatus.delivered,
    ];
  }
}
