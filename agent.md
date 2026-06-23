# WP Vibecoder Agent Instructions

This repository is a WordPress theme project synchronized by WP Vibecoder.

## Working rules

- Work mainly inside `/theme`. It is the production source.
- Use `/preview` for quick static prototypes and screenshot generation. It is never the production source.
- During experimentation, `/preview` may temporarily differ from `/theme`.
- Before completing a visual homepage change, update `/preview` so it represents the delivered design closely enough for review and screenshot generation.
- If a task does not affect the homepage visually, `/preview` does not need to change.
- In restricted cloud environments, run all available validations and report skipped checks as warnings.
- If Chrome or Chromium cannot generate a screenshot, keep or restore the bundled default WP Vibecoder screenshot and report the exact reason screenshot generation was skipped.
- Never modify WordPress core files.
- Use WordPress APIs, template hierarchy, escaping functions, and enqueue APIs.
- Use Advanced Custom Fields only when editable content explicitly requires it.
- When ACF is used, declare it in `wp-vibecoder.json` under `requires.plugins` as an object with `name`, `slug`, and `required`; do not use a plain string entry.
- Do not invent or reference helper functions that do not exist.
- Verify every referenced function and asset exists.
- Escape output and sanitize input according to WordPress coding practices.
- Validate PHP syntax before completing work.
- Perform final visual validation in a real local WordPress installation.
- LocalWP is recommended but is not a dependency.
- After any visual change that affects the homepage, preview, theme branding, layout, or first-screen appearance, run `./scripts/generate-theme-screenshot.sh` before completion so `theme/screenshot.png` reflects the delivered design.
- The WordPress theme screenshot must be a 1200×900 PNG.

## Missing Brand Content

- When brand content is missing, create one coherent visual and copy direction so work can continue.
- Do not present invented contact details, claims, addresses, certifications, prices, testimonials, or legal statements as verified facts.
- Clearly list every invented or provisional value in the completion report.
- Before production delivery, replace or obtain explicit approval for all provisional phone numbers, email addresses, domains, author names, social links, business addresses, legal URLs, and external URLs.
- Never leave `example.com`, `Your Name`, lorem ipsum, placeholder phone numbers, empty links, or `#` links in a production-ready result.

## Assets

- Store project images in `theme/assets/images/` when assets are needed.
- Store additional CSS in `theme/assets/css/` and JavaScript in `theme/assets/js/`.
- Prefer SVG for simple logos and icons, WebP or AVIF for photographs, and PNG only when transparency or compatibility requires it.
- Keep ordinary raster images below 500 KB when practical. Optimize larger hero images and document any justified exception.
- Use descriptive lowercase kebab-case filenames.
- Do not hotlink production assets from temporary or third-party URLs.
- Verify every referenced asset exists before completion.

## JavaScript

- Add JavaScript only when the interaction cannot be implemented reliably with HTML and CSS.
- Prefer small dependency-free scripts.
- Enqueue scripts from `functions.php` with `wp_enqueue_script`; do not hardcode script tags in templates.
- Load frontend scripts in the footer unless there is a documented reason not to.
- Escape server data and pass dynamic values with WordPress APIs such as `wp_localize_script` or `wp_add_inline_script`.

## Technical Identity

- Preserve the PHP function prefix, package namespace, script/style handles, and text domain for compatibility by default.
- The commercial site name and visible brand may change without renaming technical identifiers.
- Rename technical identifiers only when explicitly requested and update every reference consistently.
- Do not perform a technical-identifier rename on an already deployed site without documenting migration and compatibility impact.

## Versioning

- Keep the starter version at `1.0` during private development and testing.
- Do not increment versions for content, style, layout, internal releases, or distributable test ZIPs.
- Versioning begins only when WP Vibecoder is prepared for its official WordPress.org release.
- At that point, increment `Version` in `theme/style.css`, `WP_VIBECODER_STARTER_VERSION` in `theme/functions.php`, and `version` in `wp-vibecoder.json` together.
- Keep all three values identical.
- Use semantic versioning: patch for fixes, minor for backward-compatible features, and major for breaking changes.

