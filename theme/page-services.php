<?php
/**
 * Services page template.
 *
 * @package WP_Vibecoder_Starter
 */

get_header();
?>

<main id="primary" class="site-main">
	<section class="site-container services-page">
		<header class="services-hero">
			<p class="eyebrow"><?php esc_html_e( 'Services', 'wp-vibecoder-starter' ); ?></p>
			<h1 class="entry-title"><?php esc_html_e( 'Simple demo services', 'wp-vibecoder-starter' ); ?></h1>
			<p><?php esc_html_e( 'A short sample page showing how a service offering could be presented in this theme.', 'wp-vibecoder-starter' ); ?></p>
		</header>

		<div class="services-grid" aria-label="<?php esc_attr_e( 'Demo services', 'wp-vibecoder-starter' ); ?>">
			<article class="service-card">
				<h2><?php esc_html_e( 'Web Design', 'wp-vibecoder-starter' ); ?></h2>
				<p><?php esc_html_e( 'Clean page layouts, reusable sections, and visual direction for a small business website.', 'wp-vibecoder-starter' ); ?></p>
			</article>

			<article class="service-card">
				<h2><?php esc_html_e( 'WordPress Setup', 'wp-vibecoder-starter' ); ?></h2>
				<p><?php esc_html_e( 'Basic theme configuration, pages, and content structure prepared for editing.', 'wp-vibecoder-starter' ); ?></p>
			</article>

			<article class="service-card">
				<h2><?php esc_html_e( 'Maintenance', 'wp-vibecoder-starter' ); ?></h2>
				<p><?php esc_html_e( 'Simple updates, layout adjustments, and ongoing improvements for demo purposes.', 'wp-vibecoder-starter' ); ?></p>
			</article>
		</div>
	</section>
</main>

<?php
get_footer();
