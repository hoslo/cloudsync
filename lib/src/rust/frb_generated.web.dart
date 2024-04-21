// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.30.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/cloud_service.dart';
import 'api/config.dart';
import 'api/data.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_web.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_CloudServicePtr => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  CloudService
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic raw);

  @protected
  Map<String, String> dco_decode_Map_String_String(dynamic raw);

  @protected
  CloudService
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  int dco_decode_box_autoadd_i_64(dynamic raw);

  @protected
  Config dco_decode_config(dynamic raw);

  @protected
  Entry dco_decode_entry(dynamic raw);

  @protected
  EntryMode dco_decode_entry_mode(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  int dco_decode_i_64(dynamic raw);

  @protected
  Level dco_decode_level(dynamic raw);

  @protected
  List<Config> dco_decode_list_config(dynamic raw);

  @protected
  List<Entry> dco_decode_list_entry(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<(String, String)> dco_decode_list_record_string_string(dynamic raw);

  @protected
  LogEntry dco_decode_log_entry(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_i_64(dynamic raw);

  @protected
  (String, String) dco_decode_record_string_string(dynamic raw);

  @protected
  ServiceType dco_decode_service_type(dynamic raw);

  @protected
  int dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  CloudService
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          SseDeserializer deserializer);

  @protected
  Map<String, String> sse_decode_Map_String_String(
      SseDeserializer deserializer);

  @protected
  CloudService
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_i_64(SseDeserializer deserializer);

  @protected
  Config sse_decode_config(SseDeserializer deserializer);

  @protected
  Entry sse_decode_entry(SseDeserializer deserializer);

  @protected
  EntryMode sse_decode_entry_mode(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_64(SseDeserializer deserializer);

  @protected
  Level sse_decode_level(SseDeserializer deserializer);

  @protected
  List<Config> sse_decode_list_config(SseDeserializer deserializer);

  @protected
  List<Entry> sse_decode_list_entry(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<(String, String)> sse_decode_list_record_string_string(
      SseDeserializer deserializer);

  @protected
  LogEntry sse_decode_log_entry(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_i_64(SseDeserializer deserializer);

  @protected
  (String, String) sse_decode_record_string_string(
      SseDeserializer deserializer);

  @protected
  ServiceType sse_decode_service_type(SseDeserializer deserializer);

  @protected
  int sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          CloudService self, SseSerializer serializer);

  @protected
  void sse_encode_Map_String_String(
      Map<String, String> self, SseSerializer serializer);

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          CloudService self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_i_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_config(Config self, SseSerializer serializer);

  @protected
  void sse_encode_entry(Entry self, SseSerializer serializer);

  @protected
  void sse_encode_entry_mode(EntryMode self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_level(Level self, SseSerializer serializer);

  @protected
  void sse_encode_list_config(List<Config> self, SseSerializer serializer);

  @protected
  void sse_encode_list_entry(List<Entry> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_record_string_string(
      List<(String, String)> self, SseSerializer serializer);

  @protected
  void sse_encode_log_entry(LogEntry self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_i_64(int? self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_string(
      (String, String) self, SseSerializer serializer);

  @protected
  void sse_encode_service_type(ServiceType self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  RustLibWire.fromExternalLibrary(ExternalLibrary lib);

  void rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic ptr) =>
      wasmModule
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
              ptr);

  void rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic ptr) =>
      wasmModule
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
              ptr);
}

@JS('wasm_bindgen')
external RustLibWasmModule get wasmModule;

@JS()
@anonymous
class RustLibWasmModule implements WasmModule {
  @override
  external Object /* Promise */ call([String? moduleName]);

  @override
  external RustLibWasmModule bind(dynamic thisArg, String moduleName);

  external void
      rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic ptr);

  external void
      rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockCloudService(
          dynamic ptr);
}