## Homepage Convention

- The homepage is a real WordPress page with slug `wp-vibecoder-home`.
- WP Vibecoder creates and assigns the `WP Vibecoder Home` page as the static homepage.
- The homepage layout must be implemented in `theme/page-home.php`.
- WP Vibecoder routes the managed front page to `page-home.php`; do not rely on the page slug for template loading.
- When modifying the homepage, edit `page-home.php`.
- Keep the WP Vibecoder Home page content editor empty.
- The WP Vibecoder Home page exists for SEO, metadata, OpenGraph, ACF, Gutenberg compatibility, previews, revisions, and future CMS features.
- Do not use the WP Vibecoder Home page content editor for homepage layout.
- Do not use `front-page.php`.
- Do not place homepage layout in `index.php`.
- Do not implement blog functionality unless explicitly requested.

## Routing Convention

- `page-home.php` = homepage.
- `page.php` = standard pages.
- `page-{slug}.php` = custom page layouts only when required.
- `single.php` = individual posts.
- `index.php` = fallback.

## Page Creation Convention

WP Vibecoder follows a page-first architecture.

- Landing-page sections belong in `page-home.php`.
- Hero, About, Services, Testimonials, FAQ, Contact, Pricing, and CTA sections do not require separate WordPress pages.
- Create a separate WordPress page only when a dedicated URL is explicitly required.
- Standard dedicated pages use `page.php` by default.
- Use `page-{slug}.php` only when that page requires a unique layout.
- Do not place internal page layouts inside `page-home.php`.
- Do not create additional pages unless a dedicated URL is required.
- When creating a dedicated page, add it to `wp-vibecoder.json` under `pages` so WP Vibecoder creates or updates the WordPress page during sync.
- Do not add `Home` to `pages`; WP Vibecoder manages the homepage separately.
- Page declarations use lowercase URL slugs and may reference a template file.
- Page declarations must not include `content` or `excerpt`; WP Vibecoder creates pages with an empty editor and preserves manually edited content.
- Put repository-managed page layout and demo copy in `page.php` or `page-{slug}.php`, not in the WordPress page editor.
- A `page-{slug}.php` file is a WordPress template hierarchy file and does not need a `Template Name` header. Any other page template referenced in `wp-vibecoder.json` must include a `Template Name` header.

Examples:

- “Add a Services section” → modify `page-home.php`.
- “Add a FAQ section” → modify `page-home.php`.
- “Create a Contact page” → create page `Contact` with slug `contact`; use `page.php` or `page-contact.php`.
- “Create a Services page” → create page `Services` with slug `services`; use `page.php` or `page-services.php`.

Example `wp-vibecoder.json` page declaration:

```json
{
  "title": "Contact",
  "slug": "contact",
  "template": "page-contact.php",
  "status": "publish"
}
```

## Completion checklist

1. The production implementation is in `/theme`.
2. The homepage implementation is in `/theme/page-home.php`.
3. `style.css` still contains valid `Theme Name` and `Version` headers.
4. Release versions match across `style.css`, `functions.php`, and `wp-vibecoder.json`.
5. `theme/screenshot.png` is a valid 1200×900 PNG and was regenerated after visual changes, or screenshot generation was explicitly reported as unavailable.
6. The assigned WP Vibecoder Home page content remains empty.
7. No `front-page.php` or `home.php` was introduced.
8. Every referenced function, template, script, stylesheet, image, and ACF field exists.
9. PHP syntax and repository validation pass with `./scripts/validate.sh`.
10. The final homepage design is represented in `/preview` when the task changed it visually.
11. The theme was checked in WordPress, not only in `/preview`.
12. If WordPress validation was unavailable, state this explicitly and list what was validated instead.
13. All provisional brand and contact data is disclosed in the completion report.
14. `wp-vibecoder.json` reflects any added dedicated page in `pages`.
15. `wp-vibecoder.json` reflects any added plugin dependency using object entries such as `{ "name": "Advanced Custom Fields", "slug": "advanced-custom-fields", "required": false }`.
