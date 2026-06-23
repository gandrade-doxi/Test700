#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="${ROOT_DIR}/theme"
CONFIG_FILE="${ROOT_DIR}/wp-vibecoder.json"
FALLBACK_SCREENSHOT="${ROOT_DIR}/assets/wp-vibecoder-default-screenshot.png"
WARNINGS=0

fail() {
	echo "ERROR: $*" >&2
	exit 1
}

warn() {
	echo "WARNING: $*" >&2
	WARNINGS=$((WARNINGS + 1))
}

required_files=(
	"agent.md"
	"AGENTS.md"
	"CLAUDE.md"
	"wp-vibecoder.json"
	"theme/style.css"
	"theme/functions.php"
	"theme/page-home.php"
	"theme/page.php"
	"theme/single.php"
	"theme/index.php"
	"theme/header.php"
	"theme/footer.php"
	"assets/wp-vibecoder-default-screenshot.png"
)

for file in "${required_files[@]}"; do
	[[ -f "${ROOT_DIR}/${file}" ]] || fail "Missing required file: ${file}"
done

if [[ ! -f "${THEME_DIR}/screenshot.png" ]]; then
	warn "theme/screenshot.png is missing; restoring the default WP Vibecoder image."
	cp "${FALLBACK_SCREENSHOT}" "${THEME_DIR}/screenshot.png"
fi

for forbidden in "theme/front-page.php" "theme/home.php"; do
	[[ ! -e "${ROOT_DIR}/${forbidden}" ]] || fail "Forbidden V1 template found: ${forbidden}"
done

if command -v php >/dev/null 2>&1; then
	php -r '
		$file = $argv[1];
		$data = json_decode(file_get_contents($file), true);
		if (!is_array($data) || json_last_error() !== JSON_ERROR_NONE) {
			fwrite(STDERR, "Invalid wp-vibecoder.json\n");
			exit(1);
		}
		if (isset($data["requires"]["plugins"])) {
			if (!is_array($data["requires"]["plugins"])) {
				fwrite(STDERR, "wp-vibecoder.json requires.plugins must be an array\n");
				exit(1);
			}
			foreach ($data["requires"]["plugins"] as $plugin) {
				if (!is_array($plugin) || empty($plugin["slug"]) || !is_string($plugin["slug"])) {
					fwrite(STDERR, "wp-vibecoder.json plugin dependencies must be objects with a slug\n");
					exit(1);
				}
			}
		}
		if (isset($data["pages"])) {
			if (!is_array($data["pages"])) {
				fwrite(STDERR, "wp-vibecoder.json pages must be an array\n");
				exit(1);
			}
			$slugs = array();
			foreach ($data["pages"] as $page) {
				if (!is_array($page) || empty($page["title"]) || !is_string($page["title"]) || empty($page["slug"]) || !is_string($page["slug"])) {
					fwrite(STDERR, "wp-vibecoder.json pages must be objects with title and slug\n");
					exit(1);
				}
				if (!preg_match("/^[a-z0-9]+(?:-[a-z0-9]+)*$/", $page["slug"]) || "home" === $page["slug"]) {
					fwrite(STDERR, "wp-vibecoder.json page slugs must be lowercase URL slugs and must not be home\n");
					exit(1);
				}
				if (isset($slugs[$page["slug"]])) {
					fwrite(STDERR, "wp-vibecoder.json pages must use unique slugs\n");
					exit(1);
				}
				$slugs[$page["slug"]] = true;
				if (isset($page["status"]) && !in_array($page["status"], array("publish", "draft", "private"), true)) {
					fwrite(STDERR, "wp-vibecoder.json page status must be publish, draft, or private\n");
					exit(1);
				}
				if (array_key_exists("content", $page) || array_key_exists("excerpt", $page)) {
					fwrite(STDERR, "wp-vibecoder.json page declarations must not include content or excerpt\n");
					exit(1);
				}
				if (!empty($page["template"])) {
					if (!is_string($page["template"]) || false !== strpos($page["template"], "..") || ".php" !== substr($page["template"], -4) || !is_file($argv[2] . "/" . $page["template"])) {
						fwrite(STDERR, "wp-vibecoder.json page templates must reference PHP files inside the theme folder\n");
						exit(1);
					}
					if ("page-" . $page["slug"] . ".php" !== $page["template"]) {
						$template_source = file_get_contents($argv[2] . "/" . $page["template"], false, null, 0, 8192);
						if (false === $template_source || !preg_match("/Template Name\\s*:/i", $template_source)) {
							fwrite(STDERR, "Custom page templates must include a Template Name header unless they use page-{slug}.php\n");
							exit(1);
						}
					}
				}
			}
		}
	' "${CONFIG_FILE}" "${THEME_DIR}"

	while IFS= read -r -d '' file; do
		php -l "${file}" >/dev/null || exit 1
	done < <(find "${THEME_DIR}" -type f -name '*.php' -print0)
