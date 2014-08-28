var Flbuild = require('flbuild')
	, exec = require('done-exec')
    , gulp = require('gulp')

var flbuild = new Flbuild()
flbuild.setEnv('FLEX_HOME')
flbuild.setEnv('PROJECT_HOME', '.')
flbuild.setEnv('PLAYER_VERSION', '14.0')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')
flbuild.addLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
flbuild.addLibraryDirectory('$PROJECT_HOME/libs/')
flbuild.addSourceDirectory('$PROJECT_HOME/src')

// namespace 별로 패키징 한다
gulp.task('ssen', function(done) {
	var build = flbuild.getLibraryCreator()

	build.setFilterFunction(function(file) {
		return file.class.indexOf('ssen.') === 0
	})

	build.createBuildCommand('$PROJECT_HOME/bin/ssenkit.swc', function(cmd) {
		console.log(cmd)
		exec(cmd).run(done)
	})
})

gulp.task('ssen-mxchart', function(done) {
	var build = flbuild.getLibraryCreator()

	build.setFilterFunction(function(file) {
		return file.class.indexOf('ssen.components.mxChartSupportClasses') === 0
	})

	build.createBuildCommand('$PROJECT_HOME/bin/ssen-mxchart.swc', function(cmd) {
		console.log(cmd)
		exec(cmd).run(done)
	})
})

gulp.task('ssen-mxgrid', function(done) {
})

gulp.task('ssen-sparkgrid', function(done) {
})