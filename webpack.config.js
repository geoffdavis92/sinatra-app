'use strict';
const webpack = require('webpack'),
	  DashboardPlugin = require('webpack-dashboard/plugin');

module.exports = {
    entry: './scripts/index.js',
    output: {
    	path: `${__dirname}/assets/js`,
    	filename: 'bundle.js'
    },
    debug: true,
    module: {
    	loaders: [
    		{ test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader', query: { presets: ['react','es2015','flow'] } }//?presets[]=es2015,flow' }
    	]
    }/*,
    plugins: [ new DashboardPlugin() ]
    */
}