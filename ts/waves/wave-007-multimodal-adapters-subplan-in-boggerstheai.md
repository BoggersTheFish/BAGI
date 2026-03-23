Wave 007 — multimodal-adapters-subplan-in-boggerstheai

**Propagate** 
Activation spread from multimodal constraints into adapter protocol boundaries and modality-specific modules for voice input, voice output, and image input.

**Relax / Tension detected** 
Primary tension was embedding-only image flow versus text-only synthesis interface. Lowest-stability node was image representation mismatch; stabilized by making caption text the primary output while allowing embedding hints.

**Break** (if applicable) 
Collapsed empty multimodal stubs and replaced the ambiguous image embedding path with explicit caption-first multimodal adapters.

**Evolve** 
Evolved a stable multimodal layer that converts non-text inputs into text before entering the core pipeline, and supports output-stage text-to-audio synthesis.

**Final stable configuration / Answer** 
Implemented the multimodal adapters subplan in `BoggersTheAI/multimodal`:
- Added `base.py` protocols:
  - `VoiceInProtocol.transcribe(audio: bytes) -> str`
  - `VoiceOutProtocol.synthesize(text: str) -> bytes`
  - `ImageInProtocol.caption(image: bytes) -> str`
- Added `voice_in.py`:
  - `VoiceInAdapter` + `VoiceInConfig` (CPU-friendly placeholder for faster-whisper/whisper.cpp/vosk backends)
- Added `voice_out.py`:
  - `VoiceOutAdapter` + `VoiceOutConfig` (placeholder output bytes compatible with Piper/edge-tts integration path)
- Added `image_in.py`:
  - `ImageInAdapter` + `ImageInConfig` with caption-first design
- Updated compatibility stubs:
  - `whisper.py` now wraps `VoiceInAdapter` as `WhisperAdapter`
  - `clip_embed.py` now wraps `ImageInAdapter` as `ClipCaptionAdapter`
- Updated `multimodal/__init__.py` exports.
- Added `multimodal/config.yaml` with enabled flags and backend configuration.

Validation:
- `python -m compileall BoggersTheAI` passed.
- No linter errors in edited multimodal files.
