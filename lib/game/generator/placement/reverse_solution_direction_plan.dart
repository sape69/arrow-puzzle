import '../../arrow.dart';

class ReverseSolutionDirectionPlan {
const ReverseSolutionDirectionPlan({
required this.directions,
});

final List<ArrowDirection> directions;

int get length => directions.length;

bool get isEmpty => directions.isEmpty;

bool get isNotEmpty => directions.isNotEmpty;

ArrowDirection operator [](int index) {
return directions[index];
}

List<ArrowDirection> get orderedDirections {
return List<ArrowDirection>.unmodifiable(
directions,
);
}

ReverseSolutionDirectionPlan copy() {
return ReverseSolutionDirectionPlan(
directions: List<ArrowDirection>.from(
directions,
),
);
}

@override
bool operator ==(Object other) {
if (identical(this, other)) {
return true;
}

if (other is! ReverseSolutionDirectionPlan) {
  return false;
}

if (other.directions.length != directions.length) {
  return false;
}

for (var index = 0;
    index < directions.length;
    index++) {
  if (other.directions[index] != directions[index]) {
    return false;
  }
}

return true;

}

@override
int get hashCode {
var result = 17;

for (final direction in directions) {
  result = 31 * result + direction.hashCode;
}

return result;

}

@override
String toString() {
return 'ReverseSolutionDirectionPlan('
'length: $length'
')';
}
}