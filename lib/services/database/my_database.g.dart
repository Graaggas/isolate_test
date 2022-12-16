// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Measure extends DataClass implements Insertable<Measure> {
  final int id;
  final String number;
  final String amount;
  final String timer;
  const Measure(
      {required this.id, required this.number, required this.amount, required this.timer});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<String>(number);
    map['amount'] = Variable<String>(amount);
    map['timer'] = Variable<String>(timer);
    return map;
  }

  MeasuresCompanion toCompanion(bool nullToAbsent) {
    return MeasuresCompanion(
      id: Value(id),
      number: Value(number),
      amount: Value(amount),
      timer: Value(timer),
    );
  }

  factory Measure.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      amount: serializer.fromJson<String>(json['amount']),
      timer: serializer.fromJson<String>(json['timer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<String>(number),
      'amount': serializer.toJson<String>(amount),
      'timer': serializer.toJson<String>(timer),
    };
  }

  Measure copyWith({int? id, String? number, String? amount, String? timer}) => Measure(
        id: id ?? this.id,
        number: number ?? this.number,
        amount: amount ?? this.amount,
        timer: timer ?? this.timer,
      );
  @override
  String toString() {
    return (StringBuffer('Measure(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('amount: $amount, ')
          ..write('timer: $timer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, amount, timer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measure &&
          other.id == this.id &&
          other.number == this.number &&
          other.amount == this.amount &&
          other.timer == this.timer);
}

class MeasuresCompanion extends UpdateCompanion<Measure> {
  final Value<int> id;
  final Value<String> number;
  final Value<String> amount;
  final Value<String> timer;
  const MeasuresCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.amount = const Value.absent(),
    this.timer = const Value.absent(),
  });
  MeasuresCompanion.insert({
    this.id = const Value.absent(),
    required String number,
    required String amount,
    required String timer,
  })  : number = Value(number),
        amount = Value(amount),
        timer = Value(timer);
  static Insertable<Measure> custom({
    Expression<int>? id,
    Expression<String>? number,
    Expression<String>? amount,
    Expression<String>? timer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (amount != null) 'amount': amount,
      if (timer != null) 'timer': timer,
    });
  }

  MeasuresCompanion copyWith(
      {Value<int>? id, Value<String>? number, Value<String>? amount, Value<String>? timer}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      amount: amount ?? this.amount,
      timer: timer ?? this.timer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (timer.present) {
      map['timer'] = Variable<String>(timer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasuresCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('amount: $amount, ')
          ..write('timer: $timer')
          ..write(')'))
        .toString();
  }
}

class $MeasuresTable extends Measures with TableInfo<$MeasuresTable, Measure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasuresTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>('number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>('amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _timerMeta = const VerificationMeta('timer');
  @override
  late final GeneratedColumn<String> timer = GeneratedColumn<String>('timer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, number, amount, timer];
  @override
  String get aliasedName => _alias ?? 'measures';
  @override
  String get actualTableName => 'measures';
  @override
  VerificationContext validateIntegrity(Insertable<Measure> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta, number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('timer')) {
      context.handle(_timerMeta, timer.isAcceptableOrUnknown(data['timer']!, _timerMeta));
    } else if (isInserting) {
      context.missing(_timerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Measure(
      id: attachedDatabase.options.types.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      amount: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      timer: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}timer'])!,
    );
  }

  @override
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  _$MyDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $MeasuresTable measures = $MeasuresTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [measures];
}
