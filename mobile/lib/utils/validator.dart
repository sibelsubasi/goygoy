import 'dart:io';

class Validator {
  List<String> _rules = new List();
  Map<dynamic, dynamic> _extras = new Map();

  Validator() {
    _rules.clear();
    _extras.clear();
  }

  Validator required() {
    _rules.add("required");
    return this;
  }

  Validator selected() {
    _rules.add("selected");
    return this;
  }

  Validator number() {
    _rules.add('number');
    return this;
  }

  Validator int_() {
    _rules.add('int');
    return this;
  }

  Validator hasFile() {
    _rules.add('hasFile');
    return this;
  }


  Validator alpha() {
    _rules.add('alpha');
    return this;
  }


  Validator alphaDash() {
    _rules.add('alphaDash');
    return this;
  }


  Validator alphaNum() {
    _rules.add('alphaNum');
    return this;
  }


  Validator between(double start, double end) {
    _rules.add("between");
    _extras['between'] = {start: start, end: end};
    return this;
  }


  Validator different(String d) {
    _rules.add("different");
    _extras['different'] = d;
    return this;
  }


  Validator digits(int length) {
    _rules.add("digits");
    _extras['digits'] = length;
    return this;
  }


  Validator digitsBetween(int start, int end) {
    _rules.add("digitsBetween");
    _extras['digits'] = {'start': start, 'end': end};
    return this;
  }

  Validator minSize(int length) {
    _rules.add("minSize");
    _extras['minSize'] = length;
    return this;
  }

  Validator maxSize(int length) {
    _rules.add("maxSize");
    _extras['maxSize'] = length;
    return this;
  }

  Validator sizeBetween(int start, int end) {
    _rules.add("sizeBetween");
    _extras['sizes'] = {'start': start, 'end': end};
    return this;
  }

  Validator size(String d) {
    _rules.add("size");
    _extras['size'] = d;
    return this;
  }


  Validator in_(dynamic d) {
    _rules.add("in");
    _extras['in'] = d;
    return this;
  }


  Validator notIn(dynamic d) {
    _rules.add("notIn");
    _extras['notIn'] = d;
    return this;
  }


  Validator ip() {
    _rules.add("ip");
    return this;
  }


  Validator max(double d) {
    _rules.add("max");
    _extras['max'] = d;
    return this;
  }

  Validator min(double d) {
    _rules.add("min");
    _extras['min'] = d;
    return this;
  }

  Validator same(String value, String field) {
    _rules.add("same");
    _extras['same'] = {'value': value, 'field': field};
    return this;
  }


  Validator regex(RegExp reg) {
    _rules.add("regex");
    _extras['regex'] = reg;
    return this;
  }

  ///////////////////////////////////
  // Actual Validators Begins Here //
  ///////////////////////////////////
  String validate(value) {
    print("validating $value");
    if (_rules.isEmpty) {
      return null;
    }
    String lastError;
    for (int i = 0; i < _rules.length; i++) {
      String v = _rules[i];

      lastError = null;
      switch (v) {
        case "required":
          lastError = _required(value);
          break;
        case "selected":
          lastError = _selected(value);
          break;
        case "number":
          lastError = _number(value);
          break;
        case "int":
          lastError = _int(value);
          break;
        case "hasFile":
          lastError = _hasFile(value);
          break;
        case "min":
          lastError = _min(value.toString());
          break;
        case "minSize":
          lastError = _minSize(value.toString());
          break;
        case "size":
          lastError = _size(value.toString());
          break;
        case "maxSize":
          lastError = _maxSize(value.toString());
          break;
        case "sizeBetween":
          lastError = _sizeBetween(value.toString());
          break;
        case "same":
          lastError = _same(value.toString());
          break;
      }
      if (lastError != null) {
        print("Error found and returning error: $lastError");
        break;
      }
    }
    return lastError;
  }

  String _required(dynamic value) {
    if (value != null && value.toString().trim().isNotEmpty) {
      return null;
    }
    return 'Bu alan gerekli';
  }

  String _selected(dynamic value) {
    if (_required(value) != null) {
      return 'Lütfen seçin.';
    }
    return null;
  }

  String _same(String value) {
    print(_extras['same']);
    return value == _extras['same']['value'] ? null : '"' + _extras['same']['field'] + '"' + " ile aynı değeri taşımalı";
  }

  String _size(String value, {int size}) {
    size == null ? size = _extras['size'] : size = size;

    return value.length != size ? "$size hane olmalı" : null;
  }

  String _minSize(String value, {int size}) {
    size == null ? size = _extras['minSize'] : size = size;

    return value.length < size ? "En az $size hane olmalı" : null;
  }

  String _maxSize(String value, {int size}) {
    size == null ? size = _extras['minSize'] : size = size;

    return value.length > size ? "En fazla $size hane olmalı" : null;
  }

  String _sizeBetween(String value) {
    if (_minSize(value, size: _extras['sizes']['start']) != null || _maxSize(value, size: _extras['sizes']['end']) != null) {
      return _extras['sizes']['start'] + " ile " + _extras['sizes']['end'] + " arası olmalıdır";
    }
    return null;
  }

  String _number(String value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    double num;
    try {
      num = double.parse(value);
    } catch (e) {}
    if (num == null) {
      return '"$value" geçerli bir sayı değil';
    }
    return null;
  }

  String _min(String value) {
    String numRes = _number(value);
    if (numRes != null) {
      return numRes;
    }
    double num = double.parse(value);
    if (num < _extras['min']) {
      return '"$value" değeri ${_extras['min']}den büyük olmalıdır.';
    }
    return null;
  }

  String _int(String value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    int num;
    try {
      num = int.parse(value);
    } catch (e) {}
    if (num == null) {
      return '"$value" geçerli bir tam sayı değil';
    }
    return null;
  }

  String _hasFile(File value) {
    if (value == null || !(value is File) || !value.existsSync() || value.lengthSync() < 1) {
      return "Bir dosya seçmelisiniz";
    }
    return null;
  }
}
