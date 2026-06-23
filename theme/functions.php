<?php
/**
 * Theme setup and assets.
 *
 * @package WP_Vibecoder_Starter
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'WP_VIBECODER_STARTER_VERSION', '1.0' );

/**
 * Configure supported WordPress features.
 */
function wp_vibecoder_starter_setup() {
	add_theme_support( 'title-tag' );
	add_theme_support( 'post-thumbnails' );
	add_theme_support( 'responsive-embeds' );
	add_theme_support( 'align-wide' );
	add_theme_support( 'html5', array( 'comment-list', 'comment-form', 'search-form', 'gallery', 'caption', 'style', 'script' ) );
	add_theme_support(
		'custom-logo',
		array(
			'height'      => 80,
			'width'       => 240,
			'flex-height' => true,
			'flex-width'  => true,
		)
	);
}
add_action( 'after_setup_theme', 'wp_vibecoder_starter_setup' );

/**
 * Enqueue production assets.
 */
function wp_vibecoder_starter_assets() {
	wp_enqueue_style(
		'wp-vibecoder-starter-style',
		get_stylesheet_uri(),
		array(),
		WP_VIBECODER_STARTER_VERSION
	);
}
add_action( 'wp_enqueue_scripts', 'wp_vibecoder_starter_assets' );
