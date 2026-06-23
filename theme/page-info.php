<?php
/**
 * Info page template.
 *
 * @package WP_Vibecoder_Starter
 */

get_header();
?>

<main id="primary" class="site-main">
	<section class="site-container info-page">
		<header class="info-header">
			<p class="eyebrow"><?php esc_html_e( 'Info', 'wp-vibecoder-starter' ); ?></p>
			<h1 class="entry-title"><?php esc_html_e( 'Contact information', 'wp-vibecoder-starter' ); ?></h1>
			<p><?php esc_html_e( 'Basic contact details for this site. Replace the pending items with confirmed business information before launch.', 'wp-vibecoder-starter' ); ?></p>
		</header>

		<div class="contact-list" aria-label="<?php esc_attr_e( 'Contact details', 'wp-vibecoder-starter' ); ?>">
			<div class="contact-item">
				<span><?php esc_html_e( 'Email', 'wp-vibecoder-starter' ); ?></span>
				<strong><?php esc_html_e( 'Pending confirmation', 'wp-vibecoder-starter' ); ?></strong>
			</div>

			<div class="contact-item">
				<span><?php esc_html_e( 'Phone', 'wp-vibecoder-starter' ); ?></span>
				<strong><?php esc_html_e( 'Pending confirmation', 'wp-vibecoder-starter' ); ?></strong>
			</div>

			<div class="contact-item">
				<span><?php esc_html_e( 'Location', 'wp-vibecoder-starter' ); ?></span>
				<strong><?php esc_html_e( 'Pending confirmation', 'wp-vibecoder-starter' ); ?></strong>
			</div>
		</div>
	</section>
</main>

<?php
get_footer();