else
	warn "PHP CLI is unavailable; PHP lint and PHP-based checks were skipped."
	if command -v node >/dev/null 2>&1; then
		node -e '
			const fs = require("fs");
			const path = require("path");
			const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
			const themeDir = process.argv[2];
			const plugins = data && data.requires && data.requires.plugins;
			if (plugins !== undefined) {
				if (!Array.isArray(plugins)) {
					throw new Error("wp-vibecoder.json requires.plugins must be an array");
				}
				for (const plugin of plugins) {
					if (!plugin || Array.isArray(plugin) || typeof plugin !== "object" || typeof plugin.slug !== "string" || plugin.slug.length === 0) {
						throw new Error("wp-vibecoder.json plugin dependencies must be objects with a slug");
					}
				}
			}
			if (data.pages !== undefined) {
				if (!Array.isArray(data.pages)) {
					throw new Error("wp-vibecoder.json pages must be an array");
				}
				const slugs = new Set();
				for (const page of data.pages) {
					if (!page || Array.isArray(page) || typeof page !== "object" || typeof page.title !== "string" || page.title.length === 0 || typeof page.slug !== "string" || page.slug.length === 0) {
						throw new Error("wp-vibecoder.json pages must be objects with title and slug");
					}
					if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(page.slug) || page.slug === "home") {
						throw new Error("wp-vibecoder.json page slugs must be lowercase URL slugs and must not be home");
					}
					if (slugs.has(page.slug)) {
						throw new Error("wp-vibecoder.json pages must use unique slugs");
					}
					slugs.add(page.slug);
					if (page.status !== undefined && !["publish", "draft", "private"].includes(page.status)) {
						throw new Error("wp-vibecoder.json page status must be publish, draft, or private");
					}
					if (Object.prototype.hasOwnProperty.call(page, "content") || Object.prototype.hasOwnProperty.call(page, "excerpt")) {
						throw new Error("wp-vibecoder.json page declarations must not include content or excerpt");
					}
					if (page.template) {
						if (typeof page.template !== "string" || page.template.includes("..") || !page.template.endsWith(".php") || !fs.existsSync(path.join(themeDir, page.template))) {
							throw new Error("wp-vibecoder.json page templates must reference PHP files inside the theme folder");
						}
						if (page.template !== `page-${page.slug}.php`) {
							const templateSource = fs.readFileSync(path.join(themeDir, page.template), "utf8").slice(0, 8192);
							if (!/Template Name\s*:/i.test(templateSource)) {
								throw new Error("Custom page templates must include a Template Name header unless they use page-{slug}.php");
							}
						}
					}
				}
			}
		' "${CONFIG_FILE}" "${THEME_DIR}" ||
			fail "Invalid wp-vibecoder.json"
	elif command -v python3 >/dev/null 2>&1; then
		python3 - "${CONFIG_FILE}" "${THEME_DIR}" <<'PY' || fail "Invalid wp-vibecoder.json"
import json
import os
import re
import sys

with open(sys.argv[1], encoding="utf-8") as fh:
    data = json.load(fh)
theme_dir = sys.argv[2]

plugins = data.get("requires", {}).get("plugins")
if plugins is not None:
    if not isinstance(plugins, list):
        raise SystemExit("wp-vibecoder.json requires.plugins must be an array")
    for plugin in plugins:
        if not isinstance(plugin, dict) or not isinstance(plugin.get("slug"), str) or not plugin["slug"]:
            raise SystemExit("wp-vibecoder.json plugin dependencies must be objects with a slug")

