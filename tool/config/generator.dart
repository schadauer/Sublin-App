// @dart=2.12

import 'dart:io';

void main() {
  var templates =
      Directory.fromUri(Uri.parse('${Directory.current.uri}tool/config'));
  var generator =
      ConfigGenerator(rootDir: Directory.current, templatesDir: templates);

  generator.resolveTemplates();
}

class ConfigGenerator {
  ConfigGenerator({required this.rootDir, required this.templatesDir});

  final Directory rootDir;
  final Directory templatesDir;

  void resolveTemplates() {
    templatesDir.list(recursive: true).listen((entry) async {
      if (entry.parent.path == templatesDir.path ||
          entry is Directory ||
          entry is Link) return;

      var requestedFileUri = entry.uri.toString().replaceFirst(
          templatesDir.uri.toString(), '${rootDir.uri.toString()}');
      var sysEnvPattern = RegExp(r'%sys\.env\.(.*)%');
      var content = await (entry as File).readAsString();
      sysEnvPattern.allMatches(content).forEach((match) {
        var replace = match.group(0);
        var replacement =
            resolveSystemEnvironment(match.group(1)!, entry.toString());

        content = content.replaceAll(replace!, replacement);
      });

      var file = File.fromUri(Uri.parse(requestedFileUri));

      if (!(await file.exists())) {
        await file.create(recursive: true);
      }

      await file.writeAsString(content);
    });
  }

  String resolveSystemEnvironment(String name, String reference) {
    var envPattern = RegExp(r'\$([a-zA-Z0-9]*)');
    var value = Platform.environment[name];
    var result = value;
    if (value == null) {
      print('ERROR: No such environment variable $name in $reference');
      return '';
    } else {
      envPattern.allMatches(value).forEach((match) {
        result = result!.replaceFirst(match.group(0) ?? "",
            resolveSystemEnvironment(match.group(1) ?? "", reference));
      });
    }
    return result!;
  }
}
