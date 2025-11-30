// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetItemAdapter extends TypeAdapter<BudgetItem> {
  @override
  final int typeId = 0;

  @override
  BudgetItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetItem(
      id: fields[0] as String,
      itemName: fields[1] as String,
      picName: fields[2] as String,
      yearlyBudget: fields[3] as double,
      frequency: fields[4] as int,
      activeMonths: (fields[5] as List).cast<int>(),
      createdAt: fields[7] as DateTime?,
      lastUpdated: fields[8] as DateTime?,
      notes: fields[9] as String?,
    )..monthlyWithdrawals = (fields[6] as Map).cast<int, double>();
  }

  @override
  void write(BinaryWriter writer, BudgetItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.picName)
      ..writeByte(3)
      ..write(obj.yearlyBudget)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.activeMonths)
      ..writeByte(6)
      ..write(obj.monthlyWithdrawals)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastUpdated)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
