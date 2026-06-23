<?php
/**
 * Site header.
 *
 * @package WP_Vibecoder_Starter
 */
?>
<!doctype html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>
<a class="skip-link screen-reader-text" href="#primary"><?php esc_html_e( 'Skip to content', 'wp-vibecoder-starter' ); ?></a>

<header class="site-header">
	<div class="site-container site-header__inner">
		<a class="site-title" href="<?php echo esc_url( home_url( '/' ) ); ?>">
			<?php echo esc_html( get_bloginfo( 'name' ) ); ?>
		</a>
		<nav class="site-nav" aria-label="<?php esc_attr_e( 'Primary navigation', 'wp-vibecoder-starter' ); ?>">
			<a href="<?php echo esc_url( home_url( '/services/' ) ); ?>"><?php esc_html_e( 'Services', 'wp-vibecoder-starter' ); ?></a>
			<a href="<?php echo esc_url( home_url( '/info/' ) ); ?>"><?php esc_html_e( 'Info', 'wp-vibecoder-starter' ); ?></a>
		</nav>
	</div>
</header>
