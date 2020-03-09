const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
);

const aliasConfig = {
  'jquery': 'jquery/src/jquery',
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js',
  'bootstrap-scss': 'bootstrap-scss-dist/bootstrap-scss'

};

environment.config.set('resolve.alias', aliasConfig);
module.exports = environment
