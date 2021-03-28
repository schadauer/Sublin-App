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
        var replacement = Platform.environment[match.group(1)];

        if (replacement == null) {
          print(
              'ERROR: No such environment variable ${match.group(1)} in $entry');
        } else {
          content = content.replaceAll(replace!, replacement);
        }
      });

      var file = File.fromUri(Uri.parse(requestedFileUri));

      if (!(await file.exists())) {
        await file.create(recursive: true);
      }

      await file.writeAsString(content);
    });
  }
}
