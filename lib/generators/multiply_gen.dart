import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:emer_app/annotations/multiply_annotation.dart';
import 'package:source_gen/source_gen.dart';

class MultiplierGenerator extends GeneratorForAnnotation<Multiplier> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final numValue = annotation.read('value').literalValue;

    return 'num ${element.name}Multiplied() => ${element.name} * $numValue;';
  }
}

Builder multiplyBuilder(BuilderOptions options) =>
    SharedPartBuilder([MultiplierGenerator()], 'multiply');
