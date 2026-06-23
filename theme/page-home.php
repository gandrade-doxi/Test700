<?php
/**
 * Home page template.
 *
 * @package WP_Vibecoder_Starter
 */

get_header();
?>

<main id="primary" class="site-main">
	<section class="hero">
		<div class="site-container hero__inner">
			<p class="eyebrow"><?php esc_html_e( 'WP Vibecoder Starter', 'wp-vibecoder-starter' ); ?></p>
			<h1><?php echo esc_html( get_bloginfo( 'name' ) ); ?></h1>
			<p><?php echo esc_html( get_bloginfo( 'description' ) ); ?></p>
			<a class="button-link" href="#landing-content"><?php esc_html_e( 'Explore the site', 'wp-vibecoder-starter' ); ?></a>
		</div>
	</section>

	<section id="landing-content" class="site-container content-section">
		<h2><?php esc_html_e( 'Build the corporate homepage here.', 'wp-vibecoder-starter' ); ?></h2>
		<p><?php esc_html_e( 'Codex should edit page-home.php whenever the homepage changes. Keep the WP Vibecoder Home page content empty.', 'wp-vibecoder-starter' ); ?></p>
	</section>
</main>

<?php
get_footer();
