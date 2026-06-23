<?php
/**
 * Fallback template.
 *
 * @package WP_Vibecoder_Starter
 */

get_header();
?>

<main id="primary" class="site-main site-container content-section">
	<?php if ( have_posts() ) : ?>
		<?php
		while ( have_posts() ) :
			the_post();
			?>
			<article id="post-<?php the_ID(); ?>" <?php post_class( 'entry' ); ?>>
				<?php the_title( '<h1 class="entry-title">', '</h1>' ); ?>
				<div class="entry-content"><?php the_content(); ?></div>
			</article>
			<?php
		endwhile;
		?>
	<?php else : ?>
		<p><?php esc_html_e( 'No content is available.', 'wp-vibecoder-starter' ); ?></p>
	<?php endif; ?>
</main>

<?php
get_footer();
