<?php

define( 'DB_NAME',     getenv( 'DB_NAME' ) );
define( 'DB_USER',     getenv( 'DB_USER' ) );
define( 'DB_PASSWORD', getenv( 'DB_PASSWORD' ));
define( 'DB_HOST',     getenv( 'DB_HOST' ) );

$table_prefix = getenv( 'DB_PREFIX' );

defined( 'ABSPATH' ) or define( 'ABSPATH', '/wp/' );
defined( 'WP_CONTENT_DIR' ) or define( 'WP_CONTENT_DIR', '/content' );


