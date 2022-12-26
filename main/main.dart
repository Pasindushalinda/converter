import 'dart:io';

import 'package:converter/src/converter.dart';
import 'package:prompter_ps/prompter_ps.dart';

void main() {
  final prompter = Prompter();

  final choice = prompter.askBinary('Are you here to convert an image?');
  if (!choice) {
    exit(0);
  }

  final format = prompter.askMultiple('Select format', buildFormatOption());
  final selectedFile =
      prompter.askMultiple('Select an image to convert:', buildFileOption());

  final newPath = convertImage(selectedFile, format);

  final shouldOpen = prompter.askBinary('Open the image?');
  if (shouldOpen) {
    Process.run('explorer', [newPath]);
  }
}

List<Option> buildFormatOption() {
  return [
    new Option('Convert to jpeg', 'jpeg'),
    new Option('Convert to png', 'png'),
  ];
}

List<Option> buildFileOption() {
  return Directory.current.listSync().where((element) {
    return FileSystemEntity.isFileSync(element.path) &&
        element.path.contains(new RegExp(r'\.(png|jpg|jpeg)'));
  }).map((entity) {
    final fileName = entity.path.split(Platform.pathSeparator).last;
    return new Option(fileName, entity);
  }).toList();
}
