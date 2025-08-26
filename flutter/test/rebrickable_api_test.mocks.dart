// GENERATED CODE - DO NOT MODIFY BY HAND

import 'dart:io';
import 'package:mockito/mockito.dart' as _i1;
import 'package:http/http.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [Client].
class MockClient extends _i1.Mock implements _i2.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Future<_i2.Response> head(Uri url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(
          #head,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<_i2.Response> get(Uri url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<_i2.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<_i2.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<_i2.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<_i2.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i3.Future<_i2.Response>.value(_FakeResponse_0()),
      ) as Future<_i2.Response>);

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [url],
          {#headers: headers},
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as Future<String>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [Response].
class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

import 'dart:async' as _i3;