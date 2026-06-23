#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREVIEW_FILE="${ROOT_DIR}/preview/index.html"
OUTPUT_FILE="${ROOT_DIR}/theme/screenshot.png"
FALLBACK_FILE="${ROOT_DIR}/assets/wp-vibecoder-default-screenshot.png"

use_default_screenshot() {
	local reason="$1"
	echo "WARNING: ${reason}" >&2

	if [[ ! -f "${FALLBACK_FILE}" ]]; then
		echo "ERROR: Default screenshot is missing: ${FALLBACK_FILE}" >&2
		exit 1
	fi

	cp "${FALLBACK_FILE}" "${OUTPUT_FILE}"
	echo "Using the default WP Vibecoder screenshot: ${OUTPUT_FILE}" >&2
	exit 0
}

if [[ "${WP_VIBECODER_USE_DEFAULT_SCREENSHOT:-0}" == "1" ]]; then
	use_default_screenshot "Default screenshot was explicitly requested for this environment."
fi

[[ -f "${PREVIEW_FILE}" ]] || use_default_screenshot "Preview not found; screenshot generation was skipped."

if [[ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
	CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif command -v google-chrome >/dev/null 2>&1; then
	CHROME="$(command -v google-chrome)"
elif command -v chromium >/dev/null 2>&1; then
	CHROME="$(command -v chromium)"
elif command -v chromium-browser >/dev/null 2>&1; then
	CHROME="$(command -v chromium-browser)"
else
	use_default_screenshot "Google Chrome or Chromium is unavailable; screenshot generation was skipped."
fi

if ! "${CHROME}" \
	--headless=new \
	--disable-gpu \
	--no-sandbox \
	--hide-scrollbars \
	--force-device-scale-factor=1 \
	--window-size=1200,900 \
	--screenshot="${OUTPUT_FILE}" \
	"file://${PREVIEW_FILE}"; then
	use_default_screenshot "Chrome could not render the preview in this environment."
fi

[[ -s "${OUTPUT_FILE}" ]] || use_default_screenshot "Chrome completed without producing a screenshot."

echo "Generated ${OUTPUT_FILE} (1200x900)."
