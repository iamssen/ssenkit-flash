var fl = require('flbuild')
	, exec = require('done-exec')
	, gulp = require('gulp')
	, fs = require('fs')
	, run = require('gulp-sequence')

var config = new fl.Config()
// , 'C:\\Users\\ssen\\Settings\\flex_sdk\\4.6.0'
config.setEnv('FLEX_HOME')
config.setEnv('PROJECT_HOME', '.')
config.setEnv('PLAYER_VERSION', '16.0')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/mx/')
config.addExternalLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
config.addLibraryDirectory('$PROJECT_HOME/libs/')
config.addSourceDirectory('$PROJECT_HOME/src')
config.addArg('-warnings=false')

// namespace 별로 패키징 한다
gulp.task('build', function (done) {
	var lib = new fl.Lib(config)

	lib.filterFunction = function (asclass) {
		return asclass.classpath.indexOf('ssen.') === 0
			&& asclass.classpath.toLowerCase().indexOf('ssen.components.mxChartSupportClasses') === -1
			&& asclass.classpath.toLowerCase().indexOf('ssen.components.sparkDatagridSupportClasses') === -1
			&& asclass.classpath.toLowerCase().indexOf('showcase__') === -1
			&& asclass.classpath.toLowerCase().indexOf('_showcase_') === -1
			&& asclass.classpath.toLowerCase().indexOf('test__') === -1
	}

	lib.createBuildCommand('$PROJECT_HOME/bin/ssenkit.swc', function (cmd) {
		console.log('======================================================================')
		console.log(cmd)
		exec(cmd).run(done)
	})
})

gulp.task('publish', function() {
	return gulp.src('bin/ssenkit.swc')
		.pipe(gulp.dest('C:\\Users\\ssen\\Workspace\\LPIMS_FLEX_EXECUTOR\\libs'))
})

gulp.task('default', run('build', 'publish'))

//gulp.task('ssen-mxchart', function (done) {
//	var lib = new fl.Lib(config)
//
//	lib.filterFunction = function (asclass) {
//		return asclass.classpath.indexOf('ssen.components.mxChartSupportClasses') === 0
//	}
//
//	lib.createBuildCommand('$PROJECT_HOME/bin/ssen-mxchart.swc', function (cmd) {
//		exec(cmd).run(done)
//	})
//})
//
//gulp.task('ssen-mxgrid', function (done) {
//})
//
//gulp.task('ssen-sparkgrid', function (done) {
//})