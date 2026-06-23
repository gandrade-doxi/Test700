<?php
/**
 * Site footer.
 *
 * @package WP_Vibecoder_Starter
 */
?>
<footer class="site-footer">
	<div class="site-container site-footer__inner">
		<p>
			<?php
			printf(
				/* translators: %s: Current year. */
				esc_html__( '© %s. All rights reserved.', 'wp-vibecoder-starter' ),
				esc_html( wp_date( 'Y' ) )
			);
			?>
		</p>
	</div>
</footer>

<?php wp_footer(); ?>
</body>
</html>
