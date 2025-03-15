import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_generate_app/feature/prompt/repos/prompt_repo.dart';
import 'package:meta/meta.dart';
part 'prompt_event.dart';
part 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<PrompInitialEvent>(promptInitialEvent);
    on<PromptEnterEvent>(promptEnterEvent);
  }

  FutureOr<void> promptEnterEvent(
      PromptEnterEvent event, Emitter<PromptState> emit) async {
    emit(PromptGeneratingImageLoadState());
    Uint8List? bytes = await PromptRepo.generateImage(event.prompt);
    if (bytes != null) {
      emit(PromptGeneratingImageSuccessState(bytes));
    } else {
      emit(PromptGeneratingImageErrorState());
    }
  }

  FutureOr<void> promptInitialEvent(
      PrompInitialEvent event, Emitter<PromptState> emit) async {
        try {
    ByteData data = await rootBundle.load('assets/file.png'); // Load asset
    Uint8List bytes = data.buffer.asUint8List();
    emit(PromptGeneratingImageSuccessState(bytes)); // Emit loaded image
  } catch (e) {
    emit(PromptGeneratingImageErrorState());
  }
  }
}
