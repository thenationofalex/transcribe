#!/bin/bash

# Check for required argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <input_video_file>"
  exit 1
fi

INPUT_VIDEO="$1"
WHISPER_MODEL="medium.bin"  # fixed model filename

# Extract filename without extension
BASENAME=$(basename "$INPUT_VIDEO")
NAME="${BASENAME%.*}"

# Output audio filename
AUDIO_FILE="${NAME}.wav"

# Output transcript filename using today's date
DATE_STRING=$(date +%F)  # YYYY-MM-DD
TRANSCRIPT_FILE="${DATE_STRING}-notes.txt"

echo "🎥 Input video: $INPUT_VIDEO"
echo "🔊 Extracting audio to: $AUDIO_FILE"

# Extract audio using ffmpeg
ffmpeg -y -i "$INPUT_VIDEO" -map 0:a -c:a pcm_s16le "$AUDIO_FILE"

# Check if audio extraction succeeded
if [ ! -f "$AUDIO_FILE" ]; then
  echo "❌ Failed to extract audio."
  exit 2
fi

echo "📝 Running Whisper transcription..."
whisper-cli "$AUDIO_FILE" --model "$WHISPER_MODEL" --output-txt --output-file "$TRANSCRIPT_FILE"

echo "✅ Transcription saved to: $TRANSCRIPT_FILE"