pages = data.get("pages")
if pages is not None:
    if not isinstance(pages, list):
        raise SystemExit("wp-vibecoder.json pages must be an array")
    slugs = set()
    for page in pages:
        if not isinstance(page, dict) or not isinstance(page.get("title"), str) or not page["title"] or not isinstance(page.get("slug"), str) or not page["slug"]:
            raise SystemExit("wp-vibecoder.json pages must be objects with title and slug")
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", page["slug"]) or page["slug"] == "home":
            raise SystemExit("wp-vibecoder.json page slugs must be lowercase URL slugs and must not be home")
        if page["slug"] in slugs:
            raise SystemExit("wp-vibecoder.json pages must use unique slugs")
        slugs.add(page["slug"])
        if "status" in page and page["status"] not in ("publish", "draft", "private"):
            raise SystemExit("wp-vibecoder.json page status must be publish, draft, or private")
        if "content" in page or "excerpt" in page:
            raise SystemExit("wp-vibecoder.json page declarations must not include content or excerpt")
        if page.get("template"):
            template = page["template"]
            if not isinstance(template, str) or ".." in template or not template.endswith(".php") or not os.path.isfile(os.path.join(theme_dir, template)):
                raise SystemExit("wp-vibecoder.json page templates must reference PHP files inside the theme folder")
            if template != f"page-{page['slug']}.php":
                with open(os.path.join(theme_dir, template), encoding="utf-8", errors="ignore") as template_fh:
                    template_source = template_fh.read(8192)
                if not re.search(r"Template Name\s*:", template_source, re.IGNORECASE):
                    raise SystemExit("Custom page templates must include a Template Name header unless they use page-{slug}.php")
PY
	else
		warn "Neither Node.js nor Python is available; JSON syntax validation was skipped."
	fi
fi

style_version="$(
	sed -n 's/^[[:space:]]*Version:[[:space:]]*//p' "${THEME_DIR}/style.css" | head -1 | tr -d '\r'
)"
function_version="$(
	sed -n "s/.*WP_VIBECODER_STARTER_VERSION'[[:space:]]*,[[:space:]]*'\\([^']*\\)'.*/\\1/p" "${THEME_DIR}/functions.php" | head -1
)"
config_version="$(
	sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "${CONFIG_FILE}" | head -1
)"

[[ -n "${style_version}" ]] || fail "Theme Version header is missing."
[[ -n "${function_version}" ]] || fail "WP_VIBECODER_STARTER_VERSION is missing."
[[ -n "${config_version}" ]] || fail "wp-vibecoder.json version is missing."
[[ "${style_version}" == "${function_version}" ]] || fail "style.css and functions.php versions do not match."
[[ "${style_version}" == "${config_version}" ]] || fail "Theme and wp-vibecoder.json versions do not match."

if command -v php >/dev/null 2>&1; then
	php -r '
		$image = getimagesize($argv[1]);
		if (!$image || $image[0] !== 1200 || $image[1] !== 900 || $image[2] !== IMAGETYPE_PNG) {
			fwrite(STDERR, "screenshot.png must be a 1200x900 PNG\n");
			exit(1);
		}
	' "${THEME_DIR}/screenshot.png"
elif command -v sips >/dev/null 2>&1; then
	width="$(sips -g pixelWidth "${THEME_DIR}/screenshot.png" | awk '/pixelWidth/ {print $2}')"
	height="$(sips -g pixelHeight "${THEME_DIR}/screenshot.png" | awk '/pixelHeight/ {print $2}')"
	format="$(sips -g format "${THEME_DIR}/screenshot.png" | awk '/format/ {print $2}')"
	[[ "${width}" == "1200" && "${height}" == "900" && "${format}" == "png" ]] ||
		fail "screenshot.png must be a 1200x900 PNG."
elif command -v file >/dev/null 2>&1; then
	image_info="$(file "${THEME_DIR}/screenshot.png")"
	[[ "${image_info}" == *"PNG image data, 1200 x 900"* ]] ||
		fail "screenshot.png must be a 1200x900 PNG."
else
	warn "No image inspection tool is available; screenshot dimensions were not verified."
fi

if command -v php >/dev/null 2>&1; then
	while IFS= read -r reference; do
		[[ -z "${reference}" ]] && continue
		[[ "${reference}" =~ ^(https?:)?// ]] && continue
		[[ "${reference}" =~ ^(data:|#|mailto:|tel:) ]] && continue
		path="${reference%%\?*}"
		path="${path%%\#*}"
		[[ -e "${THEME_DIR}/${path}" ]] || fail "Missing local theme asset referenced in templates: ${reference}"
	done < <(
		php -r '
			foreach (glob($argv[1] . "/*.php") as $file) {
				$source = file_get_contents($file);
				if (preg_match_all("/(?:src|href)=[\"\x27]([^\"\x27]+)[\"\x27]/i", $source, $matches)) {
					foreach ($matches[1] as $value) {
						if (strpos($value, "<?") === false) {
							echo $value, PHP_EOL;
						}
					}
				}
			}
		' "${THEME_DIR}"
	)
else
	warn "Local asset-reference inspection was skipped because PHP CLI is unavailable."
fi

if [[ "${WARNINGS}" -gt 0 ]]; then
	echo "Validation completed with ${WARNINGS} warning(s). Release version: ${style_version}"
else
	echo "Validation passed. Release version: ${style_version}"
fi
